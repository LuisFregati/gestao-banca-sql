-- ==========================================
-- PROJETO: GESTÃO DE BANCA DE APOSTAS
-- OBJETIVO: Automação de cálculos e análise de ROI
-- AUTOR: Luis Felipe Fregati
-- ==========================================

-- [1] Criação das Tabelas
CREATE TABLE Esportes (
    id_esporte SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL
);

CREATE TABLE Mercados (
    id_mercado SERIAL PRIMARY KEY,
    nome_mercado VARCHAR(100) NOT NULL
);

CREATE TABLE Apostas (
    id_aposta SERIAL PRIMARY KEY,
    data_aposta DATE DEFAULT CURRENT_DATE,
    id_esporte INT REFERENCES Esportes(id_esporte),
    id_mercado INT REFERENCES Mercados(id_mercado),
    valor_apostado DECIMAL(10, 2) NOT NULL,
    odd DECIMAL(5, 2) NOT NULL,
    resultado VARCHAR(10) CHECK (resultado IN ('Green', 'Red', 'Devolvida', 'Pendente')),
    lucro_perda DECIMAL(10, 2)
);

-- [2] Dados Iniciais
INSERT INTO Esportes (nome) VALUES ('Futebol'), ('Basquete');
INSERT INTO Mercados (nome_mercado) VALUES ('Vencedor (1X2)'), ('Over 2.5 Gols'), ('Handicap');

-- [3] Automação (Cálculo Automático de Lucro/Perda)
CREATE OR REPLACE FUNCTION calcular_lucro_perda()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.resultado = 'Green' THEN
        NEW.lucro_perda := (NEW.valor_apostado * NEW.odd) - NEW.valor_apostado;
    ELSIF NEW.resultado = 'Red' THEN
        NEW.lucro_perda := -NEW.valor_apostado;
    ELSE
        NEW.lucro_perda := 0;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_calcular_lucro_perda
BEFORE INSERT OR UPDATE ON Apostas
FOR EACH ROW
EXECUTE FUNCTION calcular_lucro_perda();

-- [4] Query de Relatório de Performance (ROI)
SELECT 
    e.nome AS esporte,
    COUNT(a.id_aposta) AS total_apostas,
    SUM(a.valor_apostado) AS total_investido,
    SUM(a.lucro_perda) AS lucro_liquido,
    ROUND((SUM(a.lucro_perda) / NULLIF(SUM(a.valor_apostado), 0)) * 100, 2) || '%' AS roi
FROM Apostas a
JOIN Esportes e ON a.id_esporte = e.id_esporte
GROUP BY e.nome
ORDER BY lucro_liquido DESC;