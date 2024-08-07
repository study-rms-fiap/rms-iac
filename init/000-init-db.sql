-- -# create databases
CREATE DATABASE IF NOT EXISTS `db-order`;
CREATE DATABASE IF NOT EXISTS `db-payment`;
CREATE DATABASE IF NOT EXISTS `db-production`;

-- # create root user and grant rights
-- CREATE USER 'root'@'localhost' IDENTIFIED BY 'local';
GRANT ALL PRIVILEGES ON *.* TO 'fiap'@'%';