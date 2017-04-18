-- phpMyAdmin SQL Dump
-- version 4.0.10.12
-- http://www.phpmyadmin.net
--
-- Machine: 127.11.163.2:3306
-- Genereertijd: 18 apr 2017 om 17:06
-- Serverversie: 5.5.52
-- PHP-versie: 5.3.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Databank: `checkin`
--

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `ch_checkins`
--

CREATE TABLE IF NOT EXISTS `ch_checkins` (
  `user_name` varchar(50) CHARACTER SET utf8 NOT NULL,
  `locatie` int(11) NOT NULL,
  `checkinTimestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Gegevens worden uitgevoerd voor tabel `ch_checkins`
--


-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `ch_config`
--

CREATE TABLE IF NOT EXISTS `ch_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sleutel` varchar(20) NOT NULL,
  `waarde` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `key` (`sleutel`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Gegevens worden uitgevoerd voor tabel `ch_config`
--

INSERT INTO `ch_config` (`id`, `sleutel`, `waarde`) VALUES
(2, 'maxWerkplekken', '28'),
(3, 'maxWerkplekkenImCkc', '11');

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `ch_data`
--

CREATE TABLE IF NOT EXISTS `ch_data` (
  `user_name` varchar(20) NOT NULL,
  `datum` date NOT NULL,
  `soort` varchar(1) NOT NULL,
  `uren` decimal(3,1) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_name`,`datum`),
  KEY `datum` (`datum`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Gegevens worden uitgevoerd voor tabel `ch_data`
--


-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `ch_functies`
--

CREATE TABLE IF NOT EXISTS `ch_functies` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `naam` varchar(64) NOT NULL,
  `code` varchar(5) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=14 ;

--
-- Gegevens worden uitgevoerd voor tabel `ch_functies`
--

INSERT INTO `ch_functies` (`ID`, `naam`, `code`) VALUES
(1, 'Bouwer', 'B'),
(2, 'Lead Bouwer', 'LB'),
(3, 'Ontwerper', 'O'),
(4, 'Development manager', 'DM'),
(7, 'Architect', 'A'),
(8, 'Tester', 'T'),
(9, 'Redacteur', 'RED'),
(10, 'Interactie ontwerper', 'UX'),
(11, 'Fiscalist', 'FI'),
(12, 'Scrum master', 'SM'),
(13, 'Product owner', 'PO');

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `ch_locaties`
--

CREATE TABLE IF NOT EXISTS `ch_locaties` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `locatie` varchar(20) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=9 ;

--
-- Gegevens worden uitgevoerd voor tabel `ch_locaties`
--

INSERT INTO `ch_locaties` (`id`, `locatie`, `timestamp`) VALUES
(1, 'Thuis / Elders', '2015-05-11 08:49:10'),
(2, 'Walterbos F3.43', '2015-04-30 17:58:33'),
(3, 'Walterbos F3.49', '2015-04-30 17:58:53'),
(4, 'Walterbos F3.60', '2015-05-11 08:41:57'),
(5, 'Walterbos F3.56', '2015-05-11 08:45:36'),
(6, 'Walterbos F3.67', '2015-09-21 12:55:56'),
(7, 'Walterbos F4.11', '2016-04-21 11:01:17'),
(8, 'Walterbos F3.22', '2016-06-27 05:25:19');

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `ch_preferences`
--

CREATE TABLE IF NOT EXISTS `ch_preferences` (
  `user_name` varchar(50) CHARACTER SET utf8 NOT NULL,
  `phone` varchar(15) CHARACTER SET utf8 NOT NULL,
  `team` tinyint(4) NOT NULL,
  `functie` tinyint(4) NOT NULL,
  `mo` decimal(3,1) NOT NULL DEFAULT '8.0',
  `tu` decimal(3,1) NOT NULL DEFAULT '8.0',
  `we` decimal(3,1) NOT NULL DEFAULT '8.0',
  `th` decimal(3,1) NOT NULL DEFAULT '8.0',
  `vr` decimal(3,1) NOT NULL DEFAULT '8.0',
  `sa` decimal(3,1) NOT NULL,
  `su` decimal(3,1) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_name`),
  UNIQUE KEY `user_name` (`user_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Gegevens worden uitgevoerd voor tabel `ch_preferences`
--



-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `ch_sprints`
--

CREATE TABLE IF NOT EXISTS `ch_sprints` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `naam` varchar(20) NOT NULL,
  `datum` date NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `datum` (`datum`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=34 ;

--
-- Gegevens worden uitgevoerd voor tabel `ch_sprints`
--


-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `ch_teams`
--

CREATE TABLE IF NOT EXISTS `ch_teams` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `naam` varchar(20) CHARACTER SET utf8 NOT NULL,
  `rgb` varchar(10) CHARACTER SET utf8 NOT NULL,
  `imckc` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=12 ;

--
-- Gegevens worden uitgevoerd voor tabel `ch_teams`
--

INSERT INTO `ch_teams` (`id`, `naam`, `rgb`, `imckc`) VALUES
(1, 'groen', '#31B404', 0),
(2, 'rood', '#DF013A', 1),
(3, 'geel', '#FFBF00', 0),


-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `ch_vrijedagen`
--

CREATE TABLE IF NOT EXISTS `ch_vrijedagen` (
  `datum` date NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`datum`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Gegevens worden uitgevoerd voor tabel `ch_vrijedagen`
--

INSERT INTO `ch_vrijedagen` (`datum`, `timestamp`) VALUES
('2017-01-01', '2016-06-07 12:05:25'),
('2017-04-17', '2017-01-25 10:52:08'),
('2017-05-05', '2017-01-25 10:52:26'),
('2017-05-25', '2017-01-25 10:53:31'),
('2017-05-26', '2017-01-25 10:53:44'),
('2017-06-05', '2017-01-25 10:54:25'),
('2017-12-25', '2017-01-25 10:55:01'),
('2017-12-26', '2017-01-25 10:55:09'),
('2018-01-01', '2017-01-25 10:55:32');

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `uc_configuration`
--

CREATE TABLE IF NOT EXISTS `uc_configuration` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `value` varchar(150) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=8 ;

--
-- Gegevens worden uitgevoerd voor tabel `uc_configuration`
--

INSERT INTO `uc_configuration` (`id`, `name`, `value`) VALUES
(1, 'website_name', 'UserCake'),
(2, 'website_url', 'localhost/'),
(3, 'email', 'jasperbosch@chello.nl'),
(4, 'activation', 'false'),
(5, 'resend_activation_threshold', '0'),
(6, 'language', 'models/languages/en.php'),
(7, 'template', 'models/site-templates/default.css');

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `uc_pages`
--

CREATE TABLE IF NOT EXISTS `uc_pages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `page` varchar(150) NOT NULL,
  `private` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=29 ;

--
-- Gegevens worden uitgevoerd voor tabel `uc_pages`
--

INSERT INTO `uc_pages` (`id`, `page`, `private`) VALUES
(1, 'account.php', 1),
(2, 'activate-account.php', 0),
(3, 'admin_configuration.php', 1),
(4, 'admin_page.php', 1),
(5, 'admin_pages.php', 1),
(6, 'admin_permission.php', 1),
(7, 'admin_permissions.php', 1),
(8, 'admin_user.php', 1),
(9, 'admin_users.php', 1),
(10, 'forgot-password.php', 0),
(11, 'index.php', 0),
(12, 'left-nav.php', 0),
(13, 'login.php', 0),
(14, 'logout.php', 1),
(15, 'register.php', 0),
(16, 'resend-activation.php', 0),
(17, 'user_settings.php', 1),
(18, 'checkin_locatie.php', 0),
(19, 'checkin_locaties.php', 0),
(20, 'checkin_sprint.php', 0),
(21, 'checkin_sprintstarts.php', 0),
(22, 'checkin_team.php', 0),
(23, 'checkin_teams.php', 0),
(24, 'checkin_vrijedagen.php', 0),
(25, 'checkin_config.php', 0),
(26, 'checkin_configs.php', 0),
(27, 'checkin_functie.php', 0),
(28, 'checkin_functies.php', 0);

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `uc_permissions`
--

CREATE TABLE IF NOT EXISTS `uc_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- Gegevens worden uitgevoerd voor tabel `uc_permissions`
--

INSERT INTO `uc_permissions` (`id`, `name`) VALUES
(1, 'New Member'),
(2, 'Administrator');

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `uc_permission_page_matches`
--

CREATE TABLE IF NOT EXISTS `uc_permission_page_matches` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `permission_id` int(11) NOT NULL,
  `page_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=14 ;

--
-- Gegevens worden uitgevoerd voor tabel `uc_permission_page_matches`
--
INSERT INTO `uc_permission_page_matches` (`id`, `permission_id`, `page_id`) VALUES
(1, 1, 1),
(2, 1, 14),
(3, 1, 17),
(4, 2, 1),
(5, 2, 3),
(6, 2, 4),
(7, 2, 5),
(8, 2, 6),
(9, 2, 7),
(10, 2, 8),
(11, 2, 9),
(12, 2, 14),
(13, 2, 17),
(14, 2, 18),
(15, 2, 19),
(16, 2, 20),
(17, 2, 21),
(18, 2, 22),
(19, 2, 23);

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `uc_users`
--

CREATE TABLE IF NOT EXISTS `uc_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(50) NOT NULL,
  `display_name` varchar(50) NOT NULL,
  `password` varchar(225) NOT NULL,
  `email` varchar(150) NOT NULL,
  `activation_token` varchar(225) NOT NULL,
  `last_activation_request` int(11) NOT NULL,
  `lost_password_request` tinyint(1) NOT NULL,
  `active` tinyint(1) NOT NULL,
  `title` varchar(150) NOT NULL,
  `sign_up_stamp` int(11) NOT NULL,
  `last_sign_in_stamp` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_name` (`user_name`),
  KEY `user_name_2` (`user_name`),
  KEY `display_name` (`display_name`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=83 ;

--
-- Gegevens worden uitgevoerd voor tabel `uc_users`
--
INSERT INTO `uc_users` (`id`, `user_name`, `display_name`, `password`, `email`, `activation_token`, `last_activation_request`, `lost_password_request`, `active`, `title`, `sign_up_stamp`, `last_sign_in_stamp`) VALUES
(1, 'admin', 'admin', 'df87687f8b33c8166e66e18ab373894e506493e6ae512e09c52e007c65f2a504f', '', '810489e11664a432ad0c11aae031b455', 1492536052, 0, 1, 'New Member', 1492536052, 0);


-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `uc_user_permission_matches`
--

CREATE TABLE IF NOT EXISTS `uc_user_permission_matches` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=103 ;

--
-- Gegevens worden uitgevoerd voor tabel `uc_user_permission_matches`
--
INSERT INTO `uc_user_permission_matches` (`id`, `user_id`, `permission_id`) VALUES
(1, 1, 2);


/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
