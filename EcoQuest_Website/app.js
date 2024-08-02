const express = require('express');
const mysql = require('mysql2');
const bcrypt = require('bcryptjs');
const multer = require('multer');
const bodyParser = require('body-parser');

const app = express();

// Configure body-parser middleware
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

// Create MySQL connection
const connection = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'c237_ecoquest'
});
connection.connect((err) => {
    if (err) {
        console.error('Error connecting to MySQL:', err);
        return;
    }
    console.log('Connected to MySQL database');
});

// Set up multer for file uploads
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, 'public/images'); // Directory to save uploaded files
    },
    filename: (req, file, cb) => {
        cb(null, file.originalname); // Use the original file name
    }
});

const upload = multer({ storage: storage });

// Set up view engine
app.set('view engine', 'ejs');

// Enable static files
app.use(express.static('public'));

// Middleware to parse JSON and URL-encoded form data
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Define routes
app.get('/', (req, res) => {
    res.render('login', { error: false });
});

app.get('/register', (req, res) => {
    res.render('register');
});

app.post('/register', async (req, res) => {
    const { username, password, email } = req.body;
    const hashedPassword = await bcrypt.hash(password, 8);

    const sql = 'INSERT INTO account (username, password, email) VALUES (?, ?, ?)';
    connection.query(sql, [username, hashedPassword, email], (error, results) => {
        if (error) {
            console.error('Error registering user:', error);
            res.status(500).send('Error registering user');
        } else {
            // Redirect to /login after successful registration
            res.redirect('/login');
        }
    });
});

app.get('/login', (req, res) => {
    res.render('login', { error: false });
});

app.post('/login', (req, res) => {
    const { username, password } = req.body;
    const query = 'SELECT * FROM account WHERE username = ?';
    connection.query(query, [username], (err, results) => {
        if (err) {
            console.error('Login error:', err);
            return res.status(500).send('An error occurred during login');
        }
        if (results.length === 0) {
            return res.render('login', { error: true });
        }
        const user = results[0];
        bcrypt.compare(password, user.password, (err, isMatch) => {
            if (err) {
                console.error('Password comparison error:', err);
                return res.status(500).send('An error occurred during password comparison');
            }
            if (!isMatch) {
                return res.render('login', { error: true });
            }
            // Redirect to /home with the user's ID
            res.redirect(`/home/${user.account_id}`);
        });
    });
});

app.get('/home/:id', (req, res) => {
    // Check if the user with the specified id exists in the database
    const userQuery = 'SELECT * FROM account WHERE account_id = ?';
    const articleQuery = 'SELECT * FROM article';

    connection.query(userQuery, [req.params.id], (err, userResults) => {
        if (err) {
            console.error('Error retrieving user:', err);
            return res.status(500).send('An error occurred');
        }
        if (userResults.length === 0) {
            return res.status(404).send('User not found');
        }

        connection.query(articleQuery, (err, articleResults) => {
            if (err) {
                console.error('Error retrieving articles:', err);
                return res.status(500).send('An error occurred');
            }

            // Render the home page for the authenticated user
            res.render('home', { user: userResults[0], articles: articleResults });
        });
    });
});

app.get('/leaderboard/:id', (req, res) => {
    const userId = req.params.id; // Assuming this is the current user's ID
    const query = 'SELECT username, points_donated, account_id FROM account ORDER BY points_donated DESC';
    connection.query(query, (err, results) => {
        if (err) {
            console.error('Error fetching leaderboard:', err);
            return res.status(500).send('Error fetching leaderboard');
        }
        // Pass both the leaderboard accounts and the current user's ID to the template
        res.render('leaderboard', { account: results, userId: userId });
    });
});

app.get('/addArticle', (req, res) => {
    res.render('addArticle');
});

app.post('/addArticle', upload.single('image'), (req, res) => {
    const { title, content, total_points } = req.body;
    let image = req.file ? req.file.filename : null; // Ensure image is defined

    const sql = 'INSERT INTO article (title, image, content, total_points) VALUES (?, ?, ?, ?)';
    connection.query(sql, [title, image, content, total_points], (error, results) => {
        if (error) {
            console.error('Error adding article:', error);
            res.status(500).send('Error adding article');
        } else {
            // Assuming you want to redirect to a specific article page, ensure the redirection is correct
            // Redirect to the home page or an appropriate page since results.insertId might not refer to an article ID
            res.redirect(`/home/${results.insertId}`); // Adjusted for a general redirect, replace with your intended route
        }
    });
});

app.get('/donation/:id', (req, res) => {
    const userId = req.params.id; // Extract the user ID from the request parameters
    const query = 'SELECT * FROM charity'; 
    const accountQuery = 'SELECT account_id, total_points, points_donated FROM account WHERE account_id = ?';

    connection.query(query, accountQuery, (err, results) => {
        if (err) {
            console.error('Error fetching charities:', err);
            return res.status(500).send('Error fetching charities');
        }

        res.render('donation', { userId: userId, results : results }); // Pass the userId to the donation template
    });
});

app.post('/donation/:id', (req, res) => {
    const userId = req.params.id; // Extract userId from the URL parameter
    const { amount } = req.body; // Extract the donation amount from the request body

    // First, retrieve the current points for the user
    const query = 'SELECT total_points, points_donated FROM account WHERE account_id = ?';
    connection.query(query, [userId], (err, results) => {
        if (err) {
            console.error('Error fetching user account:', err);
            return res.status(500).send('Error fetching user account');
        }
        if (results.length === 0) {
            return res.status(404).send('User not found');
        }

        const user = results[0];
        if (user.total_points < amount) {
            return res.status(400).send('Insufficient points to donate');
        }

        // Update the user's total_points and points_donated in the account table
        const updateQuery = 'UPDATE account SET total_points = total_points + ?, points_donated = points_donated + ? WHERE account_id = ?';
        connection.query(updateQuery, [amount, amount, userId], (err, result) => {
            if (err) {
                console.error('Error updating user account:', err);
                return res.status(500).send('Error updating user account');
            }
            console.log(`User ${userId} donated ${amount} points`);
            res.send('Donation successful');
        });
    });
});
app.get('/quiz/:userId/:article_id', (req, res) => {
    const { userId, article_id } = req.params; // Extract userId and articleId from the request parameters

    const query = `
        SELECT q.question_id, q.question, q.point_worth, c.choice_1, c.choice_2, c.choice_3, c.choice_4, c.correct_choice
        FROM question q
        JOIN choices c ON q.question_id = c.question_id
    `;

    connection.query(query, (err, results) => {
        if (err) {
            console.error('Error fetching quiz questions:', err);
            return res.status(500).send('Error fetching quiz questions');
        }

        // Transform results to match the expected structure in quiz.ejs
        const questions = results.map(row => ({
            question_id: row.question_id,
            question: row.question,
            choices: [
                { choice_id: 'choice_1', choice_text: row.choice_1 },
                { choice_id: 'choice_2', choice_text: row.choice_2 },
                { choice_id: 'choice_3', choice_text: row.choice_3 },
                { choice_id: 'choice_4', choice_text: row.choice_4 }
            ]
        }));

        res.render('quiz', { userId: userId, article: article_id, questions: questions });
    });
});

app.post('/submitQuiz/:userId', async (req, res) => {
    const userId = req.params.userId;
    const articleId = req.params.articleId;
    const userAnswers = req.body; // Assuming the format is { questionId: choiceId, ... }
    let totalScore = 0;
    let totalPointsAvailable = 0;

    try {
        // Retrieve correct answers and points for each question based on article_id
        const questions = await new Promise((resolve, reject) => {
            const query = `
                SELECT q.question_id, c.correct_choice, q.point_worth
                FROM question q
                JOIN choices c ON q.question_id = c.question_id
                WHERE q.article_id = ?
            `;
            connection.query(query, [articleId], (err, results) => {
                if (err) reject(err);
                resolve(results);
            });
        });

        // Calculate total score and total points available
        questions.forEach(question => {
            totalPointsAvailable += question.point_worth;
            const userChoice = userAnswers[question.question_id];
            if (userChoice === question.correct_choice) {
                totalScore += question.point_worth;
            }
        });

        // Calculate percentage score and determine grade
        const percentageScore = (totalScore / totalPointsAvailable) * 100;
        let grade;
        if (percentageScore >= 90) {
            grade = 'A';
        } else if (percentageScore >= 80) {
            grade = 'B';
        } else if (percentageScore >= 70) {
            grade = 'C';
        } else if (percentageScore >= 60) {
            grade = 'D';
        } else {
            grade = 'F';
        }

        // Update the user's total points in the account table
        const updatePointsQuery = 'UPDATE account SET total_points = total_points + ? WHERE account_id = ?';
        await new Promise((resolve, reject) => {
            connection.query(updatePointsQuery, [totalScore, userId], (err, result) => {
                if (err) reject(err);
                resolve(result);
            });
        });

        // Redirect to quiz_submitted.ejs with the score, grade, and userId
        res.render('quizSubmitted', { percentageScore: percentageScore, grade: grade, userId: userId });
    } catch (error) {
        console.error('Error submitting quiz:', error);
        res.status(500).send('Error submitting quiz');
    }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
