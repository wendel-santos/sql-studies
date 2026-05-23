/* FACTSALES
-- Exercício 1 - a) Faça um resumo da quantidade vendida (SalesQuantity) de acordo com o canal de vendas 
(channelkey). 
b) Faça um agrupamento mostrando a quantidade total vendida (SalesQuantity) e quantidade 
total devolvida (Return Quantity) de acordo com o ID das lojas (StoreKey). 
c) Faça um resumo do valor total vendido (SalesAmount) para cada canal de venda, mas apenas 
para o ano de 2007. */

-- a)
SELECT
	channelKey AS 'Canal de Venda',
	SUM(SalesQuantity) AS 'Total Vendido'
FROM
	FactSales
GROUP BY channelKey

-- b)
SELECT
	StoreKey AS 'ID da Loja',
	SUM(SalesQuantity) AS 'Total Vendida',
	SUM(ReturnQuantity) AS 'Total Devolvida'
FROM
	FactSales
GROUP BY StoreKey

-- c)
SELECT
	channelKey AS 'Canal de Venda',
	SUM(SalesAmount) AS 'Faturamento Total'
FROM
	FactSales
WHERE DateKey BETWEEN '2007-01-01' AND '2007-12-31'
GROUP BY channelKey

/* Exercício 2) Você precisa fazer uma análise de vendas por produtos. O objetivo final é descobrir o valor 
total vendido (SalesAmount) por produto (ProductKey).  
a) A tabela final deverá estar ordenada de acordo com a quantidade vendida e, além disso, 
mostrar apenas os produtos que tiveram um resultado final de vendas maior do que 
$5.000.000. 
b) Faça uma adaptação no exercício anterior e mostre os Top 10 produtos com mais vendas. 
Desconsidere o filtro de $5.000.000 aplicado. */

-- a)
SELECT
	ProductKey AS 'ID do Produto',
	SUM(SalesAmount) AS 'Faturamento Total'
FROM
	FactSales
GROUP BY ProductKey
HAVING SUM(SalesAmount) >= 5000000
ORDER BY SUM(SalesAmount) DESC

-- b)
SELECT
	TOP(10) ProductKey AS 'ID do Produto',
	SUM(SalesAmount) AS 'Faturamento Total'
FROM
	FactSales
GROUP BY ProductKey
ORDER BY SUM(SalesAmount) DESC

-- FACTONLINESALES
/* Exercício 3) a) Você deve fazer uma consulta à tabela FactOnlineSales e descobrir qual é o ID 
(CustomerKey) do cliente que mais realizou compras online (de acordo com a coluna 
SalesQuantity). 
b) Feito isso, faça um agrupamento de total vendido (SalesQuantity) por ID do produto 
e descubra quais foram os top 3 produtos mais comprados pelo cliente da letra a). */

-- a)
SELECT 
	TOP(1)CustomerKey AS 'ID do Cliente', 
	SUM(SalesQuantity) AS 'Qtd. Comprada'
FROM
	FactOnlineSaleS
GROUP BY CustomerKey
ORDER BY SUM(SalesQuantity) DESC

-- b) ERREI AQUI! Era SUM e não COUNT. Apesar que o resultado foi o 'mesmo', aumentando apenas +2 em cada resultado (curioso!)
SELECT 
	TOP(3) ProductKey AS 'ID do Produto',
	COUNT(SalesQuantity) AS 'Qtd. Vendida'
FROM
	FactOnlineSaleS
WHERE CustomerKey = 19037
GROUP BY ProductKey
ORDER BY COUNT(SalesQuantity) DESC

-- DIMPRODUCT
/* Exercício 4)  
4. a) Faça um agrupamento e descubra a quantidade total de produtos por marca. 
b) Determine a média do preço unitário (UnitPrice) para cada ClassName. 
c) Faça um agrupamento de cores e descubra o peso total que cada cor de produto possui. */

-- a) Usei Product name no COUNT enquanto ele repetiu o BrandName, mas o resultado foi o mesmo!
SELECT
	BrandName,
	COUNT(ProductKey) AS 'Qtd. Produtos'
FROM 
	DimProduct
GROUP BY BrandName
ORDER BY COUNT(ProductKey) DESC

-- b) Nesses 3 excercícios (a, b & c) eu usei o ORDER BY só pra organizar mesmo, mas não era necessário.
SELECT
	ClassName,
	AVG(UnitPrice) AS 'Preço Médio'
FROM 
	DimProduct
GROUP BY ClassName
ORDER BY AVG(UnitPrice) DESC

-- c)
SELECT
	ColorName AS 'Cor',
	SUM(Weight) AS 'Peso Total'
FROM
	DimProduct
GROUP BY ColorName
ORDER BY COUNT(Weight) DESC

/* Exercício 5) Você deverá descobrir o peso total para cada tipo de produto (StockTypeName).  
A tabela final deve considerar apenas a marca ‘Contoso’ e ter os seus valores classificados em 
ordem decrescente. */

SELECT
	StockTypeName AS 'Tipo de Estoque',
	SUM(Weight) AS 'Peso Total'
FROM
	DimProduct
WHERE BrandName = 'Contoso'
GROUP BY StockTypeName
ORDER BY SUM(Weight) DESC

/* Exercício 6) Você seria capaz de confirmar se todas as marcas dos produtos possuem à disposição todas as 
16 opções de cores? */

SELECT
	BrandName AS 'Marca',
	COUNT(DISTINCT ColorName) AS 'Qtd. Cores'
FROM
	DimProduct
GROUP BY BrandName

-- DIMCUSTOMER
/* Exercício 7) Faça um agrupamento para saber o total de clientes de acordo com o Sexo e também a média 
salarial de acordo com o Sexo. Corrija qualquer resultado “inesperado” com os seus 
conhecimentos em SQL.  */

SELECT
	Gender AS 'Sexo',
	COUNT(Gender) AS 'Qtd. de Pessoas',
	AVG(YearlyIncome) AS 'Média Salarial'
FROM
	DimCustomer
WHERE Gender IS NOT NULL
GROUP BY Gender

/* Exercício 8) Faça um agrupamento para descobrir a quantidade total de clientes e a média salarial de 
acordo com o seu nível escolar. Utilize a coluna Education da tabela DimCustomer para fazer 
esse agrupamento.  */

SELECT
	Education AS 'Nível Escolar',
	COUNT(CustomerKey) AS 'Qtd. Clientes',
	AVG(YearlyIncome) AS 'Média Salarial'
FROM
	DimCustomer
WHERE Education IS NOT NULL
GROUP BY Education
ORDER BY COUNT(Education) DESC

-- DIMEMPLOYEE
/* Exercício 9) Faça uma tabela resumo mostrando a quantidade total de funcionários de acordo com o 
Departamento (DepartmentName). Importante: Você deverá considerar apenas os 
funcionários ativos. */
SELECT
	DepartmentName AS 'Departamento', 
	COUNT(EmployeeKey) AS 'Qtd. Funcionários'
FROM
	DimEmployee
WHERE EndDate IS NULL
GROUP BY DepartmentName

/* Exercício 10) Faça uma tabela resumo mostrando o total de VacationHours para cada cargo (Title). Você 
deve considerar apenas as mulheres, dos departamentos de Production, Marketing, 
Engineering e Finance, para os funcionários contratados entre os anos de 1999 e 2000.  */
SELECT
	Title AS 'Cargo', 
	COUNT(VacationHours) AS 'Horas de férias'
FROM
	DimEmployee
WHERE (Gender = 'F') AND DepartmentName IN ('Production', 'Marketing', 'Engineering', 'Finance') AND HireDate BETWEEN '1999-01-01' AND '2000-12-31'
GROUP BY Title
-- Essa eu errei também, era SUM e não COUNT (faz sentido olhando agora, no meu foi diminuindo as horas kkkkkkk)