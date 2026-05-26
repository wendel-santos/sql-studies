/* 1. Para fins fiscais, a contabilidade da empresa precisa de uma tabela contendo todas as vendas 
referentes à loja ‘Contoso Orlando Store’. Isso porque essa loja encontra-se em uma região onde 
a tributação foi modificada recente. 
Portanto, crie uma consulta ao Banco de Dados para obter uma tabela FactSales contendo todas 
as vendas desta loja. */

SELECT TOP (100)
	*
FROM
	FactSales
WHERE StoreKey = (
	SELECT
		StoreKey
	FROM
		DimStore
	WHERE StoreName = 'Contoso Orlando Store')

/* 2. O setor de controle de produtos quer fazer uma análise para descobrir quais são os produtos 
que possuem um UnitPrice maior que o UnitPrice do produto de ID igual a 1893. 
a) A sua consulta resultante deve conter as colunas ProductKey, ProductName e UnitPrice 
da tabela DimProduct. 
b) Nessa query você também deve retornar uma coluna extra, que informe o UnitPrice do 
produto 1893.  */

-- O meu ficou incompleto. O correto seria tirar o ORDER BY e colocar um WHERE justamento com o mesmo código daquela subquery na última coluna. 
SELECT
	ProductKey AS 'ID Produto', 
	ProductName AS 'Produto',
	UnitPrice AS 'Preço Unitário',
	(SELECT UnitPrice FROM DimProduct WHERE ProductKey = 1893) AS 'Preço Unitário ID 1893'
FROM
	DimProduct
ORDER BY UnitPrice DESC
-- (faltou isso) WHERE > (SELECT UnitPrice FROM DimProduct WHERE ProductKey = 1893)

/* 3. A empresa Contoso criou um programa de bonificação chamado “Todos por 1”. Este 
programa consistia no seguinte: 1 funcionário seria escolhido ao final do ano como o funcionário 
destaque, só que a bonificação seria recebida por todos da área daquele funcionário em 
particular. O objetivo desse programa seria o de incentivar a colaboração coletiva entre os 
funcionários de uma mesma área. Desta forma, o funcionário destaque beneficiaria não só a si, 
mas também a todos os colegas de sua área. 
Ao final do ano, o funcionário escolhido como destaque foi o Miguel Severino. Isso significa que 
todos os funcionários da área do Miguel seriam beneficiados com o programa. 
O seu objetivo é realizar uma consulta à tabela DimEmployee e retornar todos os funcionários 
da área “vencedora” para que o setor Financeiro possa realizar os pagamentos das bonificações. */

-- ID do funcionário destaque
SELECT EmployeeKey FROM DimEmployee WHERE FirstName = 'Miguel' AND LastName = 'Severino'
-- Puts, errei essa de vacilo! Esqueci de passar o código acima no lugar do ID 196 ali no WHERE... Resultado certo, mas não ficou automático.

-- Funcionários do setor campeão
SELECT 
	*
FROM
	DimEmployee
WHERE DepartmentName = (
	SELECT
		DepartmentName
	FROM
		DimEmployee
	WHERE EmployeeKey = 196
	)

/* 4. Faça uma query que retorne os clientes que recebem um salário anual acima da média. A sua 
query deve retornar as colunas CustomerKey, FirstName, LastName, EmailAddress e 
YearlyIncome. 
Obs: considere apenas os clientes que são 'Pessoas Físicas'. */

-- Ui, essa foi quase. Falou aquele AND ali no primeiro SELECT pra filtrar de novo os clientes.
SELECT
	CustomerKey, 
	FirstName, 
	LastName, 
	EmailAddress, 
	YearlyIncome
FROM
	DimCustomer
WHERE YearlyIncome > (
	SELECT
		AVG(YearlyIncome)
	FROM
		DimCustomer
	WHERE CustomerType = 'Person'
	)
-- AND CustomerType = 'Person'

/* 5. A ação de desconto da Asian Holiday Promotion foi uma das mais bem sucedidas da empresa. 
Agora, a Contoso quer entender um pouco melhor sobre o perfil dos clientes que compraram 
produtos com essa promoção. 
Seu trabalho é criar uma query que retorne a lista de clientes que compraram nessa promoção. */

-- 1 passo: ID da promoção Asian Holiday Promotion
SELECT PromotionKey FROM DimPromotion WHERE PromotionName = 'Asian Holiday Promotion'


-- 2 passo: ID's dos clientes que compraram na promoção
SELECT 
	CustomerKey																	-- AQUI!
FROM 
	FactOnlineSales
WHERE PromotionKey IN (
	SELECT PromotionKey FROM DimPromotion WHERE PromotionName = 'Asian Holiday Promotion'
	)

-- 3 passo (código final): Informações dos clientes que compraram na promoção
SELECT
	*
FROM
	DimCustomer
WHERE CustomerKey IN (
	SELECT 
	CustomerKey																	-- AQUI!
FROM 
	FactOnlineSales
WHERE PromotionKey IN (
	SELECT PromotionKey FROM DimPromotion WHERE PromotionName = 'Asian Holiday Promotion'
	)
)

/* Cara, essa foi pauleira. Eu travei nela e não consegui completar, não desconfiei que teria de fazer 3 selects aninhada.
Mas ai eu vi essa dica dele no início da aula e fui tentar de acordo com o passo a passo que ele destrinchou. 
Com isso, eu consegui chegar beeem perto do resultado final, o único ajuste que faltou foi passar aquela CustomerKey ao inves do * naquele 
	último 'aqui' ali em baixo, eu eu segui o fluxo do primeiro 'aqui'. Mas isso estava retornando um erro pois essa ainda era a subquery
	do meio e, as de dentro, não podem retornar vários valores (que é o caso do *).
# No final do dia, fica essa mega dica de resolver por partes e começar a resolver de dentro pra fora.
*/

/* 6. A empresa implementou um programa de fidelização de clientes empresariais. Todos aqueles 
que comprarem mais de 3000 unidades de um mesmo produto receberá descontos em outras 
compras. Você deverá descobrir as informações de CustomerKey e CompanyName destes clientes. */

SELECT CustomerKey, CompanyName FROM DimCustomer WHERE CustomerType = 'Company'
SELECT * FROM DimCustomer WHERE CustomerKey = (SELECT CustomerKey FROM DimCustomer WHERE CustomerType = 'Company')

/* Acima, o fiasco de código que eu fiz. Abaixo, a resolução correta. Não precisava passar a CompanyName e o COUNT como tabela
	no SELECT de dentro porque ele não queria aqueles valores, e faz sentido já que retornaria mais de 1 (mais de um é B.O, lembra?).
	E, olha só como no GROUP BY ele passa uma coluna que nem está no SELECT. */
SELECT 
	CustomerKey, 
	CompanyName 
FROM 
	DimCustomer 
WHERE CustomerKey IN (
	SELECT 
		CustomerKey
	FROM FactOnlineSales 
	GROUP BY CustomerKey, ProductKey 
	HAVING COUNT(*) >= 3000
	)

/* 7. Você deverá criar uma consulta para o setor de vendas que mostre as seguintes colunas da 
tabela DimProduct: 
ProductKey, 
ProductName, 
BrandName, 
UnitPrice 
Média de UnitPrice.  */

-- Ufa, finalmente acertei uma!
SELECT
	ProductKey AS 'ID Produto', 
	ProductName AS 'Produto', 
	BrandName AS 'Marca', 
	UnitPrice AS 'Preço Unitário', 
	(SELECT AVG(UnitPrice) FROM DimProduct) AS 'Média do Preço Unitário'
FROM
	DimProduct

/* 8. Faça uma consulta para descobrir os seguintes indicadores dos seus produtos: 
Maior quantidade de produtos por marca 
Menor quantidade de produtos por marca 
Média de produtos por marca  */

SELECT 
	BrandName,
	(SELECT TOP(1) COUNT(*) FROM DimProduct GROUP BY BrandName ORDER BY COUNT(*) DESC) AS 'Maior Qtd',
	(SELECT TOP(1) COUNT(*) FROM DimProduct GROUP BY BrandName ORDER BY COUNT(*) ASC) AS 'Menor Qtd',
	(SELECT AVG(ProductKey) FROM DimProduct) AS 'Média'
FROM 
	DimProduct

/* Puts, eu interpretei totalmente errado essa questão aqui, olha o mostro que eu criei kkkkk. Ele disse que a ideia aqui era passar aquele SELECT
como coluna ao invés de criar uma VIEW, que poderia ser feita também mas que assim era até melhor. */
SELECT
	MAX(Quantidade) AS 'Máximo',
	MIN(Quantidade) AS 'Mínimo',
	AVG(Quantidade) AS 'Média'
FROM (
	SELECT
		BrandName,
		COUNT(*) AS 'Quantidade'
	FROM DimProduct
	GROUP BY BrandName
	) AS T

/* 9. Crie uma CTE que seja o agrupamento da tabela DimProduct, armazenando o total de 
produtos por marca. Em seguida, faça um SELECT nesta CTE, descobrindo qual é a quantidade 
máxima de produtos para uma marca. Chame esta CTE de CTE_QtdProdutosPorMarca.  */

-- Oia, acertei outra kkkk. Só muda que ele nomeou apenas a coluna do COUNT, como 'Quantidade'.
WITH CTE_QtdProdutosPorMarca (Marca, Qtd_Produtos) AS (
	SELECT 
		BrandName,
		COUNT(ProductKey)
	FROM
		DimProduct
	GROUP BY BrandName
	)

SELECT MAX(Qtd_Produtos) FROM CTE_QtdProdutosPorMarca

/* 10. Crie duas CTEs:  
(i) a primeira deve conter as colunas ProductKey, ProductName, ProductSubcategoryKey, 
BrandName e UnitPrice, da tabela DimProduct, mas apenas os produtos da marca Adventure 
Works. Chame essa CTE de CTE_ProdutosAdventureWorks. 
(ii) a segunda deve conter as colunas ProductSubcategoryKey, ProductSubcategoryName, da 
tabela DimProductSubcategory mas apenas para as subcategorias ‘Televisions’ e ‘Monitors’. 
Chame essa CTE de CTE_CategoriaTelevisionsERadio. 
Faça um Join entre essas duas CTEs, e o resultado deve ser uma query contendo todas as colunas 
das duas tabelas. Observe nesse exemplo a diferença entre o LEFT JOIN e o INNER JOIN. */

WITH CTE_ProdutosAdventureWorks AS (
	SELECT
		ProductKey, 
		ProductName, 
		ProductSubcategoryKey, 
		BrandName,
		UnitPrice
	FROM
		DimProduct
	WHERE BrandName = 'Adventure Works'
), 
CTE_CategoriaTelevisionsEMonitors AS (
	SELECT
		ProductSubcategoryKey,
		ProductSubcategoryName
	FROM
		DimProductSubcategory
	WHERE ProductSubcategoryName IN ('Televisions', 'Monitors')
)

SELECT 
	*
FROM 
	CTE_ProdutosAdventureWorks AS PAW
INNER JOIN CTE_CategoriaTelevisionsEMonitors AS CTM
	ON PAW.ProductSubcategoryKey = CTM.ProductSubcategoryKey
/*  Quase acertei, só muda que eu usei o INNER JOIN achando que seria melhor pra remover aquelas linhas NULL, mas não.
	Ele disse que a LEFT seria melhor pois essas linhas nulas levantam a pergunta do 'Por que estão assim?' caso alguma coluna seja NULL, e
	isso levaria a uma investigação. Mas, nesse nosso caso, a gente já sabe que não subcategorias não inclusas. 
	Também, renomeei a consulta igual ele, pra não ficar aqueles nomes realmente mega grandes.