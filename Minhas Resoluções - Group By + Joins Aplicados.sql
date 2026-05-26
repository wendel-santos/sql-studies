-- OBS: Perdi os enunciados

-- Exercício 1
-- a)
SELECT
	ChannelName AS 'Canal De Vendas',
	SUM(SalesQuantity) AS 'Qtd. Vendida'
FROM
	FactSales
INNER JOIN DimChannel
	ON FactSales.channelKey = DimChannel.channelKey
GROUP BY ChannelName
ORDER BY SUM(SalesQuantity) DESC

-- b) Aqui só muda que ele ordenou pela StoreName
SELECT
	StoreName AS 'Loja',
	SUM(SalesQuantity) AS 'Qtd. Vendida',
	SUM(ReturnQuantity) AS 'Qtd. Devolvida'
FROM
	FactSales
INNER JOIN DimStore
	ON FactSales.StoreKey = DimStore.StoreKey
GROUP BY StoreName
ORDER BY SUM(SalesQuantity), SUM(ReturnQuantity)

-- c) 
/* Aqui ele fez diferente e ordenou pela coluna CalendarMonth, já que ambas do Group by ali retornaria os meses de forma aleatória.
Com essa coluna, ele pôde entrão trazer na order crescente (ps: pra não dar erro, essa coluna também foi no Group by junto com as outras 2). */

SELECT top(100)
	CalendarYear AS 'Ano',
	CalendarMonthLabel AS 'Mês',
	SUM(SalesAmount) AS 'Qtd. Vendida'
FROM
	FactSales
INNER JOIN DimDate
	ON FactSales.DateKey = DimDate.DateKey
GROUP BY CalendarMonthLabel, CalendarYear
ORDER BY SUM(SalesAmount) desc

-- Exercício 2
SELECT TOP(100) * FROM FactSales
SELECT TOP(100) * FROM DimProduct
-- a)
SELECT 
	TOP(1) ColorName AS 'Cor', 
	SUM(SalesAmount) AS 'Qtd. Vendidada'
FROM
	FactSales
INNER JOIN DimProduct
	ON FactSales.ProductKey = DimProduct.ProductKey 
GROUP BY ColorName
ORDER BY SUM(SalesAmount) DESC

-- b) Errei, era SalesQuantity no enunciado e não a SalesAmount 
SELECT 
	ColorName AS 'Cor', 
	SUM(SalesAmount) AS 'Qtd. Vendidada'
FROM
	FactSales
INNER JOIN DimProduct
	ON FactSales.ProductKey = DimProduct.ProductKey 
GROUP BY ColorName
HAVING SUM(SalesAmount) > 3000000
ORDER BY SUM(SalesAmount) DESC

-- Exercício 3
SELECT
	ProductCategoryName,
	SUM(SalesQuantity) AS 'Qtd. Vendida'
FROM
	FactSales
INNER JOIN DimProduct
	ON FactSales.ProductKey = DimProduct.ProductKey
INNER JOIN DimProductSubcategory
	ON DimProduct.ProductSubcategoryKey = DimProductSubcategory.ProductSubcategoryKey
INNER JOIN DimProductCategory
	ON DimProductSubcategory.ProductCategoryKey = DimProductCategory.ProductCategoryKey
GROUP BY ProductCategoryName

-- Exercício 4
-- a) ESSA ERREI FEIO
SELECT TOP(10) 
	f.CustomerKey AS 'ID Clinte',
	MAX(FirstName) AS 'Nome',
	MAX(MiddleName) AS 'Sobrenome',
	MAX(LastName) AS 'Sobrenome',
	SUM(f.SalesQuantity) AS 'Qtd. Vendida'
FROM 
	FactOnlineSales f
INNER JOIN DimCustomer d
	ON d.CustomerKey = f.CustomerKey 
GROUP BY f.CustomerKey
ORDER BY SUM(f.SalesQuantity) DESC

/* Fiz tudo errado kkkkkkkkkkkk. O ponto chave ali foi a cláusula WHERE, que ele colocou para separar as pessoas físicas das empresas.
Por isso o meu resultado só deu NULL e, nisso, achei que fosse um troll dele kkkkkkkk. Interessante é que mesmo eu trocando aquela
parte on ali (lado direito pra esquerdo e vice-versa), o código pegou normal. 

SELECT 
	DimCustomer.CustomerKey,
	FirstName AS 'Nome',
	LastName AS 'Sobrenome',
	SUM(SalesQuantity) AS 'Qtd. Vendida'
FROM 
	FactOnlineSales
INNER JOIN DimCustomer
	ON FactOnlineSales.CustomerKey = DimCustomer.CustomerKey 
WHERE CustomerType = 'Person'
GROUP BY d.CustomerKey, FirstName, LastName
ORDER BY SUM(SalesQuantity) DESC
*/

-- b) Consequentemente, eu erro aqui também graças a de cima (puxei da empresa)
SELECT 
	TOP(10)	ProductName AS 'Produto',
	SUM(SalesQuantity) AS 'Qtd. Vendida'
FROM
	FactOnlineSales
INNER JOIN DimProduct
	ON FactOnlineSales.ProductKey = DimProduct.ProductKey
GROUP BY ProductName
ORDER BY SUM(SalesQuantity) DESC

/*
SELECT TOP(10)
	ProductName AS 'Produto',
	SUM(SalesQuantity) AS 'Qtd. Vendida'
FROM
	FactOnlineSales
INNER JOIN DimProduct
	ON FactOnlineSales.ProductKey = DimProduct.ProductKey
WHERE CustomerKey = 7665
GROUP BY ProductName
ORDER BY SUM(SalesQuantity) DESC
*/

-- Exercício 5
SELECT
	Gender AS 'Sexo',
	SUM(SalesQuantity) AS 'Qtd. Vendida'
FROM
	FactOnlineSales
INNER JOIN DimCustomer
	ON FactOnlineSales.CustomerKey = DimCustomer.CustomerKey
WHERE Gender IS NOT NULL
GROUP BY Gender

-- Exercício 6 
/* Aqui eu errei de bobeira. Usei o WHERE ao invés do HAVING. E mais, mas ele nem colocou a CurrencyKey. Logo, o código dele ficou mais enxuto. */
SELECT 
	FactExchangeRate.CurrencyKey AS 'ID Câmbio',
	CurrencyDescription AS 'Desc. Câmbio',
	AVG(AverageRate) AS 'Câmbio Médio'
FROM FactExchangeRate
	INNER JOIN DimCurrency
ON FactExchangeRate.CurrencyKey = DimCurrency.CurrencyKey
WHERE AverageRate BETWEEN 10 AND 100
GROUP BY FactExchangeRate.CurrencyKey, CurrencyDescription
ORDER BY FactExchangeRate.CurrencyKey

-- Exercício 7
/* Aqui eu quase errei pelo mesmo motivo da anterior, useo o WHERE ao invez do HAVING. Por sorte o resultado deu o mesmo.
Outra coisa foi que ele filtrou difetente, ex: ScenarioName <> 'Forecast'. E, de novo, não precisada do ID...  */
SELECT
	f.ScenarioKey AS 'ID Cenário',
	ScenarioName AS 'Cenário',
	SUM(Amount) AS 'Valor'
FROM FactStrategyPlan f
INNER JOIN DimScenario
	ON f.ScenarioKey = DimScenario.ScenarioKey
WHERE ScenarioName IN ('Budget', 'Actual')
GROUP BY f.ScenarioKey, ScenarioName

-- Exercício 8
/* Fiz errado, era pra puxar da tabela DimDate e não a DimScenario */
SELECT
	ScenarioName AS 'Cenário',
	DateKey AS 'Ano',
	SUM(Amount) AS 'Valor'
FROM FactStrategyPlan F
	INNER JOIN DimScenario
		ON F.ScenarioKey = DimScenario.ScenarioKey
GROUP BY DateKey, ScenarioName
ORDER BY DateKey

-- Exercício 9 - Novamente, não precisava do ID kkkk. Mas, ao menos acertei o WHERE.
SELECT
	d.ProductSubcategoryKey AS 'ID Subcategoria',
	ProductSubcategoryName AS 'Subcategoria',
	COUNT(ProductName) AS 'Qtd. Produto'
FROM DimProduct d
INNER JOIN DimProductSubcategory dp
	ON d.ProductSubcategoryKey = dp.ProductSubcategoryKey
WHERE BrandName = 'Contoso' AND ColorName = 'Silver'
GROUP BY d.ProductSubcategoryKey, ProductSubcategoryName
ORDER BY d.ProductSubcategoryKey

-- Exercício 10
SELECT 
	BrandName AS 'Marca',
	ProductSubcategoryName AS 'Subcategoria',
	COUNT(ProductName) AS 'Qtd. Produto'
FROM DimProduct p
	INNER JOIN DimProductSubcategory ps
		ON p.ProductSubcategoryKey = PS.ProductSubcategoryKey
GROUP BY BrandName, ProductSubcategoryName
ORDER BY BrandName