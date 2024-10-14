-- link: https://judge.beecrowd.com/en/problems/view/2738

SELECT c.name, ROUND((((s.math*2)+(s.specific*3)+(s.project_plan*5))/10), 2) as avg
FROM candidate AS c INNER JOIN score AS s
ON c.id = s.candidate_id
ORDER BY avg DESC;