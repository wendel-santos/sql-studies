/* Exercício 1) 1. O gerente comercial pediu a você uma análise da Quantidade Vendida e Quantidade 
Devolvida para o canal de venda mais importante da empresa:  Store. 
Utilize uma função SQL para fazer essas consultas no seu banco de dados. Obs: Faça essa 
análise considerando a tabela FactSales. */

SELECT
	SUM(SalesQuantity) AS 'Qtd. Vendida',
	SUM(ReturnQuantity) AS 'Qtd. Devolvida'
FROM
	FactSales
WHERE channelKey = 1

/* Exercício 2) Uma nova ação no setor de Marketing precisará avaliar a média salarial de todos os clientes 
da empresa, mas apenas de ocupação Professional.  Utilize um comando SQL para atingir esse 
resultado. */

SELECT
	AVG(YearlyIncome) AS 'Média Salarial'
FROM
	DimCustomer
WHERE Occupation = 'Professional'

/* Exercício 3) Você precisará fazer uma análise da quantidade de funcionários das lojas registradas na 
empresa. O seu gerente te pediu os seguintes números e informações: 
a) Quantos funcionários tem a loja com mais funcionários? 
b) Qual é o nome dessa loja? 
c) Quantos funcionários tem a loja com menos funcionários? 
d) Qual é o nome dessa loja? */

-- A)
SELECT
	MAX(EmployeeCount) AS 'Maior Qtd. Funcionários'
FROM
	DimStore

-- B)
SELECT
	TOP(1) StoreName AS 'Nome da Loja',
	EmployeeCount AS 'Qtd. Funcionários'
FROM
	DimStore
ORDER BY EmployeeCount DESC

-- C)
SELECT
	MIN(EmployeeCount) AS 'Menor Qtd. Funcionários'
FROM
	DimStore

-- D)
SELECT
	TOP(1) StoreName,
	EmployeeCount
FROM
	DimStore
WHERE EmployeeCount IS NOT NULL
ORDER BY EmployeeCount ASC

/* Exercício 4) A área de RH está com uma nova ação para a empresa, e para isso precisa saber a quantidade 
total de funcionários do sexo Masculino e do sexo Feminino.  
a) Descubra essas duas informações utilizando o SQL. 
b) O funcionário e a funcionária mais antigos receberão uma homenagem. Descubra as 
seguintes informações de cada um deles: Nome, E-mail, Data de Contratação.*/

-- Quantidade total de mulheres
SELECT
	COUNT(FirstName)
FROM
	DimEmployee
WHERE Gender IN ('F')

-- Funcionário masculino mais antigo
SELECT
	TOP(1) FirstName AS 'Nome',
	EmailAddress AS 'E-mail',
	HireDate AS 'Data de Contratação' 
FROM 
	DimEmployee
WHERE Gender IN ('M')
ORDER BY HireDate ASC

/* Exercício 5) Agora você precisa fazer uma análise dos produtos. Será necessário descobrir as seguintes 
informações: 
a) Quantidade distinta de cores de produtos. 
b) Quantidade distinta de marcas 
c) Quantidade distinta de classes de produto 
Para simplificar, você pode fazer isso em uma mesma consulta. */
SELECT
	COUNT(DISTINCT ColorName) AS 'Cores',
	COUNT(DISTINCT BrandName) AS 'Marcas',
	COUNT(DISTINCT ClassName) AS 'Classes de Produtos'
FROM
	DimProduct