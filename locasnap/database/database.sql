-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 02, 2026 at 03:24 PM
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
-- Database: `locasnap`
--

-- --------------------------------------------------------

--
-- Table structure for table `locations`
--

CREATE TABLE `locations` (
  `id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `latitude` double NOT NULL,
  `longitude` double NOT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `locations`
--

INSERT INTO `locations` (`id`, `title`, `description`, `latitude`, `longitude`, `image_url`, `created_at`) VALUES
(1, 'Gedung Robotika', 'Dokumentasi Gedung Robotika ITS', -7.27562, 112.7956, '/uploads/gedung_robotika.jpg', '2026-10-02 19:57:08'),
(2, 'Perpustakaan ITS', 'Dokumentasi area perpustakaan', -7.2791, 112.7895, '/uploads/perpustakaan.jpg', '2026-10-02 19:57:08'),
(3, 'Departemen Teknik Komputer', 'Dokumentasi Departemen Teknik Komputer ITS', -7.2812, 112.7951, '/uploads/tekom.jpg', '2026-10-02 19:57:08'),
(4, 'Tower 2 ITS', 'Dokumentasi Gedung Tower 2 ITS', -7.28562, 112.7756, '/uploads/tower_2.jpg', '2026-10-02 20:22:39'),
(5, 'Departemen Teknik Elektro', 'Dokumentasi Departemen Teknik Elektro ITS', -7.2891, 112.7795, '/uploads/tektro.jpg', '2026-10-02 20:22:39');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `locations`
--
ALTER TABLE `locations`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `locations`
--
ALTER TABLE `locations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
