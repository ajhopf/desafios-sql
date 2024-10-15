--Link: https://judge.beecrowd.com/en/problems/view/2998

--Cria duas tabelas ClientProfits e RankedPaybacks
-- Usar o OVER:
-- PARTITION -> agrega a soma de o.profit para cada id de cliente
-- ORDER BY - ordena pelo mes, dessa forma ele vai somando a cada mes, sem essa clausula
--            apareceria diretamente a soma de todos profits em todas linhas
-- ROW_NUMBER() cria uma contagem de linhas agregadas pelo name -> dessa forma na proxima query
--              será possível utilizar apenas a linha 1, ou seja, o primeiro registro em que
--              o profit é igual ou maior que o investimento

WITH
    ClientProfits AS (
        SELECT
            c.name,
            c.investment,
            o.month,
            o.profit,
            SUM(o.profit) OVER (PARTITION BY c.id ORDER BY o.month) AS cumulative_profit
        FROM
            clients c
                JOIN
            operations o ON c.id = o.client_id
    ),
    RankedPaybacks AS (
        SELECT
            name,
            investment,
            month,
            cumulative_profit - investment as return,
            ROW_NUMBER() OVER (PARTITION BY name ORDER BY month) as rn
        FROM ClientProfits
        WHERE cumulative_profit >= investment
    )
SELECT
    name,
    investment,
    month as month_of_payback,
    return
FROM RankedPaybacks
WHERE rn = 1
ORDER BY name;