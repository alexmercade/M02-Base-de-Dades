DROP DATABASE IF EXISTS Repas;
CREATE DATABASE Repas;
USE Repas;
/* ex1: CREATE PROCEDURE CrearTaulaNombres()
BEGIN
   
    	CREATE TABLE Nombres(
        IndexN INT PRIMARY KEY AUTO_INCREMENT,
        Nombres  INT NOT NULL CHECK(Nombres<9 AND Nombres>0)
        )ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
      
		END;
		
		CALL CrearTaulaNombres()
		
*/


/* EX2 */
DROP PROCEDURE IF EXISTS CrearTaulaNombres;
DELIMITER //
CREATE PROCEDURE CrearTaulaNombres(OUT valorRetorn VARCHAR(20))
BEGIN
   
        DECLARE EXIT HANDLER FOR 1146
    	CREATE TABLE Nombres(
        IndexN INT PRIMARY KEY AUTO_INCREMENT,
        Nombres  INT NOT NULL CHECK(Nombres<9 AND Nombres>0)
        )ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
        SET valorRetorn = 'ERROR 1050';
       
		END;

//
DELIMITER ;

CALL CrearTaulaNombres(@valorRetorn);
SELECT @valorRetorn;


/* EX3 */	

DELIMITER //

DROP PROCEDURE 	CrearTaulaDeNombres;
CREATE PROCEDURE CrearTaulaDeNombres(IN nomtaula VARCHAR(20))
BEGIN
    
    SET @instruccio_create = CONCAT('CREATE TABLE ', nomtaula, ' (
    IndexN INT PRIMARY KEY AUTO_INCREMENT,
	Nombres INT NOT NULL CHECK (Nombres<9 AND Nombres>0)
	) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci');
	
	PREPARE instruccio FROM @instruccio_create;
	EXEC instruccio;
	DEALLOCATE PREPARE instruccio;
	
    END;



// 
DELIMITER ;


CALL CrearTaulaDeNombres('Nombres2');


/* EX4 */

DELIMITER //

CREATE PROCEDURE InserirValor(IN nomtaula VARCHAR(20), IN valor SMALLINT)
BEGIN
    DECLARE CONTINUE HANDLER FOR SQLSTATE '42S02'
    BEGIN
       SET @instruccio_create = CONCAT('CREATE TABLE ', nomtaula, ' (
    IndexN INT PRIMARY KEY AUTO_INCREMENT,
	Nombres INT NOT NULL CHECK (Nombres<9 AND Nombres>0)
	) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci');
        PREPARE instr_create FROM @instruccio_create;
        EXECUTE instr_create;
        DEALLOCATE PREPARE instr_create;

    END;
    SET @instruccio_insert=CONCAT('INSERT INTO ',nomtaula,' (Nombres) VALUE (?)');
    PREPARE instr_insert FROM @instruccio_insert;
    EXECUTE instr_insert USING valor;
    DEALLOCATE PREPARE instr_insert;
END;
//
DELIMITER ;
CALL InserirValor('Nombres2', 2); 


/* EX5 */

DELIMITER //
DROP PROCEDURE InserirNValors;
CREATE PROCEDURE InserirNValors(IN insercions INT, OUT insercions_res INT)
BEGIN
    DECLARE comptador INT DEFAULT 0;
    WHILE (comptador < insercions) DO
        INSERT INTO Nombres (Nombres) VALUES (FLOOR(RAND() * 8) + 1);
        SET comptador = comptador + 1;
    END WHILE;
    SET insercions = (SELECT COUNT(*) FROM Nombres);
END;

DELIMITER ;
/*em donava error amb inout*/

CALL InserirNValors(9,@insercions_res);



/* EX6 */

DELIMITER //

CREATE TRIGGER MostraMissatge AFTER INSERT ON Nombres FOR EACH ROW 
BEGIN 
	
	DECLARE missatge VARCHAR (40);
	IF Nombres.Nombres>5  THEN
	SET missatge = 'El valor inserit es major a 5';
	ELSEIF Nombres.Nombres<5 THEN 
	SET missatge = 'El valor inserit es menor a 5';
	ELSE 
	SET missatge = 'El valor inserit es igual a 5';
	END IF;
	SELECT missatge;
END;


//
DELIMITER ;