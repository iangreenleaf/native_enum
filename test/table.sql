DROP TABLE IF EXISTS `enum_test_models`;
CREATE TABLE `enum_test_models` (
  `id` int(11) NOT NULL DEFAULT '0',
  `color` enum('blue','red','yellow') DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
