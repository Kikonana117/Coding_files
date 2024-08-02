-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 18, 2024 at 05:53 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `c237_ecoquest`
--

-- --------------------------------------------------------

--
-- Table structure for table `account`
--

CREATE TABLE `account` (
  `account_id` int(11) NOT NULL,
  `username` varchar(30) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL,
  `quiz_completed` int(11) DEFAULT NULL,
  `total_points` int(11) DEFAULT NULL,
  `points_donated` int(11) DEFAULT NULL,
  `isAdmin` bit(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `account`
--

INSERT INTO `account` (`account_id`, `username`, `password`, `email`, `quiz_completed`, `total_points`, `points_donated`, `isAdmin`) VALUES
(1, 'admin1', '$2a$08$YaeY4EHyOp3tMz32MI3mK.UF/x4XotNR8WpCdYeedaozrXnqvfmw2', 'admin1@gmail.com', 0, 0, 0, b'0'),
(5, 'admin2', '$2a$08$I86Buq30Pgzqd1JWyB7pA.JRcna8uRcqP96guiXr84DfUL7Eh2UyC', 'admin2@gmail.com', 0, 0, 0, b'0'),
(7, 'admin3', '$2a$08$Mi8L/9uOpFldVwyvAWiO7.bofLHcBkJtFfYFoTu.H25wR01XxSwj2', 'admin3@gmail.com', 0, 0, 0, b'0'),
(8, 'admin5', '$2a$08$rMb9ANircB7HBVY5Xwxh7uybzKmRwB5w9rylncHOS3O5koV93LuaG', 'admin5@gmail.com', 0, 40000, 6000, b'1');

-- --------------------------------------------------------

--
-- Table structure for table `article`
--

CREATE TABLE `article` (
  `article_id` int(11) NOT NULL,
  `title` varchar(60) NOT NULL,
  `image` varchar(255) NOT NULL,
  `content` mediumtext NOT NULL,
  `link` varchar(255) NOT NULL,
  `total_points` int(11) NOT NULL,
  `points_scored` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `article`
--

INSERT INTO `article` (`article_id`, `title`, `image`, `content`, `link`, `total_points`, `points_scored`) VALUES
(1, 'How to tell if your appliances are environmentally friendly', 'rrappliances1407.avif', 'The article discusses how Housing Board (HDB) households in Singapore can use $300 e-vouchers, provided under the Climate Friendly Households Programme, to purchase eco-friendly appliances from 14 participating retailers.\r\n\r\nThe article also recommends using energy monitoring devices to track consumption and calculating the payback period to determine if upgrading appliances is cost-effective. Selecting efficient appliances and maintaining them well can significantly contribute to environmental sustainability.', 'https://www.straitstimes.com/singapore/environment/how-to-tell-if-your-appliances-are-environmentally-friendly', 100, 0),
(2, 'How does climate change affect animals?', 'crab.jpg', 'The article explains how climate change impacts wildlife through rising temperatures, extreme weather, ocean warming, and habitat loss. It uses examples like green sea turtles, cheetahs, penguins, basking sharks, bees, and polar bears to illustrate these effects and stresses the need for education and action to mitigate these impacts and protect the environment.', 'https://plasticfreeschools.org.uk/how-does-climate-change-affect-animals/', 100, 0);

-- --------------------------------------------------------

--
-- Table structure for table `charity`
--

CREATE TABLE `charity` (
  `charity_id` int(11) NOT NULL,
  `image` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `donation_info_msg` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `charity`
--

INSERT INTO `charity` (`charity_id`, `image`, `name`, `donation_info_msg`) VALUES
(1, 'tree.jpg', 'Support EcoQuest ', 'Your donation helps us to maintain the website and fund more eco-friendly charities, projects and research.');

-- --------------------------------------------------------

--
-- Table structure for table `choices`
--

CREATE TABLE `choices` (
  `article_id` int(11) NOT NULL,
  `question_id` int(11) NOT NULL,
  `choice_1` varchar(255) NOT NULL,
  `choice_2` varchar(255) NOT NULL,
  `choice_3` varchar(255) NOT NULL,
  `choice_4` varchar(255) NOT NULL,
  `correct_choice` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='choices';

--
-- Dumping data for table `choices`
--

INSERT INTO `choices` (`article_id`, `question_id`, `choice_1`, `choice_2`, `choice_3`, `choice_4`, `correct_choice`) VALUES
(1, 1, 'By visiting a local community center', 'By logging on at RedeemSG using their Singpass accounts', 'By calling the National Environment Agency', 'By submitting an application via email', 'By logging on at RedeemSG using their Singpass accounts'),
(1, 2, 'PUB\'s water label', 'NEA’s energy label', 'SP Group\'s green label', 'HDB\'s eco label', 'NEA’s energy label'),
(1, 3, 'The brand of the appliance', 'The color of the appliance', 'The annual energy consumption based on typical usage ', 'The price of the appliance', 'The annual energy consumption based on typical usage'),
(1, 4, 'Checking the electricity bill', 'Using energy monitoring devices', 'Consulting the appliance manual', 'Asking the retailer', 'Using energy monitoring devices'),
(1, 5, 'The warranty period', 'The initial cost', 'Whether it is part of a take-back scheme', 'The country of manufacture', 'Whether it is part of a take-back scheme');

-- --------------------------------------------------------

--
-- Table structure for table `question`
--

CREATE TABLE `question` (
  `question_id` int(11) NOT NULL,
  `question` varchar(255) NOT NULL,
  `point_worth` int(11) NOT NULL,
  `article_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `question`
--

INSERT INTO `question` (`question_id`, `question`, `point_worth`, `article_id`) VALUES
(1, 'How can HDB residents claim their climate vouchers?', 20, 1),
(2, 'Which label indicates the relative energy efficiency of an appliance?', 20, 1),
(3, 'What should consumers consider beyond energy labels when buying appliances?', 20, 1),
(4, 'What is one suggested method to determine which appliance uses the most energy?', 20, 1),
(5, 'What factor should consumers consider regarding the lifespan of an appliance?', 20, 1);

-- --------------------------------------------------------

--
-- Table structure for table `user_choice`
--

CREATE TABLE `user_choice` (
  `user_id` int(11) NOT NULL,
  `article_id` int(11) NOT NULL,
  `question_id` int(11) NOT NULL,
  `chosen_choice` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `account`
--
ALTER TABLE `account`
  ADD PRIMARY KEY (`account_id`);

--
-- Indexes for table `article`
--
ALTER TABLE `article`
  ADD PRIMARY KEY (`article_id`);

--
-- Indexes for table `charity`
--
ALTER TABLE `charity`
  ADD PRIMARY KEY (`charity_id`);

--
-- Indexes for table `choices`
--
ALTER TABLE `choices`
  ADD KEY `article_id` (`article_id`),
  ADD KEY `question_id` (`question_id`);

--
-- Indexes for table `question`
--
ALTER TABLE `question`
  ADD PRIMARY KEY (`question_id`),
  ADD KEY `article_id` (`article_id`);

--
-- Indexes for table `user_choice`
--
ALTER TABLE `user_choice`
  ADD KEY `user_id` (`user_id`),
  ADD KEY `article_id` (`article_id`),
  ADD KEY `question_id` (`question_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `account`
--
ALTER TABLE `account`
  MODIFY `account_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `article`
--
ALTER TABLE `article`
  MODIFY `article_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `charity`
--
ALTER TABLE `charity`
  MODIFY `charity_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `question`
--
ALTER TABLE `question`
  MODIFY `question_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `choices`
--
ALTER TABLE `choices`
  ADD CONSTRAINT `choices_ibfk_1` FOREIGN KEY (`article_id`) REFERENCES `article` (`article_id`),
  ADD CONSTRAINT `choices_ibfk_2` FOREIGN KEY (`question_id`) REFERENCES `question` (`question_id`);

--
-- Constraints for table `question`
--
ALTER TABLE `question`
  ADD CONSTRAINT `question_ibfk_1` FOREIGN KEY (`article_id`) REFERENCES `article` (`article_id`);

--
-- Constraints for table `user_choice`
--
ALTER TABLE `user_choice`
  ADD CONSTRAINT `user_choice_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `account` (`account_id`),
  ADD CONSTRAINT `user_choice_ibfk_2` FOREIGN KEY (`article_id`) REFERENCES `article` (`article_id`),
  ADD CONSTRAINT `user_choice_ibfk_3` FOREIGN KEY (`question_id`) REFERENCES `question` (`question_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
