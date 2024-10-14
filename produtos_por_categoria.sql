--Link : https://judge.beecrowd.com/en/problems/view/2609

SELECT c.name, SUM(p.amount) as sum
FROM products AS p INNER JOIN categories AS c
ON p.id_categories = c.id
GROUP BY c.name;