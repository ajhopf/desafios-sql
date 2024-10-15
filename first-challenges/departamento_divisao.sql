--link: https://judge.beecrowd.com/en/problems/view/2989

with salario_empregado as (
    with descontos as (select ed.matr, sum(d.valor) as desconto
                       from desconto d
                                inner join emp_desc ed
                                           on d.cod_desc = ed.cod_desc
                       group by ed.matr
    )
    select e.nome, e.lotacao_div, ev.matr, COALESCE(sum(v.valor),0) - COALESCE(d.desconto, 0) as salario
    from emp_venc ev
             full join vencimento v
                       on ev.cod_venc = v.cod_venc
             full join empregado e
                       on ev.matr = e.matr
             left join descontos d
                       on ev.matr = d.matr
    group by ev.matr, d.desconto, e.nome, e.lotacao_div
)
select dep.nome as departamento, div.nome as divisao, round(avg(salario_empregado.salario),2) as media, max(salario_empregado.salario) as maior
from salario_empregado
         inner join divisao div
                    on salario_empregado.lotacao_div = div.cod_divisao
         inner join departamento dep
                    on div.cod_dep = dep.cod_dep
group by divisao, departamento
order by media desc;