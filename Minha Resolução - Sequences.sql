/* 0. Crie o Banco de Dados AlugaFacil, onde serão criadas as sequences e tabelas dos exercícios. */

CREATE DATABASE AlugaFacil
USE AlugaFacil

/* 1. Vamos criar Sequences que serão utilizadas nas tabelas: Carro, Cliente e Locacoes. 
Essas sequences serão chamadas de: cliente_seq, carro_seq e locaçoes_seq. 
Todas essas sequences devem começar pelo número 1, incrementar de 1 em 1 e não terem 
valor máximo. */

CREATE SEQUENCE carro_seq
AS INT
START WITH 1
INCREMENT BY 1
NO MAXVALUE
NO CYCLE

CREATE SEQUENCE cliente_seq
AS INT 
START WITH 1
INCREMENT BY 1
NO MAXVALUE
NO CYCLE

CREATE SEQUENCE locações_seq
AS INT
START WITH 1 
INCREMENT BY 1
NO MAXVALUE
NO CYCLE

/* 2. Utilize as sequences nas 3 tabelas: Carro, Cliente e Locacoes. Você deve excluir as tabelas 
existentes e recriá-las. Lembre-se que não é necessário utilizar a constraint IDENTITY nas 
colunas de chave primária uma vez que nelas serão usadas as Sequences.  */

CREATE TABLE dCliente (
	id_cliente INT,
	nome_cliente VARCHAR(100) NOT NULL,
	cnh VARCHAR(100) NOT NULL,
	cartao INT NOT NULL,
	CONSTRAINT dCliente_id_cliente_pk PRIMARY KEY(id_cliente),
	CONSTRAINT dCliente_cnh_un UNIQUE(cnh)
)

CREATE TABLE dCarro (
	id_carro INT,
	placa VARCHAR(100) NOT NULL,
	modelo VARCHAR(100) NOT NULL,
	tipo VARCHAR(100) NOT NULL,
	CONSTRAINT dCarro_id_carro_pk PRIMARY KEY (id_carro),
	CONSTRAINT dCarro_placa_un UNIQUE(placa),
	CONSTRAINT dCarro_tipo_ck CHECK (tipo in ('Hatch', 'Sedan', 'SUV'))
)

CREATE TABLE fLocacoes (
	id_locacao INT,
	data_locacao DATE NOT NULL,
	data_devolucao DATE NOT NULL,
	id_carro INT NOT NULL,
	id_cliente INT NOT NULL,
	CONSTRAINT fLocacoes_id_locacao_pk PRIMARY KEY(id_locacao),
	CONSTRAINT fLocacoes_id_carro_fk FOREIGN KEY (id_carro) REFERENCES dCarro(id_carro),
	CONSTRAINT fLocacoes_id_cliente_fk FOREIGN KEY (id_cliente) REFERENCES dCliente(id_cliente)
)

INSERT INTO dCliente(id_cliente, nome_cliente, cnh, cartao) VALUES
	(NEXT VALUE FOR cliente_seq, 'Wendel', 'WSM-123', 123456),
	(NEXT VALUE FOR cliente_seq, 'Mirna', 'MGB-123', 135791)

INSERT INTO dCarro(id_carro, placa, modelo, tipo) VALUES
	(NEXT VALUE FOR carro_seq, 'ABC777', 'Mitsubishi Ecplide Cross', 'SUV'),
	(NEXT VALUE FOR carro_seq, 'XYZ123', 'Nivus', 'SUV')

INSERT INTO fLocacoes(id_locacao, data_locacao, data_devolucao, id_carro, id_cliente) VALUES
    (NEXT VALUE FOR locações_seq, '2028-05-18', '2032-03-19', 1, 1),
    (NEXT VALUE FOR locações_seq, '2030-09-02', '2031-12-15', 2, 2)

SELECT * FROM dCliente
SELECT * FROM dCarro
SELECT * FROM fLocacoes

/* 3. Exclua as sequences criadas. */

DROP SEQUENCE carro_seq
DROP SEQUENCE cliente_seq
DROP SEQUENCE locações_seq