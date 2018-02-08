-- Create syntax for java_prototype
CREATE DATABASE java_prototype
  DEFAULT CHARACTER SET utf8
  DEFAULT COLLATE utf8_general_ci;

USE java-prototype;

-- Create syntax for 'java_prototype.getrequests'

CREATE TABLE getrequests (
  id int(11) unsigned NOT NULL AUTO_INCREMENT,
  timestamp timestamp NULL DEFAULT NULL,
  hash varchar(255) DEFAULT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB AUTO_INCREMENT=499 DEFAULT CHARSET=utf8;