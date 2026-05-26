/* 1. Quando estamos manipulando tabelas, é importante pensar em como os dados serão 
apresentados em um relatório. Imagine os nomes dos produtos da tabela DimProduct. Os 
textos são bem grandes e pode ser que mostrar os nomes completos dos produtos não seja a 
opção mais interessante, pois provavelmente não vão caber em um gráfico e a visualização 
ficará ruim. 
a) Seu gestor te pede para listar todos os produtos para que seja criado um gráfico para ser 
apresentado na reunião diária de equipe. Faça uma consulta à tabela DimProduct que 
retorne (1) o nome do produto e (2) a quantidade de caracteres que cada produto tem, 
e ordene essa tabela do produto com a maior quantidade de caracteres para a menor. 
b) Qual é a média de caracteres dos nomes dos produtos? 
c) Analise a estrutura dos nomes dos produtos e verifique se seria possível reduzir o tamanho 
do nome dos produtos. (Dica: existem informações redundantes nos nomes dos produtos? 
Seria possível substituí-las?) 
d) Qual é a média de caracteres nesse novo cenário? 
*/

-- a) Ele usou a função 'Len', que deu uma quantidade menor. O resto ficou tudo errado também, como suspeitei que não fosse conseguir esse.
SELECT 
	ProductName,
	AVG(DATALENGTH(ProductName))
FROM 
	DimProduct
ORDER BY DATALENGTH(ProductName) DESC

-- b) 81
SELECT 
	AVG(DATALENGTH(ProductName))
FROM 
	DimProduct

-- c)
SELECT
	LEFT(ProductName, 26)
FROM
	DimProduct,

-- A dele como ficou, sacada genial
SELECT 
	REPLACE(REPLACE(ProductName, BrandName, ''), ColorName, '')
FROM 
	DimProduct

/* 2.  A coluna StyleName da tabela DimProduct possui alguns códigos identificados por números 
distintos, que vão de 0 até 9, como pode ser visto no exemplo abaixo. 
Porém, o setor de controle decidiu alterar a identificação do StyleName, e em vez de usar 
números, a ideia agora é passar a usar letras para substituir os números, conforme exemplo 
abaixo: 
0 -> A, 1 -> B, 2 -> C, 3 -> D, 4 -> E, 5 -> F, 6 -> G, 7 -> H, 8 -> I, 9 - J 
É de sua responsabilidade alterar os números por letras na coluna StyleName da tabela 
DimProduct. Utilize uma função que permita fazer essas substituições de forma prática e rápida.
*/
-- Na mosca kkkkk
SELECT
	TRANSLATE(StyleName, '0123456789', 'ABCDEFGHIJ')
FROM
	DimProduct

/* 3. O setor de TI está criando um sistema para acompanhamento individual de cada funcionário da 
empresa Contoso. Cada funcionário receberá um login e senha. O login de cada funcionário será 
o ID do e-mail, como no exemplo abaixo: 
Já a senha será o FirtName + o dia do ano em que o funcionário nasceu, em MAIÚSCULA. Por 
exemplo, o funcionário com E-mail: mark0@contoso.com e data de nascimento 15/01/1990 
deverá ter a seguinte senha: 
Login: mark0 
Senha: MARK15 
O responsável pelo TI pediu a sua ajuda para retornar uma tabela contendo as seguintes colunas 
da tabela DimEmployee: Nome completo (FirstName + LastName), E-mail, ID do e-mail e Senha. 
Portanto, faça uma consulta à tabela DimProduct e retorne esse resultado. 
*/

SELECT 
	CONCAT(FirstName, LastName) AS 'Nome Completo',
	EmailAddress AS 'E-mail',
	CHARINDEX(EmailAddress, 11, -11) AS 'ID',
	CONCAT(UPPER(FirstName), DAY(BirthDate)) AS 'Senha'
FROM 
	DimEmployee

/* A minha eu fiz errado e nem percebi que a coluna 'ID' saiu toda zerada. A coluna Senha está errada também, ele usou outra função, vejamos:
	LEFT(EmailAddress, CHARINDEX('@', EmailAddress) -1) AS 'Login',
	UPPER(FirstName + DATENAME(DAYOFYEAR, BirthDate)) AS 'Senha'
*/

/* 4. A tabela DimCustomer possui o primeiro registro de vendas no ano de 2001.  
Como forma de reconhecer os clientes que compraram nesse ano, o setor de Marketing solicitou 
a você que retornasse uma tabela com todos os clientes que fizeram a sua primeira compra neste 
ano para que seja enviado uma encomenda com um presente para cada um. 
Para fazer esse filtro, você pode utilizar a coluna DateFirstPurchase, que contém a informação da 
data da primeira compra de cada cliente na tabela DimCustomer. 
Você deverá retornar as colunas de FirstName, EmailAddress, AddressLine1 e DateFirstPurchase 
da tabela DimCustomer, considerando apenas os clientes que fizeram a primeira compra no ano 
de 2001.
*/

SELECT 
	FirstName, 
	EmailAddress, 
	AddressLine1,
	DateFirstPurchase 
FROM 
	DimCustomer
WHERE FORMAT(DateFirstPurchase, 'yyyy') = '2001' 
-- Eu acertei, mas ele fez mais fácil ainda: YEAR(DateFirstPurchase) = 2001


/* 5. A tabela DimEmployee possui uma informação de data de contratação (HireDate). A área de 
RH, no entanto, precisa das informações dessas datas de forma separada em dia, mês e ano, pois 
será feita uma automatização para criação de um relatório de RH, e facilitaria muito se essas 
informações estivessem separadas em uma tabela. 
Você deverá realizar uma consulta à tabela DimEmployee e retornar uma tabela contendo as 
seguintes informações: FirstName, EmailAddress, HireDate, além das colunas de Dia, Mês e Ano 
de contratação.  
Obs1: A coluna de Mês deve conter o nome do mês por extenso, e não o número do mês. 
Obs2: Lembre-se de nomear cada uma dessas colunas em sua consulta para garantir que o 
entendimento de cada informação ficará 100% claro.   
*/

SELECT 
	 FirstName AS 'Nome', 
	 EmailAddress AS 'E-mail', 
	 HireDate AS 'Data de Contratação', 
	 DAY(HireDate) AS 'Dia', 
	 FORMAT(CAST(HireDate AS DATETIME), 'MMMM') AS 'Mês',
	 YEAR(HireDate) AS 'Ano'
FROM 
	DimEmployee
-- Novamente, acertei. Mas, ele sempre faz de uma forma mais fácil ao usar as fórmulas de data: DATENAME(MONTH, HireDate) AS 'Mês'

/* 6. Descubra qual é a loja que possui o maior tempo de atividade (em dias). Você deverá fazer essa 
consulta na tabela DimStore, e considerar a coluna OpenDate como referência para esse cálculo. 
*/

SELECT TOP(1)
	StoreName,
	DATEDIFF(DAY, OpenDate, GETDATE()) AS 'Dias',
	DATEDIFF(YEAR, OpenDate, GETDATE()) AS 'Anos'
FROM DimStore
ORDER BY DATEDIFF(DAY, GETDATE(), OpenDate) ASC

-- Tinha uma pegadinha nessa era a coluna de CloseDate. Logo, teriamos que colocar um WHERE assim: WHERE CloseDate IS NULL