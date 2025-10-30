-- criando tabela de dados financeiros das operadoras
create table dados_financeiros (
	id serial primary key,
    data_ref date,
    reg_ans int not null,
    cd_conta_contabil varchar(30),
    descricao varchar(250),
    vl_saldo_inicial numeric,
    vl_saldo_final numeric
);
-- criando tabela auxiliar para formatar dados antes de passar para tabela de dados financeiros
create table auxiliar (
	data_ref date,
    reg_ans int not null,
    cd_conta_contabil varchar(30),
    descricao varchar(250),
    vl_saldo_inicial varchar(30),
    vl_saldo_final varchar(30)
);
-- criando tabela de dados cadastrais das operadoras
create table dados_cadastrais (
	registro_ans int primary key,
    cnpj varchar(15),
    razao_social varchar(300),
    nome_fantasia varchar(200),
    modalidade varchar(50),
    logradouro varchar(200),
    numero varchar(50),
    complemento varchar(200),
    bairro varchar(100),
    cidade varchar(50),
    uf varchar(5),
    cep varchar(10),
    ddd varchar(5),
    telefone varchar(50),
    fax varchar(15),
    endereco_eletronico varchar(100),
    representante varchar(180),
    cargo_representante varchar(100),
    regiao_de_comercializacao varchar(5),
    data_registro_ans date
);

-- importando dados do csv para tabela de dados cadastrais da operadora
Copy dados_cadastrais FROM 'C:\Relatorio_cadop.csv' DELIMITER ';' CSV HEADER ENCODING 'UTF-8';

-- copiando dados das tabelas de dados financeiros para tabela auxiliar
COPY auxiliar(data_ref, reg_ans, cd_conta_contabil, descricao, vl_saldo_inicial, vl_saldo_final) FROM 'C:\1T2024.csv' DELIMITER ';' CSV HEADER ENCODING 'UTF-8';
COPY auxiliar(data_ref, reg_ans, cd_conta_contabil, descricao, vl_saldo_inicial, vl_saldo_final) FROM 'C:\2T2024.csv' DELIMITER ';' CSV HEADER ENCODING 'UTF-8';
COPY auxiliar(data_ref, reg_ans, cd_conta_contabil, descricao, vl_saldo_inicial, vl_saldo_final) FROM 'C:\3T2024.csv' DELIMITER ';' CSV HEADER ENCODING 'UTF-8';
COPY auxiliar(data_ref, reg_ans, cd_conta_contabil, descricao, vl_saldo_inicial, vl_saldo_final) FROM 'C:\4T2024.csv' DELIMITER ';' CSV HEADER ENCODING 'UTF-8';
COPY auxiliar(data_ref, reg_ans, cd_conta_contabil, descricao, vl_saldo_inicial, vl_saldo_final) FROM 'C:\1T2025.csv' DELIMITER ';' CSV HEADER ENCODING 'UTF-8';
COPY auxiliar(data_ref, reg_ans, cd_conta_contabil, descricao, vl_saldo_inicial, vl_saldo_final) FROM 'C:\2T2025.csv' DELIMITER ';' CSV HEADER ENCODING 'UTF-8';

-- Subistituindo vírgulas por pontos.
update auxiliar set vl_saldo_inicial = replace(vl_saldo_inicial, ',', '.');
update auxiliar set vl_saldo_final = replace(vl_saldo_final, ',', '.');

-- inserindo dados da tabela auxilar na tabela de dados cadastrais após formatar.
insert into dados_financeiros (data_ref, reg_ans, cd_conta_contabil, descricao, vl_saldo_inicial, vl_saldo_final) 
select data_ref, reg_ans, cd_conta_contabil, descricao, cast(vl_saldo_inicial as numeric), cast(vl_saldo_final as numeric) 
from auxiliar;

-- criando coluna "despesas" na tabela de dados financeiros
alter table dados_financeiros
add column despesas numeric;

-- preenchendo os dados da coluna "despesas"
update dados_financeiros
set despesas = vl_saldo_final - vl_saldo_inicial;

-- Query para trazer as empresas que atenda aos requisítos do últmo trimestre que se tem registro

select dc.razao_social, sum(df.despesas)
from dados_cadastrais as dc
inner join dados_financeiros as df on dc.registro_ans = df.reg_ans
where df.descricao = 'EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR '
and df.data_ref between '2025-04-01' and '2025-06-30'
group by dc.razao_social
order by sum(df.despesas) desc
limit 10;

-- Query para trazer as empresas que atenda aos requisítos do últmo ano 
select dc.razao_social, sum(df.despesas)
from dados_cadastrais as dc
inner join dados_financeiros as df on dc.registro_ans = df.reg_ans
where df.descricao = 'EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR '
and df.data_ref between '2024-01-01' and '2024-12-31'
group by dc.razao_social
order by sum(df.despesas) desc
limit 10;
