-- Dei aquela pescadinha na exmplicação do conteúdo de lei, se não fica difícil kkkkkkkkkkk. 

/* 1. Você está responsável por criar um Banco de Dados com algumas tabelas que vão armazenar 
informações associadas ao aluguel de carros de uma locadora.  
a) O primeiro passo é criar um banco de dados chamado AlugaFacil. 
b) O seu banco de dados deve conter 3 tabelas e a descrição de cada uma delas é mostrada 
abaixo: 
Obs: você identificará as restrições das tabelas a partir de suas descrições. */

CREATE DATABASE AlugaFacil
USE AlugaFacil

/* Tabela 1: Cliente - id_cliente - nome_cliente - cnh - cartao 
A tabela Cliente possui 4 colunas.  
A coluna id_cliente deve ser a chave primária da tabela, além de ser autoincrementada de forma 
automática. 
As colunas nome_cliente, cnh e cartao não podem aceitar valores nulos, ou seja, para todo 
cliente estes campos devem necessariamente ser preenchidos. 
Por fim, a coluna cnh não pode aceitar valores duplicados. */

CREATE TABLE dCliente (
	dCliente_id_cliente INT IDENTITY(1, 1),
	dCliente_nome_cliente VARCHAR(100) NOT NULL,
	dCliente_cnh INT NOT NULL,
	dCliente_cartao INT NOT NULL,
	CONSTRAINT dCliente_id_cliente_pk PRIMARY KEY(dCliente_id_cliente),
	CONSTRAINT dCliente_cnh_un UNIQUE(dCliente_cnh)
)
SELECT * FROM dCliente

/* Tabela 2: Carro - id_carro - placa - modelo - tipo 
A tabela Carro possui 3 colunas. 
A coluna id_carro deve ser a chave primária da tabela, além de ser autoincrementada de forma 
automática. 
As colunas modelo, tipo e placa não podem aceitar valores nulos. 
Os tipos de carros cadastrados devem ser: Hatch, Sedan, SUV. 
Por fim, a coluna placa não pode aceitar valores duplicados. */

CREATE TABLE dCarro (
	dCarro_id_carro INT IDENTITY(1, 1),
	dCarro_placa VARCHAR(100) NOT NULL,
	dCarro_modelo VARCHAR(100) NOT NULL, 
	dCarro_tipo VARCHAR(100) NOT NULL,
	CONSTRAINT dCarro_id_carro_ PRIMARY KEY(dCarro_id_carro),
	CONSTRAINT dCarro_tipo_ck CHECK (dCarro_tipo IN ('Hatch', 'Sedan', 'SUV')),
	CONSTRAINT dCarro_placa_un UNIQUE(dCarro_placa)
)

/* Tabela 3: Locacoes - id_locacao - data_locacao - data_devolucao - id_carro - id_cliente 
A tabela Locacoes possui 5 colunas. 
A coluna id_locacao deve ser a chave primária da tabela, além de ser autoincrementada de 
forma automática. 
Nenhuma das demais colunas devem aceitar valores nulos. 
As colunas id_carro e id_cliente são chaves estrangeiras que permitirão a relação da tabela 
Locacoes com as tabelas Carro e Cliente. */

CREATE TABLE fLocacoes (
	f_id_locacao INT IDENTITY(1, 1),
	f_data_locacao DATE NOT NULL,
	f_data_devolucao DATE NOT NULL,
	f_id_carro INT NOT NULL,
	f_id_cliente INT NOT NULL
	CONSTRAINT f_id_locacao_pk PRIMARY KEY(f_id_locacao),
	CONSTRAINT f_id_carro_fk FOREIGN KEY(f_id_carro) REFERENCES dCarro(dCarro_id_carro),
	CONSTRAINT f_id_cliente_fk FOREIGN KEY(f_id_cliente) REFERENCES dCliente(dCliente_id_cliente)
)

INSERT INTO dCliente (dCliente_nome_cliente, dCliente_cnh, dCliente_cartao) 
	VALUES 
		('Wendel', 123456, 123456),
		('Mirna', 654321, 654321),
		('Diego', 111222, 111222)

INSERT INTO dCarro (dCarro_placa, dCarro_modelo, dCarro_tipo) 
	VALUES 
		('Ford Shelby GT 500', 'Sedan', 'Sedan'),
		('Mazda RXT', 'Seda', 'Sedan'),
		('Porche Caiene', 'SUV', 'SUV')

INSERT INTO fLocacoes (f_data_locacao, f_data_devolucao, f_id_carro, f_id_cliente) 
	VALUES 
		('2029/10/04', '2033/11/03', 3, 1),
		('2029/04/07', '2031/07/08', 4, 2),
		('2029/11/29', '2031/04/16', 5, 3)

SELECT * FROM dCliente
SELECT * FROM dCarro
SELECT * FROM fLocacoes

/* 2.  Tente violar as constraints criadas para cada tabela. Este exercício é livre. 
Obs: Para fazer o exercício de violação de constraints basta utilizar o comando INSERT INTO para 
adicionar valores nas tabelas que não respeitem as restrições (constraints) estabelecidas na 
criação das tabelas. Ao final, exclua o banco de dados criado. */

INSERT INTO dCarro (dCarro_placa, dCarro_modelo, dCarro_tipo) 
	VALUES 
		('Lamborguini Gallardo', 'Esportivo', 'Esportivo')

DROP DATABASE AlugaFacil