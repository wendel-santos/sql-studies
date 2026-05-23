-- Exercício 1: TOP 100 produtos mais vendidos
SELECT
	top(100) *
FROM
	FactSales
ORDER BY SalesQuantity DESC

-- Exercício 2: TOP 10 produtos com maior preço unitário. Ordenado por preço, peso e tamanho
SELECT
	Top (10) *
FROM
	DimProduct
ORDER BY UnitPrice DESC, Weight DESC, AvailableForSaleDate ASC

-- Exercício 3: Produtos da categoria 1 com mais de 100kg
SELECT 
	ProductName AS 'Produto do Produto',
	Weight AS 'Peso'
FROM
	DimProduct
WHERE Weight > 100
ORDER BY Weight DESC
/* Eu fiz igual ele e apaguei o 'ProductSubcategoryKey = 1 AND' no WHERE pois o codigo nem funcionando estava. 
E, claro, não precisava. Mas eu achei que sim para saparar, mas o próprio WHERE ali já está fazendo isso :P  */

-- Exercício 4: Número total de lojas
SELECT 
	StoreName AS 'Nome da Loja',
	OpenDate AS 'Data de Abertura', 
	EmployeeCount AS 'Qtd. de Funcionários'
FROM
	DimStore
WHERE Status = 'On'
-- Tinha que filtrar 'StoryType = 'Store'' também, que seriam apenas as físicas. Mas ele falou que era uma nuance, tava de boa.

-- Exercício 5: Produtos 'Home Theater' do dia 15/03/2009 com defeito
SELECT
	ProductKey -- ** Aqui era o '*' mesmo
FROM
	DimProduct
WHERE BrandName = 'Litware' AND ProductName LIKE '%Home Theater%' AND AvailableForSaleDate = '2009/03/15'
/* ** Ele disse que aqui tinha uma pegadinha, que era o fato da coluna da data ser do tipo Date/Time. Na dele, retornou um erro. 
Eu fiz um teste aqui igual a dele e continuou pegando normal, mas fica a dica de remover os 'traços' ou 'colunas' da data 
caso o mesmo dê erro futuramente, para que o código funcione normal. */

-- Exercício 6: 
-- Opção A) Através da coluna 'Status'
SELECT
	*
FROM
	DimStore
WHERE Status = 'Off'

-- Opção B) Através da coluna 'CloseDate'
SELECT
	*
FROM
	DimStore
WHERE CloseDate IS NOT NULL 

-- Exercício 7: Distribuição das máquinas de café pela quantidade de funcionários em cada loja
-- A) Categoria 1 (1 a 20 funcionários) = 75 no total
SELECT 
	*
FROM
	DimStore
WHERE EmployeeCount <= 20

-- B) Categoria 1 (21 a 50 funcionários) = 187 no total
SELECT
	*
FROM
	DimStore
WHERE EmployeeCount BETWEEN 21 AND 50

-- C) Categoria 1 (Acima de 51 funcionários) = 43 no total
SELECT
	*
FROM
	DimStore
WHERE EmployeeCount > 50


-- Exercício 8: Produtos com 'LCD' no nome
SELECT
	ProductKey AS 'ID do Produto',
	ProductName AS 'Nome do Produto',
	UnitPrice AS 'Preço'
FROM
	DimProduct
WHERE ProductName LIKE '%LCD%'
-- Errei, ele fez usando o 'ProductDescription', que inclusive deu mais produtos.

-- Exercício 9: Produtos das marcas: Contoso, Litware ou Fabrikam, nas cores especificadas
SELECT
	*
FROM
	DimProduct
WHERE BrandName IN ('Contoso', 'Litware', 'Fabrikam') AND ColorName IN ('Green', 'Orange', 'Black', 'Silver', 'Pink')
/* Eu tinha colocado o 'BrandName' dentro de brackets pra ir primeiro, mas não precisava e eu nem me toquei. 
Também, ele fez pela 'ColorName' primeiro, mas deu na mesma. */

-- Exercício 10: Produtos da marca 'Contoso' na cor 'Silver' e com o preço entre 10 e 30
SELECT
	ProductKey AS 'ID',
	ProductName AS 'Nome do Produto',
	UnitPrice AS 'Preço do Produto'
FROM
	DimProduct
WHERE BrandName = 'Contoso' AND ColorName = 'Silver' AND Weight BETWEEN 10 AND 30
ORDER BY UnitPrice DESC