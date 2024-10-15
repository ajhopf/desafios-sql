--link:https://judge.beecrowd.com/en/problems/view/2995

select temperature, count(mark) as number_of_records
from records
group by temperature, mark
order by mark;