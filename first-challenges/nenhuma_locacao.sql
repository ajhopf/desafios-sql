--Link desafio: https://judge.beecrowd.com/en/problems/view/2616

SELECT c.id, c.name
FROM customers AS c
LEFT JOIN locations AS l
ON c.id = l.id_customers
WHERE l.id_customers IS NULL;