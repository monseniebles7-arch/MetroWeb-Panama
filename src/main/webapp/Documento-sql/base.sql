-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 29-06-2026 a las 22:13:33
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `base`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estaciones_metro`
--

CREATE TABLE `estaciones_metro` (
  `id_estacion` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `linea` enum('1','2') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `estaciones_metro`
--

INSERT INTO `estaciones_metro` (`id_estacion`, `nombre`, `linea`) VALUES
(1, 'Albrook', '1'),
(2, '5 de Mayo', '1'),
(3, 'Lotería', '1'),
(4, 'Santo Tomás', '1'),
(5, 'Iglesia del Carmen', '1'),
(6, 'Vía Argentina', '1'),
(7, 'Fernández de Córdoba', '1'),
(8, 'Pueblo Nuevo', '1'),
(9, '12 de Octubre', '1'),
(10, 'El Ingenio', '1'),
(11, 'San Miguelito', '1'),
(12, 'Pan de Azúcar', '1'),
(13, 'Los Andes', '1'),
(14, 'San Isidro', '1'),
(15, 'Villa Zaíta', '1'),
(16, 'San Miguelito L2', '2'),
(17, 'Paraíso', '2'),
(18, 'Cincuentenario', '2'),
(19, 'Villa Lucre', '2'),
(20, 'El Crisol', '2'),
(21, 'Brisas del Golf', '2'),
(22, 'Cerro Viento', '2'),
(23, 'San Antonio', '2'),
(24, 'Pedregal', '2'),
(25, 'Don Bosco', '2'),
(26, 'Corredor Sur', '2'),
(27, 'Las Mañanitas', '2'),
(28, 'Hospital del Este', '2'),
(29, 'Altos de Tocumen', '2'),
(30, '24 de Diciembre', '2'),
(31, 'Nuevo Tocumen', '2');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `historial_saldo`
--

CREATE TABLE `historial_saldo` (
  `id_historial` int(11) NOT NULL,
  `monto_usado` decimal(12,2) NOT NULL,
  `fecha_hora` datetime NOT NULL DEFAULT current_timestamp(),
  `id_usuario` int(11) NOT NULL,
  `id_tarjeta` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `recargas`
--

CREATE TABLE `recargas` (
  `id_recarga` int(11) NOT NULL,
  `monto` decimal(12,2) NOT NULL,
  `metodo_pago` varchar(80) NOT NULL,
  `fecha_hora` datetime NOT NULL DEFAULT current_timestamp(),
  `id_usuario` int(11) NOT NULL,
  `id_tarjeta` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rutas_bus`
--

CREATE TABLE `rutas_bus` (
  `id_ruta` int(11) NOT NULL,
  `codigo` varchar(10) NOT NULL,
  `troncal` varchar(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `rutas_bus`
--

INSERT INTO `rutas_bus` (`id_ruta`, `codigo`, `troncal`) VALUES
(1, 'S420', 'S'),
(2, 'S421', 'S'),
(3, 'S422', 'S'),
(4, 'S432', 'S'),
(5, 'S440', 'S'),
(6, 'S441', 'S'),
(7, 'S442', 'S'),
(8, 'S447', 'S'),
(9, 'S480', 'S'),
(10, 'S481', 'S'),
(11, 'S482', 'S'),
(12, 'S487', 'S'),
(13, 'S510', 'S'),
(14, 'S511', 'S'),
(15, 'S512', 'S'),
(16, 'S520', 'S'),
(17, 'S530', 'S'),
(18, 'S542', 'S'),
(19, 'S549', 'S'),
(20, 'S562', 'S'),
(21, 'S569', 'S'),
(22, 'S572', 'S'),
(23, 'S662', 'S'),
(24, 'S669', 'S'),
(25, 'T020', 'T'),
(26, 'T021', 'T'),
(27, 'T022', 'T'),
(28, 'T029', 'T'),
(29, 'T033', 'T'),
(30, 'T040', 'T'),
(31, 'T060', 'T'),
(32, 'T080', 'T'),
(33, 'T098', 'T'),
(34, 'T100', 'T'),
(35, 'T120', 'T'),
(36, 'T140', 'T'),
(37, 'T143', 'T'),
(38, 'T149', 'T'),
(39, 'T160', 'T'),
(40, 'T176', 'T'),
(41, 'T443', 'T'),
(42, 'T582', 'T'),
(43, 'A096', 'A'),
(44, 'F030', 'F'),
(45, 'I182', 'I'),
(46, 'I532', 'I'),
(47, 'I672', 'I'),
(48, 'K042', 'K'),
(49, 'K100', 'K'),
(50, 'K120', 'K'),
(51, 'K140', 'K'),
(52, 'K160', 'K'),
(53, 'K181', 'K'),
(54, 'K189', 'K'),
(55, 'K530', 'K'),
(56, 'M062', 'M'),
(57, 'M100', 'M'),
(58, 'M120', 'M'),
(59, 'M140', 'M'),
(60, 'M181', 'M'),
(61, 'M182', 'M'),
(62, 'M201', 'M'),
(63, 'M481', 'M'),
(64, 'M502', 'M'),
(65, 'M530', 'M'),
(66, 'M671', 'M'),
(67, 'M675', 'M'),
(68, 'V180', 'V'),
(69, 'V201', 'V'),
(70, 'V442', 'V'),
(71, 'V502', 'V'),
(72, 'V531', 'V'),
(73, 'V532', 'V'),
(74, 'V539', 'V'),
(75, 'V560', 'V'),
(76, 'C640', 'C'),
(77, 'C641', 'C'),
(78, 'C642', 'C'),
(79, 'C678', 'C'),
(80, 'C790', 'C'),
(81, 'C800', 'C'),
(82, 'C810', 'C'),
(83, 'C820', 'C'),
(84, 'C830', 'C'),
(85, 'C842', 'C'),
(86, 'C850', 'C'),
(87, 'C862', 'C'),
(88, 'C888', 'C'),
(89, 'C898', 'C'),
(90, 'C903', 'C'),
(91, 'C908', 'C'),
(92, 'C918', 'C'),
(93, 'C928', 'C'),
(94, 'C938', 'C'),
(95, 'C941', 'C'),
(96, 'C944', 'C'),
(97, 'C952', 'C'),
(98, 'C968', 'C'),
(99, 'C970', 'C'),
(100, 'C974', 'C'),
(101, 'C982', 'C'),
(102, 'E418', 'E'),
(103, 'E436', 'E'),
(104, 'E444', 'E'),
(105, 'E445', 'E'),
(106, 'E458', 'E'),
(107, 'E468', 'E'),
(108, 'E478', 'E'),
(109, 'E484', 'E'),
(110, 'E485', 'E'),
(111, 'E486', 'E'),
(112, 'E488', 'E'),
(113, 'E489', 'E'),
(114, 'E496', 'E'),
(115, 'E504', 'E'),
(116, 'E505', 'E'),
(117, 'E506', 'E'),
(118, 'E516', 'E'),
(119, 'E526', 'E'),
(120, 'E537', 'E'),
(121, 'E556', 'E'),
(122, 'E566', 'E'),
(123, 'E568', 'E'),
(124, 'E598', 'E'),
(125, 'E606', 'E'),
(126, 'E618', 'E'),
(127, 'E619', 'E'),
(128, 'E628', 'E'),
(129, 'E638', 'E'),
(130, 'E658', 'E'),
(131, 'E665', 'E'),
(132, 'N025', 'N'),
(133, 'N035', 'N'),
(134, 'N037', 'N'),
(135, 'N045', 'N'),
(136, 'N047', 'N'),
(137, 'N048', 'N'),
(138, 'N065', 'N'),
(139, 'N067', 'N'),
(140, 'N105', 'N'),
(141, 'N106', 'N'),
(142, 'N109', 'N'),
(143, 'N125', 'N'),
(144, 'N126', 'N'),
(145, 'N129', 'N'),
(146, 'N145', 'N'),
(147, 'N147', 'N'),
(148, 'N149', 'N'),
(149, 'N154', 'N'),
(150, 'N156', 'N'),
(151, 'N165', 'N'),
(152, 'N185', 'N'),
(153, 'N204', 'N'),
(154, 'N205', 'N'),
(155, 'N208', 'N'),
(156, 'N209', 'N');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tarjetas`
--

CREATE TABLE `tarjetas` (
  `id_tarjeta` int(11) NOT NULL,
  `numero_tarjeta` varchar(20) NOT NULL,
  `alias_tarjeta` varchar(100) DEFAULT NULL,
  `tipo` varchar(50) NOT NULL,
  `estado` enum('activa','bloqueada','inactiva') NOT NULL DEFAULT 'activa',
  `saldo` decimal(12,2) NOT NULL DEFAULT 0.00,
  `id_usuario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuario` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `apellido` varchar(100) NOT NULL,
  `correo` varchar(150) NOT NULL,
  `hash_contrasena` varchar(255) NOT NULL,
  `rol` varchar(50) NOT NULL DEFAULT 'usuario'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `nombre`, `apellido`, `correo`, `hash_contrasena`, `rol`) VALUES
(1, 'Admin', 'MetroWeb', 'admin@metroweb.com', '$2a$12$ESiFjOBy8yl5DOzQW2KLiOH2a0wETDWvqRd6g942SB/ce5Z5rC8y.', 'admin');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `viajes`
--

CREATE TABLE `viajes` (
  `id_viaje` int(11) NOT NULL,
  `tipo_transporte` enum('tren','bus') NOT NULL,
  `id_estacion` int(11) DEFAULT NULL,
  `id_ruta` int(11) DEFAULT NULL,
  `fecha_hora` datetime NOT NULL DEFAULT current_timestamp(),
  `id_usuario` int(11) NOT NULL
) ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `estaciones_metro`
--
ALTER TABLE `estaciones_metro`
  ADD PRIMARY KEY (`id_estacion`);

--
-- Indices de la tabla `historial_saldo`
--
ALTER TABLE `historial_saldo`
  ADD PRIMARY KEY (`id_historial`),
  ADD KEY `id_usuario` (`id_usuario`),
  ADD KEY `id_tarjeta` (`id_tarjeta`);

--
-- Indices de la tabla `recargas`
--
ALTER TABLE `recargas`
  ADD PRIMARY KEY (`id_recarga`),
  ADD KEY `id_usuario` (`id_usuario`),
  ADD KEY `id_tarjeta` (`id_tarjeta`);

--
-- Indices de la tabla `rutas_bus`
--
ALTER TABLE `rutas_bus`
  ADD PRIMARY KEY (`id_ruta`),
  ADD UNIQUE KEY `codigo` (`codigo`);

--
-- Indices de la tabla `tarjetas`
--
ALTER TABLE `tarjetas`
  ADD PRIMARY KEY (`id_tarjeta`),
  ADD UNIQUE KEY `numero_tarjeta` (`numero_tarjeta`),
  ADD KEY `id_usuario` (`id_usuario`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usuario`),
  ADD UNIQUE KEY `correo` (`correo`);

--
-- Indices de la tabla `viajes`
--
ALTER TABLE `viajes`
  ADD PRIMARY KEY (`id_viaje`),
  ADD KEY `id_usuario` (`id_usuario`),
  ADD KEY `id_estacion` (`id_estacion`),
  ADD KEY `id_ruta` (`id_ruta`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `estaciones_metro`
--
ALTER TABLE `estaciones_metro`
  MODIFY `id_estacion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT de la tabla `historial_saldo`
--
ALTER TABLE `historial_saldo`
  MODIFY `id_historial` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `recargas`
--
ALTER TABLE `recargas`
  MODIFY `id_recarga` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `rutas_bus`
--
ALTER TABLE `rutas_bus`
  MODIFY `id_ruta` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=157;

--
-- AUTO_INCREMENT de la tabla `tarjetas`
--
ALTER TABLE `tarjetas`
  MODIFY `id_tarjeta` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `viajes`
--
ALTER TABLE `viajes`
  MODIFY `id_viaje` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `historial_saldo`
--
ALTER TABLE `historial_saldo`
  ADD CONSTRAINT `historial_saldo_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON UPDATE CASCADE,
  ADD CONSTRAINT `historial_saldo_ibfk_2` FOREIGN KEY (`id_tarjeta`) REFERENCES `tarjetas` (`id_tarjeta`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `recargas`
--
ALTER TABLE `recargas`
  ADD CONSTRAINT `recargas_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON UPDATE CASCADE,
  ADD CONSTRAINT `recargas_ibfk_2` FOREIGN KEY (`id_tarjeta`) REFERENCES `tarjetas` (`id_tarjeta`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `tarjetas`
--
ALTER TABLE `tarjetas`
  ADD CONSTRAINT `tarjetas_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `viajes`
--
ALTER TABLE `viajes`
  ADD CONSTRAINT `viajes_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`),
  ADD CONSTRAINT `viajes_ibfk_2` FOREIGN KEY (`id_estacion`) REFERENCES `estaciones_metro` (`id_estacion`),
  ADD CONSTRAINT `viajes_ibfk_3` FOREIGN KEY (`id_ruta`) REFERENCES `rutas_bus` (`id_ruta`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
