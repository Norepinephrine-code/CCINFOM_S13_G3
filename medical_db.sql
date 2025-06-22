-- MySQL Workbench Forward Engineering RAMOS, BERNABE, CHUA, LATIDO --

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema medical_db
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `medical_db`;
CREATE SCHEMA IF NOT EXISTS `medical_db` DEFAULT CHARACTER SET utf8mb4;
USE `medical_db`;

-- -----------------------------------------------------
-- Table `patient`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `patient`;
CREATE TABLE IF NOT EXISTS `patient` (
  `patient_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(50) NOT NULL,
  `last_name` VARCHAR(50) NOT NULL,
  `gender` ENUM('M', 'F', 'O') NOT NULL,
  `date_of_birth` DATE NOT NULL,
  PRIMARY KEY (`patient_id`)
) ENGINE = InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------
-- Table `doctor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `doctor`;
CREATE TABLE IF NOT EXISTS `doctor` (
  `doctor_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `full_name` VARCHAR(100) NOT NULL,
  `specialization` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`doctor_id`)
) ENGINE = InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------
-- Table `disease`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `disease`;
CREATE TABLE IF NOT EXISTS `disease` (
  `disease_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `disease_name` VARCHAR(50) NOT NULL,
  `description` LONGTEXT NULL,
  `classification` VARCHAR(50) NOT NULL,
  `icd_code` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`disease_id`)
) ENGINE = InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------
-- Table `medical_history`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `medical_history`;
CREATE TABLE IF NOT EXISTS `medical_history` (
  `history_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `patient_id` INT UNSIGNED NOT NULL,
  `doctor_id` INT UNSIGNED NULL,
  `condition_id` INT UNSIGNED NULL,
  `description` LONGTEXT NULL,
  `date_recorded` DATE NULL COMMENT 'Optional: diagnosis date if during hospital encounter',
  PRIMARY KEY (`history_id`),
  INDEX `idx_medical_history_patient_id` (`patient_id`),
  INDEX `idx_medical_history_doctor_id` (`doctor_id`),
  INDEX `idx_medical_history_condition_id` (`condition_id`),
  CONSTRAINT `fk_medical_history_patient`
    FOREIGN KEY (`patient_id`) REFERENCES `patient` (`patient_id`)
    ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_medical_history_doctor`
    FOREIGN KEY (`doctor_id`) REFERENCES `doctor` (`doctor_id`)
    ON DELETE SET NULL ON UPDATE NO ACTION,
  CONSTRAINT `fk_medical_history_condition`
    FOREIGN KEY (`condition_id`) REFERENCES `disease` (`disease_id`)
    ON DELETE SET NULL ON UPDATE NO ACTION
) ENGINE = InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------
-- Table `lab_procedure`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lab_procedure`;
CREATE TABLE IF NOT EXISTS `lab_procedure` (
  `procedure_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  `category` VARCHAR(50) NOT NULL,
  `cost` DECIMAL(10,2) NOT NULL CHECK (`cost` >= 0),
  `description` LONGTEXT NULL,
  PRIMARY KEY (`procedure_id`)
) ENGINE = InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------
-- Table `lab_result`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lab_result`;
CREATE TABLE IF NOT EXISTS `lab_result` (
  `lab_result_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `ordering_physician` INT UNSIGNED NOT NULL,
  `patient_id` INT UNSIGNED NOT NULL,
  `procedure_id` INT UNSIGNED NOT NULL,
  `result_text` LONGTEXT NOT NULL,
  `result_date` DATETIME NOT NULL,
  PRIMARY KEY (`lab_result_id`),
  INDEX `idx_lab_result_physician` (`ordering_physician`),
  INDEX `idx_lab_result_patient_id` (`patient_id`),
  INDEX `idx_lab_result_procedure_id` (`procedure_id`),
  CONSTRAINT `fk_lab_result_physician`
    FOREIGN KEY (`ordering_physician`) REFERENCES `doctor` (`doctor_id`)
    ON DELETE RESTRICT ON UPDATE NO ACTION,
  CONSTRAINT `fk_lab_result_patient`
    FOREIGN KEY (`patient_id`) REFERENCES `patient` (`patient_id`)
    ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_lab_result_procedure`
    FOREIGN KEY (`procedure_id`) REFERENCES `lab_procedure` (`procedure_id`)
    ON DELETE RESTRICT ON UPDATE NO ACTION
) ENGINE = InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------
-- Table `diagnosis`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `diagnosis`;
CREATE TABLE IF NOT EXISTS `diagnosis` (
  `diagnosis_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `patient_id` INT UNSIGNED NOT NULL,
  `doctor_id` INT UNSIGNED NOT NULL,
  `disease_id` INT UNSIGNED NOT NULL,
  `date_diagnosis` DATE NOT NULL,
  `notes` LONGTEXT NULL,
  PRIMARY KEY (`diagnosis_id`),
  INDEX `idx_diagnosis_patient_id` (`patient_id`),
  INDEX `idx_diagnosis_doctor_id` (`doctor_id`),
  INDEX `idx_diagnosis_disease_id` (`disease_id`),
  CONSTRAINT `fk_diagnosis_patient`
    FOREIGN KEY (`patient_id`) REFERENCES `patient` (`patient_id`)
    ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_diagnosis_doctor`
    FOREIGN KEY (`doctor_id`) REFERENCES `doctor` (`doctor_id`)
    ON DELETE RESTRICT ON UPDATE NO ACTION,
  CONSTRAINT `fk_diagnosis_disease`
    FOREIGN KEY (`disease_id`) REFERENCES `disease` (`disease_id`)
    ON DELETE RESTRICT ON UPDATE NO ACTION
) ENGINE = InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------
-- Table `patient_visit`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `patient_visit`;
CREATE TABLE IF NOT EXISTS `patient_visit` (
  `visit_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `patient_id` INT UNSIGNED NOT NULL,
  `doctor_id` INT UNSIGNED NOT NULL,
  `reason` VARCHAR(50) NULL,
  `date_time` DATETIME NOT NULL,
  `doctor_notes` VARCHAR(255) NULL COMMENT 'Optional',
  PRIMARY KEY (`visit_id`),
  INDEX `idx_patient_visit_doctor_id` (`doctor_id`),
  INDEX `idx_patient_visit_patient_id` (`patient_id`),
  CONSTRAINT `fk_patient_visit_doctor`
    FOREIGN KEY (`doctor_id`) REFERENCES `doctor` (`doctor_id`)
    ON DELETE RESTRICT ON UPDATE NO ACTION,
  CONSTRAINT `fk_patient_visit_patient`
    FOREIGN KEY (`patient_id`) REFERENCES `patient` (`patient_id`)
    ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE = InnoDB DEFAULT CHARSET=utf8mb4;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
