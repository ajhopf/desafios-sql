-- link: https://judge.beecrowd.com/en/problems/view/2991

WITH
    descontos AS (
        SELECT ed.matr, SUM(d.valor) AS desconto
        FROM desconto d
                 INNER JOIN emp_desc ed ON d.cod_desc = ed.cod_desc
        GROUP BY ed.matr
    ),
    salario_empregado AS (
        SELECT
            e.nome,
            e.lotacao_div,
            e.matr,
            COALESCE(d.desconto, 0) AS desconto,
            COALESCE(SUM(v.valor), 0) AS salario_sem_desconto,
            COALESCE(SUM(v.valor), 0) - COALESCE(d.desconto, 0) AS salario_com_desconto
        FROM empregado e
                 LEFT JOIN emp_venc ev ON e.matr = ev.matr  -- Keep empregado as the main table
                 LEFT JOIN vencimento v ON ev.cod_venc = v.cod_venc
                 LEFT JOIN descontos d ON e.matr = d.matr
        GROUP BY e.nome, e.lotacao_div, e.matr, d.desconto
    ),
    departamento_divisao AS (
        SELECT
            dep.nome AS departamento,
            div.nome AS divisao,
            div.cod_divisao
        FROM divisao div
                 INNER JOIN departamento dep ON div.cod_dep = dep.cod_dep
    ),
    empregados_com_salarios  AS (
        SELECT DISTINCT
            dv.departamento,
            se.nome,
            se.salario_sem_desconto,
            se.desconto,
            se.salario_com_desconto,
            se.lotacao_div,
            se.matr,
            dv.divisao
        FROM salario_empregado se
                 INNER JOIN departamento_divisao dv ON se.lotacao_div = dv.cod_divisao
    )
SELECT
    departamento AS "Nome Departamento",
    COUNT(es.matr) AS "Numero de Empregados",
    ROUND(AVG(es.salario_com_desconto), 2) AS "Media Salarial",
    MAX(es.salario_com_desconto) AS "Maior Salario",
    MIN(es.salario_com_desconto) AS "Menor Salario"
FROM empregados_com_salarios es
GROUP BY departamento
ORDER BY departamento DESC;
