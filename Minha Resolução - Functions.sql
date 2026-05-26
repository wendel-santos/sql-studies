/* 1. Crie uma Function que calcule o tempo (em anos) entre duas datas. Essa function deve 
receber dois argumentos: data_inicial e data_final. Caso a data_final não seja informada, a 
function deve automaticamente considerar a data atual do sistema. Essa function será usada 
para calcular o tempo de casa de cada funcionário. 
Obs: a função DATEDIFF não é suficiente para resolver este problema. */

-- Function que calcula a diferença em anos
CREATE OR ALTER FUNCTION fnCalcularTempo(@data_inicial AS DATE, @data_final AS DATE)
RETURNS INT
AS
BEGIN
	DECLARE @anos AS INT

	SET @anos = 0

	IF @data_final IS NULL
		SET @anos = DATEDIFF(YEAR, @data_inicial, GETDATE())
	ELSE
		SET @anos = DATEDIFF(YEAR, @data_inicial, @data_final)

	RETURN @anos
END
/* Nossa, o código dele ficou muito mais simples kkkkkkk. Mas, o importante é que ao menos cheguei no mesmo resultado hehehe. 
O dele só ficou assim: IF @data_final IS NULL SET data_final = GETDATE() e RETURN DATEDIFF(YEAR, @data_inicial, @data_final), simples assim. */

-- Select do código
SELECT 
	FirstName AS 'Nome',
	LastName AS 'Sobrenome',
	dbo.fnCalcularTempo(HireDate, EndDate) AS 'Anos na Empresa'
FROM 
	DimEmployee

/* 2. Crie uma function que calcula a bonificação de cada funcionário (5% a mais em relação ao 
BaseRate). Porém, tome cuidado! Nem todos os funcionários deverão receber bônus... */

-- Function
CREATE OR ALTER FUNCTION fnCalcularBonificacao(@base_salario AS FLOAT, @data_final AS DATE)
RETURNS FLOAT
AS
BEGIN
	IF @data_final IS NULL
		SET @base_salario = @base_salario * 1.05
	ELSE
		SET @base_salario = @base_salario

	RETURN @base_salario
END
/* Eu fiz errado, calculei 1.05 sendo que era só 0.5 o bonus, achei que era pra repassar o salario novo. Mas enfim, a difença mesmo
foi que ele passou um terneiro argumento na função e fez outra coisa diferente lá pra deixar ainda mais automática, e faltei nisso. */

-- Select
SELECT
		EmployeeKey AS 'ID Funcionário',
		EndDate,
		BaseRate AS 'Base Sal. Antigo',
		dbo.fnCalcularBonificacao(BaseRate, EndDate) AS 'Base Sa. Ajustado'
FROM
	DimEmployee


/* 3. Crie uma Function que retorna uma tabela. Esta function deve receber como parâmetro o 
gênero do cliente e retornar todos os clientes que são do gênero informado na function. 
Observe que esta function será utilizada particularmente com a tabela DimCustomer. */

SELECT * FROM fnTabela('F')

CREATE OR ALTER FUNCTION fnTabela(@sexo AS VARCHAR(MAX))
RETURNS TABLE
AS
RETURN (SELECT * FROM DimCustomer WHERE Gender = @sexo)
/* Eu tive que dar uma pescada porque ele realmente não facilitou nessa que já não teve aula a respeito, 
	e o mesmo reconheceu isso na explicação dos excercícios. Enfim, olha só como é simples! Abaixo, o meu fiasco de tentativa kkkkkkk */

CREATE OR ALTER FUNCTION fnTabela(@sexo AS VARCHAR(MAX))
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE	@pessoas AS VARCHAR(MAX)
	
	@pessoas = SELECT * FROM DimCustomer WHERE Gender = @sexo

	RETURN @pessoas
END

/* 4. Crie uma Function que retorna uma tabela resumo com o total de produtos por cores. Sua 
function deve receber 1 argumento, onde será possível especificar de qual marca você deseja o 
resumo. */

CREATE OR ALTER FUNCTION fnProdutos(@marca AS VARCHAR(100))
RETURNS TABLE
AS
RETURN (SELECT ColorName, COUNT(ColorName) AS 'Quantidade' FROM DimProduct WHERE BrandName = @marca GROUP BY ColorName)

SELECT * FROM fnProdutos('Contoso')

-- Mamão com açucar. Mas eu ia fazer errado até ver o inicio da correção (não li o enunciado direito kkkkkkkkkk). 