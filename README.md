# 📈 Gestão de Banca de Apostas com SQL

Este projeto foi desenvolvido para automatizar o controle financeiro de apostas esportivas, utilizando conceitos avançados de banco de dados para garantir integridade e agilidade nos cálculos.

## 🛠️ Tecnologias Utilizadas
- **PostgreSQL**: Banco de dados relacional.
- **pgAdmin 4**: Interface de gestão.
- **PL/pgSQL**: Linguagem procedural para automação.

## 💡 Destaques do Projeto
- **Triggers e Functions**: Implementação de gatilhos que calculam o lucro líquido automaticamente com base no resultado (Green/Red) e nas Odds, eliminando erros manuais.
- **Relacionamentos (Joins)**: Estrutura normalizada ligando apostas, esportes e mercados.
- **Análise de Dados**: Queries prontas para cálculo de ROI (Retorno sobre Investimento) e volume de apostas por modalidade.

## 🚀 Como usar
1. Execute o script `script_banca.sql` no seu ambiente PostgreSQL.
2. Insira suas apostas na tabela `Apostas` sem precisar calcular o lucro manual.
3. Utilize a query de relatório para acompanhar sua performance.
