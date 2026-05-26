/* 1. Utilize o Loop While para criar um contador que comece em um valor inicial @ValorInicial e 
termine em um valor final @ValorFinal. Você deverá printar na tela a seguinte frase: 
“O valor do contador é: “ + ___   */

DECLARE @ValorInicial INT
DECLARE @ValorFinal INT
SET @ValorInicial = 10
SET @ValorFinal = 1

WHILE @ValorInicial >= @ValorFinal
BEGIN
	PRINT 'O valor do contador é: ' + CONVERT(VARCHAR, @ValorInicial)
	SET @ValorInicial -= 1
END

/* 2. Você deverá criar uma estrutura de repetição que printe na tela a quantidade de contratações 
para cada ano, desde 1996 até 2003. A informação de data de contratação encontra-se na 
coluna HireDate da tabela DimEmployee. Utilize o formato: 
X contratações em 1996 
Y contratações em 1997 
Z contratações em 1998 
... 
... 
N contratações em 2003 
Obs: a coluna HireDate contém a data completa (dd/mm/aaaa). Lembrando que você deverá 
printar a quantidade de contratações por ano.  */

/* Aqui foi tristeza, muito provavelmente minha pior tentativa em todo o curso! Na solução da lição, ele deu a seguinte dica: sempre tente
resolver os problemas começando na coisa mais simples que você consegue fazer, que aí você vai ganhando confiança e vai ter mais tempo pra pensar na
solução */
SELECT Distinct HireDate, count(EmployeeKey) FROM DimEmployee GROUP BY  HireDate

DECLARE @varAno DATETIME
DECLARE @varQtd_Funcionarios INT
SET @varAno = (SELECT MIN(HireDate) FROM DimEmployee)
SET @varQtd_Funcionarios = 0
PRINT @varAno
PRINT @varQtd_Funcionarios

WHILE @varAno = 0 
BEGIN
	 @varQtd_Funcionarios + ' contratações em ' + @varAno
	 @varAno
END

SELECT * FROM @varQtd_Funcionarios
PRINT @varQtd_Funcionarios

-- Olha como ficou o código correto, simples demais kkkkkkkkkkk
DECLARE @AnoInicial = 1996
DECLARE @AnoFinal = 2003

WHILE AnoInicial <= AnoFinal
BEGIN
	DECLARE @QtdFuncionarios INT = (SELECT COUNT(*) FROM DimEmployee
									WHERE YEAR(HireDate) = @AnoInicial)
	PRINT CONCAT(@QtdFuncionarios, ' contratações em ', @AnoInicial)
	SET @AnoInicial = @AnoInicial + 1
END

-- 3. Utilize um Loop While para criar uma tabela chamada Calendario, contendo uma coluna que comece com a data 01/01/2021 e vá até 31/12/2021.

/* Aqui eu estava com dificuldades em incrementar a data, como foi feito com o DATEADD ALI. 
Sem falar que eu nunca ia me lembrar 100% da criação/inserção de uma tabela (devo me preocupar? KKKKK) */

CREATE TABLE Calendario (
	Data DATE
)

DECLARE @varDataInicial DATETIME = '2021/01/01'
DECLARE @varDataFinal DATETIME = '2021/12/31'

WHILE @varDataInicial <= @varDataFinal
BEGIN
	INSERT INTO Calendario (Data) VALUES (@varDataInicial)
	SET @varDataInicial = DATEADD(DAY, 1, @varDataInicial)
END

SELECT * FROM Calendario
DROP TABLE Calendario