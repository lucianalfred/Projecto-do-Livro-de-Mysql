-- Criar a base de dados
CREATE DATABASE residuos;
USE residuos;

-- Criar a tabela de cargas
CREATE TABLE carga (
    id INT AUTO_INCREMENT PRIMARY KEY,
    data DATE NOT NULL,
    hora TIME NOT NULL,
    matricula VARCHAR(20) NOT NULL,
    quantidade INT NOT NULL,
    material VARCHAR(50) NOT NULL
);

-- Criar a tabela de destino
CREATE TABLE destino (
    id INT AUTO_INCREMENT PRIMARY KEY,
    material VARCHAR(50) NOT NULL,
    estacao INT NOT NULL
);

-- Responder às questões
-- a) Datas e horas de transportes de papel
SELECT data, hora FROM carga WHERE material = 'papel';

-- b) Tipos de material transportados
SELECT DISTINCT material FROM carga
UNION
SELECT DISTINCT material FROM destino;

-- c) Materiais transportados pelo camião “37-XT-21”
SELECT DISTINCT material FROM carga WHERE matricula = '37-XT-21';

-- d) Matrículas dos camiões que transportaram material para a estação 3
SELECT DISTINCT c.matricula FROM carga c
JOIN destino d ON c.material = d.material
WHERE d.estacao = 3;

-- e) Estações que receberam material depois de 1 de Janeiro de 2007
SELECT DISTINCT d.estacao FROM carga c
JOIN destino d ON c.material = d.material
WHERE c.data > '2007-01-01';

-- f) Camião que transportou mais peso numa viagem
SELECT matricula FROM carga ORDER BY quantidade DESC LIMIT 1;

-- g) Estação para onde o camião que transportou mais peso levou o material
SELECT d.estacao FROM carga c
JOIN destino d ON c.material = d.material
ORDER BY c.quantidade DESC LIMIT 1;

-- h) Camiões que transportaram materiais somente para a estação 2
SELECT matricula FROM carga c
JOIN destino d ON c.material = d.material
GROUP BY c.matricula HAVING COUNT(DISTINCT d.estacao) = 1 AND MAX(d.estacao) = 2;

-- i) Estações que recebem apenas um tipo de material
SELECT estacao FROM destino GROUP BY estacao HAVING COUNT(DISTINCT material) = 1;

-- j) Camiões que transportaram todos os materiais recebidos pela estação 4
SELECT c.matricula FROM carga c
WHERE NOT EXISTS (
    SELECT material FROM destino WHERE estacao = 4
    EXCEPT
    SELECT material FROM carga WHERE carga.matricula = c.matricula
);

-- k) Quantidade total transportada por cada camião no dia 25 de Março de 1996
SELECT matricula, SUM(quantidade) AS total FROM carga WHERE data = '1996-03-25' GROUP BY matricula;

-- l) Estação que recebeu mais quilos de material
SELECT d.estacao, SUM(c.quantidade) AS total FROM carga c
JOIN destino d ON c.material = d.material
GROUP BY d.estacao ORDER BY total DESC LIMIT 1;

-- m) Camiões que sempre transportam o mesmo material
SELECT matricula FROM carga GROUP BY matricula HAVING COUNT(DISTINCT material) = 1;

-- n) Pares de camiões com diferença de peso inferior a 100Kg
SELECT c1.matricula AS caminhao1, c2.matricula AS caminhao2 FROM carga c1
JOIN carga c2 ON c1.id < c2.id AND ABS(c1.quantidade - c2.quantidade) < 100;
