-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema vk
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema vk
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `vk` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `vk` ;

-- -----------------------------------------------------
-- Table `vk`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vk`.`user` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(245) NOT NULL,
  `phone` BIGINT(12) NOT NULL,
  `password_hash` CHAR(65) NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT NOW(),
  `updated_at` DATETIME NULL DEFAULT NULL ON UPDATE NOW(),
  `deleted_at` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE,
  UNIQUE INDEX `phone_UNIQUE` (`phone` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `vk`.`media_type`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vk`.`media_type` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `vk`.`media`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vk`.`media` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `media_type_id` INT UNSIGNED NOT NULL,
  `user_id` INT UNSIGNED NOT NULL,
  `url` VARCHAR(45) NULL DEFAULT NULL COMMENT '/files/image/2021/12312dassdas123/12.jpg',
  `blob` BLOB NULL DEFAULT NULL,
  `metadata` JSON NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT NOW(),
  PRIMARY KEY (`id`),
  INDEX `fk_media_media_type1_idx` (`media_type_id` ASC) VISIBLE,
  INDEX `fk_media_profile1_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fk_media_media_type1`
    FOREIGN KEY (`media_type_id`)
    REFERENCES `vk`.`media_type` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_media_profile1`
    FOREIGN KEY (`user_id`)
    REFERENCES `vk`.`profile` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `vk`.`profile`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vk`.`profile` (
  `user_id` INT UNSIGNED NOT NULL,
  `firstname` VARCHAR(245) NOT NULL,
  `lastname` VARCHAR(245) NOT NULL,
  `gender` ENUM('m', 'f', 'x') NOT NULL,
  `birthday` DATE NOT NULL,
  `address` VARCHAR(245) NULL DEFAULT NULL,
  `media_id` INT UNSIGNED NULL DEFAULT NULL,
  `profile_user_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`user_id`),
  INDEX `user_name` (`lastname` ASC, `firstname` ASC) VISIBLE,
  INDEX `fk_profile_media1_idx` (`media_id` ASC) VISIBLE,
  INDEX `fk_profile_profile1_idx` (`profile_user_id` ASC) VISIBLE,
  CONSTRAINT `fk_profile_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `vk`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_profile_media1`
    FOREIGN KEY (`media_id`)
    REFERENCES `vk`.`media` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_profile_profile1`
    FOREIGN KEY (`profile_user_id`)
    REFERENCES `vk`.`profile` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `vk`.`friendship_request`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vk`.`friendship_request` (
  `from_user_id` INT UNSIGNED NOT NULL,
  `to_user_id` INT UNSIGNED NOT NULL,
  `status` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '-1 - отклонён\n0 - запрос\n1 - дружба',
  `created_at` DATETIME NOT NULL DEFAULT NOW(),
  `updated_at` DATETIME NULL DEFAULT NULL ON UPDATE NOW(),
  INDEX `fk_friendship_request_profile1_idx` (`from_user_id` ASC) VISIBLE,
  INDEX `fk_friendship_request_profile2_idx` (`to_user_id` ASC) VISIBLE,
  PRIMARY KEY (`from_user_id`, `to_user_id`),
  CONSTRAINT `fk_friendship_request_profile1`
    FOREIGN KEY (`from_user_id`)
    REFERENCES `vk`.`profile` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_friendship_request_profile2`
    FOREIGN KEY (`to_user_id`)
    REFERENCES `vk`.`profile` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `vk`.`message`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vk`.`message` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `from_user_id` INT UNSIGNED NOT NULL,
  `to_user_id` INT UNSIGNED NOT NULL,
  `text` TEXT NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT NOW(),
  `read_at` DATETIME NULL DEFAULT NULL,
  `deleted_at` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_message_profile1_idx` (`from_user_id` ASC) VISIBLE,
  INDEX `fk_message_profile2_idx` (`to_user_id` ASC) VISIBLE,
  CONSTRAINT `fk_message_profile1`
    FOREIGN KEY (`from_user_id`)
    REFERENCES `vk`.`profile` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_message_profile2`
    FOREIGN KEY (`to_user_id`)
    REFERENCES `vk`.`profile` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `vk`.`community`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vk`.`community` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `admin_user_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE,
  INDEX `fk_community_profile1_idx` (`admin_user_id` ASC) VISIBLE,
  CONSTRAINT `fk_community_profile1`
    FOREIGN KEY (`admin_user_id`)
    REFERENCES `vk`.`profile` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `vk`.`user_community`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vk`.`user_community` (
  `community_id` INT UNSIGNED NOT NULL,
  `user_id` INT UNSIGNED NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT NOW(),
  PRIMARY KEY (`community_id`, `user_id`),
  INDEX `fk_community_has_profile_profile1_idx` (`user_id` ASC) VISIBLE,
  INDEX `fk_community_has_profile_community1_idx` (`community_id` ASC) VISIBLE,
  CONSTRAINT `fk_community_has_profile_community1`
    FOREIGN KEY (`community_id`)
    REFERENCES `vk`.`community` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_community_has_profile_profile1`
    FOREIGN KEY (`user_id`)
    REFERENCES `vk`.`profile` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `vk`.`post`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vk`.`post` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` INT UNSIGNED NOT NULL,
  `community_id` INT UNSIGNED NULL DEFAULT NULL,
  `post_id` INT UNSIGNED NULL DEFAULT NULL,
  `text` TEXT NULL DEFAULT NULL,
  `media_id` INT UNSIGNED NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT NOW(),
  PRIMARY KEY (`id`),
  INDEX `fk_post_profile1_idx` (`user_id` ASC) VISIBLE,
  INDEX `fk_post_community1_idx` (`community_id` ASC) VISIBLE,
  INDEX `fk_post_post1_idx` (`post_id` ASC) VISIBLE,
  INDEX `fk_post_media1_idx` (`media_id` ASC) VISIBLE,
  CONSTRAINT `fk_post_profile1`
    FOREIGN KEY (`user_id`)
    REFERENCES `vk`.`profile` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_post_community1`
    FOREIGN KEY (`community_id`)
    REFERENCES `vk`.`community` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_post_post1`
    FOREIGN KEY (`post_id`)
    REFERENCES `vk`.`post` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_post_media1`
    FOREIGN KEY (`media_id`)
    REFERENCES `vk`.`media` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `vk`.`like_to_post`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vk`.`like_to_post` (
  `profile_user_id` INT UNSIGNED NOT NULL,
  `post_id` INT UNSIGNED NOT NULL,
  `status_like` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '0 - нет лайка\n1 - есть лайк',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX `fk_ like_to_post_profile1_idx` (`profile_user_id` ASC) VISIBLE,
  INDEX `fk_ like_to_post_post1_idx` (`post_id` ASC) VISIBLE,
  PRIMARY KEY (`profile_user_id`, `post_id`),
  CONSTRAINT `fk_ like_to_post_profile1`
    FOREIGN KEY (`profile_user_id`)
    REFERENCES `vk`.`profile` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ like_to_post_post1`
    FOREIGN KEY (`post_id`)
    REFERENCES `vk`.`post` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `vk`.`like_media`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vk`.`like_media` (
  `profile_user_id` INT UNSIGNED NOT NULL,
  `media_id` INT UNSIGNED NOT NULL,
  `status_like` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '0 - нет лайка\n1 - есть лайк\n',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX `fk_like_media_profile1_idx` (`profile_user_id` ASC) VISIBLE,
  INDEX `fk_like_media_media1_idx` (`media_id` ASC) VISIBLE,
  PRIMARY KEY (`profile_user_id`, `media_id`),
  CONSTRAINT `fk_like_media_profile1`
    FOREIGN KEY (`profile_user_id`)
    REFERENCES `vk`.`profile` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_like_media_media1`
    FOREIGN KEY (`media_id`)
    REFERENCES `vk`.`media` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
