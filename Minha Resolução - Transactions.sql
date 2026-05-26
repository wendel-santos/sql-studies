/* 1. Crie uma tabela chamada Carro com os dados abaixo.  
Obs: não se preocupe com constraints, pode criar uma tabela simples. */

CREATE SEQUENCE C1
AS INT
START WITH 1
INCREMENT BY 1
NO MAXVALUE
NO CYCLE

CREATE TABLE Carro(
id_carro INT, 
placa VARCHAR(100), 
modelo VARCHAR(100), 
tipo VARCHAR(100)
) 

INSERT INTO Carro(id_carro, placa, modelo, tipo) VALUES
	(NEXT VALUE FOR C1, 'DAS-1412', 'Hyundai HB20', 'Hatch'),
	(NEXT VALUE FOR C1, 'JHG-3902', 'Fiat Cronos', 'Sedan'),
	(NEXT VALUE FOR C1, 'IPW-9018', 'Citroen C4 Cactus', 'SUV'),
	(NEXT VALUE FOR C1, 'JKR-8891', 'Nissa Kicks', 'SUV'),
	(NEXT VALUE FOR C1, 'TRF-5904', 'Chevrolet Onix', 'Sedan')
	
SELECT * FROM Carro

/* 2. Execute as seguintes transações no banco de dados, sempre na tabela Carro. Lembre-se de 
dar um COMMIT para efetivar cada uma das transações.
a) Inserir uma nova linha com os seguintes valores: 
id_carro = 6 
placa = CDR-0090 
modelo = Fiat Argo 
tipo = Hatch */

BEGIN TRANSACTION car1
INSERT INTO Carro (id_carro, placa, modelo, tipo) VALUES
	(NEXT VALUE FOR C1, 'CDR-0090', 'Fiat Argo', 'Hatch')

COMMIT TRANSACTION car1
SELECT * FROM Carro

/* b) Atualizar o tipo do carro de id = 1 de Hatch para Sedan. */

BEGIN TRANSACTION car1
	UPDATE Carro
	SET tipo = 'Sedan'
	WHERE id_carro = 1
COMMIT TRANSACTION car1

SELECT * FROM Carro

/* c) Deletar a linha referente ao carro de id = 6. */

BEGIN TRANSACTION
	DELETE FROM Carro
	WHERE id_carro = 6
COMMIT TRANSACTION

SELECT * FROM Carro