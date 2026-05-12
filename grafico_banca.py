import psycopg2
import pandas as pd
import matplotlib.pyplot as plt
import os
from dotenv import load_dotenv

load_dotenv()

try:
    conexao = psycopg2.connect(
        host="localhost",
        database="gestao_banca",
        user="postgres",
        password=os.getenv("DB_PASSWORD")
    )

    query = """
    SELECT 
        data_aposta, 
        SUM(lucro_perda) OVER (ORDER BY id_aposta) as saldo_acumulado
    FROM Apostas;
    """

    # 3. Carregar os dados para um DataFrame do Pandas
    df = pd.read_sql_query(query, conexao)

    # 4. Criar o gráfico
    plt.figure(figsize=(10, 6))
    plt.plot(df['data_aposta'], df['saldo_acumulado'], marker='o', linestyle='-', color='b')
    
    # Customização do gráfico
    plt.title('Evolução Financeira da Banca')
    plt.xlabel('Data das Apostas')
    plt.ylabel('Saldo Acumulado (R$)')
    plt.grid(True, linestyle='--', alpha=0.7)
    
    # Mostrar o gráfico na tela
    print("Gerando gráfico...")
    plt.show()

except Exception as e:
    print(f"Erro ao conectar ou gerar gráfico: {e}")

finally:
    if 'conexao' in locals():
        conexao.close()