-- Exercício 1. Utilize o INNER JOIN para trazer os nomes das subcategorias dos produtos, da tabela DimProductSubcategory para a tabela DimProduct. 

SELECT
	ProductKey AS 'ID do Produto',
	ProductName AS 'Nome do Produto',
	ProductSubcategoryName AS 'Categoria'
FROM
	DimProduct
INNER JOIN DimProductSubcategory
	ON DimProduct.ProductSubcategoryKey = DimProductSubcategory.ProductSubcategoryKey

/* Exercício 2 - Identifique uma coluna em comum entre as tabelas DimProductSubcategory e DimProductCategory. 
Utilize essa coluna para complementar informações na tabela DimProductSubcategory a partir da DimProductCategory. Utilize o LEFT JOIN. */
SELECT
	ProductSubcategoryKey AS 'ID da Subcategoria',
	ProductSubcategoryName AS 'Nome da Subcategoria',
	ProductCategoryName AS 'Nome da Categoria'
FROM
	DimProductSubcategory
LEFT JOIN DimProductCategory
	ON DimProductSubcategory.ProductCategoryKey = DimProductCategory.ProductCategoryKey

/* Exercício 3 - Para cada loja da tabela DimStore, descubra qual o Continente e o Nome do País associados 
(de acordo com DimGeography). Seu SELECT final deve conter apenas as seguintes colunas: 
StoreKey, StoreName, EmployeeCount, ContinentName e RegionCountryName. Utilize o LEFT 
JOIN neste exercício. */

SELECT
	StoreKey, 
	StoreName, 
	EmployeeCount, 
	ContinentName,
	RegionCountryName
FROM 
	DimStore
LEFT JOIN DimGeography
	ON DimStore.GeographyKey = DimGeography.GeographyKey

/* Exercício 4 - Complementa a tabela DimProduct com a informação de ProductCategoryDescription. Utilize 
o LEFT JOIN e retorne em seu SELECT apenas as 5 colunas que considerar mais relevantes. */

SELECT
	ProductKey AS 'ID',
	ProductName AS 'Produto',
	DimProductSubcategory.ProductSubcategoryKey AS 'ID Subcategoria',
	ProductSubcategoryName AS 'Subcategoria',
	ProductCategoryDescription AS 'Descrição Categoria'
FROM 
	DimProduct
LEFT JOIN DimProductSubcategory
	ON DimProduct.ProductSubcategoryKey = DimProductSubcategory.ProductSubcategoryKey
		LEFT JOIN DimProductCategory 
			ON DimProductSubcategory.ProductCategoryKey = DimProductCategory.ProductCategoryKey

/* Exercício 5 - A tabela FactStrategyPlan resume o planejamento estratégico da empresa. Cada linha 
representa um montante destinado a uma determinada AccountKey.  
a) Faça um SELECT das 100 primeiras linhas de FactStrategyPlan para reconhecer a tabela. 
b) Faça um INNER JOIN para criar uma tabela contendo o AccountName para cada 
AccountKey da tabela FactStrategyPlan. O seu SELECT final deve conter as colunas: 
• StrategyPlanKey 
• DateKey 
• AccountName 
• Amount */

SELECT TOP(100) * FROM FactStrategyPlan
SELECT * FROM DimAccount

SELECT TOP(100) 
	StrategyPlanKey AS 'ID do Plano',
	DateKey AS 'Data',
	AccountName AS ' Conta',
	Amount AS 'Valor Total'
FROM
	FactStrategyPlan
INNER JOIN DimAccount
	ON FactStrategyPlan.AccountKey = DimAccount.AccountKey
-- Esse eu fiz certinho mas o resultado saiu numa ordenação diferente, não entendi
	
/* Exercício 6 - Vamos continuar analisando a tabela FactStrategyPlan. Além da coluna AccountKey que 
identifica o tipo de conta, há também uma outra coluna chamada ScenarioKey. Essa coluna 
possui a numeração que identifica o tipo de cenário: Real, Orçado e Previsão. 
Faça um INNER JOIN para criar uma tabela contendo o ScenarioName para cada ScenarioKey 
da tabela FactStrategyPlan. O seu SELECT final deve conter as colunas: 
• StrategyPlanKey 
• DateKey 
• ScenarioName  
• Amount */

SELECT TOP(100) * FROM FactStrategyPlan
SELECT TOP(100) * FROM DimScenario

SELECT TOP(1000)
	StrategyPlanKey AS 'ID do Plano',
	DateKey AS 'Data',
	ScenarioName AS 'Cenário',
	Amount 'Valor Total'
FROM
	FactStrategyPlan
INNER JOIN DimScenario
	ON FactStrategyPlan.ScenarioKey = DimScenario.ScenarioKey

-- Exercício 7 Algumas subcategorias não possuem nenhum exemplar de produto. Identifique que subcategorias são essas. 
SELECT 
	ProductName AS 'Produto',
	DimProduct.ProductSubcategoryKey AS 'ID da Subcategoria',
	ProductSubcategoryName AS 'Subcategoria'
FROM 
	DimProduct
RIGHT JOIN DimProductSubcategory
	ON DimProduct.ProductSubcategoryKey = DimProductSubcategory.ProductSubcategoryKey
WHERE ProductName IS NULL

/* Exercício 8 - A tabela abaixo mostra a combinação entre Marca e Canal de Venda, para as marcas Contoso, 
Fabrikam e Litware. Crie um código SQL para chegar no mesmo resultado. */

SELECT TOP(100)
	BrandName AS 'Marca',
	DimChannel.ChannelName AS 'Canal de Vendas'
FROM
	FactSales CROSS JOIN DimProduct 
LEFT JOIN DimProduct 
	ON FactSales.ProductKey = DimProduct.ProductKey
WHERE BrandName IN ('Contoso', 'Fabrikam', 'Litware')
/* Falhei miseravelmente nesse aqui. E, infelizmente, foi o ÚNICO que não consegui nem sequer completar...
EDIT: O erro foi 
1) Ter usado a FactSales no FROM, e não a DimProduct (apesar que eu fui trocando e, devo ter começado pelo DimProduct mesmo, 
2) Era pra usar o DISTINCT no BrandName ali (tive essa ideia e testei também, mas como não funfou porque não era apenas isso, eu tirei kkkkk),
3) Não tinha que fazer nenhum LEFT JOIN ali, era só o CROSS JOIN mesmo*/

-- Abaixo, o código correto
SELECT
	DISTINCT BrandName AS 'Marca',
	ChannelName AS 'Canal de Vendas'
FROM
	DimProduct CROSS JOIN DimChannel 
WHERE BrandName IN ('Contoso', 'Fabrikam', 'Litware')
/* MORAL DA HISTÓRIA: Quando for usar o CROSS JOIN, tome muito cuidado com a coluna a ser selecionada. 
Se essa coluna não estiver considerando apenas os valores distintos, var dar ruim (os valores vão estar repetidos). */

/* Exercício 9 - Neste exercício, você deverá relacionar as tabelas FactOnlineSales com DimPromotion. 
Identifique a coluna que as duas tabelas têm em comum e utilize-a para criar esse 
relacionamento. 
Retorne uma tabela contendo as seguintes colunas: 
• OnlineSalesKey 
• DateKey 
• PromotionName 
• SalesAmount 
A sua consulta deve considerar apenas as linhas de vendas referentes a produtos com 
desconto (PromotionName <> ‘No Discount’). Além disso, você deverá ordenar essa tabela de 
acordo com a coluna DateKey, em ordem crescente. */

SELECT TOP(1000)
	OnlineSalesKey AS 'ID da Venda',
	DateKey AS 'Data',
	PromotionName AS 'Promoção',
	SalesAmount AS 'Qtd. Vendida'
FROM	
	FactOnlineSales
LEFT JOIN DimPromotion
	ON FactOnlineSales.PromotionKey = DimPromotion.PromotionKey
WHERE PromotionName <> 'No Discount'
ORDER BY DateKey ASC
/* Segundo que errei. 1) Usei LEFT ao invés de INNER JOIN, 2) não entendi a cola do enunciado e buscar a PromotionName IGUAL,
sendo que era DIFERENTE (<>) do 'No Discount', 3) Por fim, usei DESC quando era ASC */

/* Exercício 10 - A tabela abaixo é resultado de um Join entre a tabela FactSales e as tabelas: DimChannel, 
DimStore e DimProduct. Recrie esta consulta e classifique em ordem crescente de acordo com SalesAmount. */
SELECT TOP (1000)
	SalesKey AS 'ID',
	ChannelName AS 'Canal de Venda',
	StoreName AS 'Loja',
	ProductName AS 'Produto',
	SalesAmount AS 'Qtd. Vendida'
FROM
	FactSales
LEFT JOIN DimStore
	ON FactSales.StoreKey = DimStore.StoreKey
		LEFT JOIN DimChannel
			ON FactSales.channelKey = DimChannel.ChannelKey
				LEFT JOIN DimProduct
					ON FactSales.ProductKey = DimProduct.ProductKey
ORDER BY SalesAmount DESC
-- Acertei na cagada, usei só LEFT e ele só INNER JOIN kkkkkkkkkkk