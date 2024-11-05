create database if not exists example_db;
use example_db;
create table if not exists users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  email VARCHAR(100) NOT NULL
) ENGINE=INNODB;

