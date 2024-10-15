WITH team_results AS (
    SELECT
        team_1 AS team_id,
        CASE
            WHEN team_1_goals > team_2_goals THEN 3
            WHEN team_1_goals = team_2_goals THEN 1
            ELSE 0
            END AS points,
        CASE
            WHEN team_1_goals > team_2_goals THEN 1 ELSE 0
            END AS victories,
        CASE
            WHEN team_1_goals < team_2_goals THEN 1 ELSE 0
            END AS defeats,
        CASE
            WHEN team_1_goals = team_2_goals THEN 1 ELSE 0
            END AS draws
    FROM matches
    UNION ALL
    SELECT
        team_2 AS team_id,
        CASE
            WHEN team_2_goals > team_1_goals THEN 3  -- Victory
            WHEN team_2_goals = team_1_goals THEN 1  -- Draw
            ELSE 0  -- Defeat
            END AS points,
        CASE
            WHEN team_2_goals > team_1_goals THEN 1 ELSE 0
            END AS victories,
        CASE
            WHEN team_2_goals < team_1_goals THEN 1 ELSE 0
            END AS defeats,
        CASE
            WHEN team_2_goals = team_1_goals THEN 1 ELSE 0
            END AS draws
    FROM matches
)
SELECT
    t.name,
    COUNT(r.team_id) AS matches,
    SUM(r.victories) AS victories,
    SUM(r.defeats) AS defeats,
    SUM(r.draws) AS draws,
    SUM(r.points) AS score
FROM
    teams t
        LEFT JOIN
    team_results r ON t.id = r.team_id
GROUP BY
    t.name
ORDER BY
    score DESC, t.name;