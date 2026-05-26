/* Obs. As Procedures dos exercícios 1 a 2 serão executadas nas tabelas originais do banco de 
dados ContosoRetailDW.  

1. Crie uma Procedure que resume o total de produtos por nome da categoria. Essa Procedure 
deve solicitar ao usuário qual marca deve ser considerada na análise. */

SELECT * FROM DimProduct
SELECT * FROM DimProductSubcategory
SELECT * FROM DimProductCategory

CREATE OR ALTER PROCEDURE prProdutoMarca(@marca VARCHAR(MAX))
AS
BEGIN
	SELECT 
		pc.ProductCategoryKey,
		COUNT(*) AS 'Quantidade Produtos'
	FROM
		DimProduct p
	LEFT JOIN DimProductSubcategory ps
		ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
			LEFT JOIN DimProductCategory pc
				ON ps.ProductCategoryKey = pc.ProductCategoryKey
	WHERE
		BrandName = @marca
	GROUP BY pc.ProductCategoryName, pc.ProductCategoryKey
END

EXECUTE prProdutoMarca 'Contoso'
-- Boaaaa, fiz quase 100%. Só faltou eu passar a CategoryName ao invés a Key (e, lógico, tirar a Key do GROUP BY). De resto, show!

/*2. Crie uma Procedure que lista os top N clientes de acordo com a data de primeira compra. O 
valor de N deve ser um parâmetro de entrada da sua Procedure.  */

SELECT * FROM DimCustomer ORDER BY DateFirstPurchase desc
SELECT top(10) * FROM FactSales WHERE FORMAT(DateKey, 'YYYY-MM-DD') = '2004-07-31'

CREATE OR ALTER PROCEDURE prTopClientes(@quantidade INT, @data DATE)
AS
BEGIN
	SELECT
		TOP(@quantidade)CustomerKey,
		FirstName + ' ' + LastName AS 'Cliente',
		DateFirstPurchase,
		YearlyIncome
	FROM
		DimCustomer
	WHERE DateFirstPurchase = @data
	GROUP BY CustomerKey, DateFirstPurchase, YearlyIncome, FirstName, LastName
	ORDER BY YearlyIncome DESC
END

EXECUTE prTopClientes 10, '2004-07-31'
/* Bom, fiz assim. O top vindo primeira também, não sabia que é obrigatório ele vir depois do SELECT. 
		Enfim, como esperado, eu fiz difente. Peguei o YearlyIncome e ele o Email. O Order by dele foi pela data mesmo,	
		sem group by e com um Where pra pegar só o tipo 'person' (engraçado que nem precisei disso). */


/* 3. Crie uma Procedure que recebe 2 argumentos: MÊS (de 1 a 12) e ANO (1996 a 2003). Sua 
Procedure deve listar todos os funcionários que foram contratados no mês/ano informado. */
SELECT * FROM DimEmployee

CREATE OR ALTER PROCEDURE prFuncionariosContratados(@mes INT, @ano INT)
AS
BEGIN
	SELECT
		*
	FROM
		DimEmployee
	WHERE MONTH(HireDate) = @mes AND YEAR(HireDate) = @ano
END

EXECUTE prFuncionariosContratados 1, 2000
-- Moleeeeeeza! E ainda fiz melhor que o dele kkkkkkkkk

/* 4. Crie uma Procedure que insere uma nova linha na tabela Carro. Essa nova linha deve conter 
os seguintes dados: id = 5, placa = GOL-5555, modelo = Volkswagen Gol, tipo = Hatch, valor = 80000

Obs. Para os exercícios 4, 5 e 6, utilize os códigos abaixo. 

DROP DATABASE AlugaFacil 
CREATE DATABASE AlugaFacil 
USE AlugaFacil 

CREATE TABLE Carro( 
	id_carro INT, 
	placa VARCHAR(100) NOT NULL, 
	modelo VARCHAR(100) NOT NULL, 
	tipo VARCHAR(100) NOT NULL, 
	valor FLOAT NOT NULL, 
	CONSTRAINT carro_id_carro_pk PRIMARY KEY(id_carro) 
) 

INSERT INTO Carro(id_carro, placa, modelo, tipo, valor) VALUES 
	(1, 'CRU-1111', 'Chevrolet Cruze', 'Sedan', 140000), 
	(2, 'ARG-2222', 'Fiat Argo', 'Hatch', 80000), 
	(3, 'COR-3333', 'Toyota Corolla', 'Sedan', 170000), 
	(4, 'TIG-4444', 'Caoa Chery Tiggo', 'SUV', 190000)  
*/

CREATE OR ALTER PROCEDURE prIncluirCarro(@id INT, @placa VARCHAR(100), @modelo VARCHAR(100), @tipo VARCHAR(100), @valor FLOAT)
AS
BEGIN
	INSERT INTO Carro(id_carro, placa, modelo, tipo, valor) VALUES
		(@id, @placa, @modelo, @tipo, @valor)
END

EXECUTE prIncluirCarro 5, 'GOL-5555', 'Volkswagen Gol', 'Hatch', 80000
SELECT * FROM Carro
/* Izzzzzzzzzzzi. Mas, teve diferenças. Primeiro que ele nem passou os parámetros igual eu fiz ali na linha 101 (nem sabia que dava)
	A outra coisa foi que ele colocou usou O TRANSACTION + COMMIT e passou tudo dentro do código, sem pôr eles no EXECUTE (safado) */


/* 5. Crie uma Procedure que altera o valor de venda de um carro. A Procedure deve receber 
como parâmetros o id_carro e o novo valor.  */

CREATE OR ALTER PROCEDURE prAlterarValorCarro (@id_carro INT, @novo_valor FLOAT)
AS
BEGIN
	UPDATE Carro
	SET valor = @novo_valor
	WHERE id_carro = @id_carro
END

EXECUTE prAlterarValorCarro 2, 77000
SELECT * FROM Carro
/* Bem, essa já não foi tão izzi assim. Usei o chat pra lembrar como fazia o UPDATE e acabei foi recebendo ajuda em tudo kkkkkkkk.
	Aqui ele também usou uma TRANSACTION, mas passou os valores pelo EXECUTE. */

/* 6. Crie uma Precedure que exclui um carro a partir do id informado.  */
CREATE OR ALTER PROCEDURE prExcluirCarro (@id_carro INT)
AS
BEGIN
	DELETE FROM Carro
	WHERE id_carro = @id_carro
END

EXECUTE prExcluirCarro 2
SELECT * FROM Carro