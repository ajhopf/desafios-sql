--link: https://judge.beecrowd.com/en/problems/view/2997

WITH descontos AS (
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
             COALESCE(SUM(v.valor), 0) AS salario_sem_desconto,
             COALESCE(d.desconto, 0) AS desconto,
             COALESCE(SUM(v.valor), 0) - COALESCE(d.desconto, 0) AS salario_com_desconto
         FROM empregado e
                  LEFT JOIN emp_venc ev ON e.matr = ev.matr
                  LEFT JOIN vencimento v ON ev.cod_venc = v.cod_venc
                  LEFT JOIN descontos d ON e.matr = d.matr
         GROUP BY e.nome, e.lotacao_div, e.matr, d.desconto
     ),
     departamento_divisao AS (
         SELECT dep.nome AS departamento, div.nome AS divisao, div.cod_divisao
         FROM divisao div
                  INNER JOIN departamento dep ON div.cod_dep = dep.cod_dep
     ),
     empregados_com_salarios AS (
         SELECT
             dv.departamento, se.nome, se.salario_sem_desconto,
             se.desconto, se.salario_com_desconto, se.matr
         FROM salario_empregado se
                  INNER JOIN departamento_divisao dv ON se.lotacao_div = dv.cod_divisao
     )
SELECT
    departamento AS "Departamento",
    nome AS "Empregado",
    salario_sem_desconto AS "Salario Bruto",
    desconto AS "Total Desconto",
    salario_com_desconto AS "Salario Liquido"
FROM empregados_com_salarios
ORDER BY salario_com_desconto DESC;

