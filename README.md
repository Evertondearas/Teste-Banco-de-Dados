# Teste Banco de Dados 

Este projeto cria e alimenta tabelas com dados públicos da ANS para análise de despesas das operadoras de saúde.

## O que o script faz

- Cria tabelas para dados financeiros e cadastrais
- Importa arquivos CSV dos últimos dois anos
- Converte e limpa os dados
- Calcula despesas por operadora
- Executa duas consultas analíticas:
  - Top 10 operadoras com maiores despesas no último trimestre
  - Top 10 operadoras com maiores despesas no último ano

<img width="671" height="367" alt="Captura de tela 2025-10-29 135700" src="https://github.com/user-attachments/assets/8b781227-078c-4965-b716-6d74bc0bca74" />

<img width="673" height="367" alt="Captura de tela 2025-10-29 135803" src="https://github.com/user-attachments/assets/efed5e28-19a5-4cb9-ad13-f2a456a7b500" />



## Requisitos

- PostgreSQL 10 ou superior
- Arquivos CSV da ANS salvos localmente
- Encoding: UTF-8

