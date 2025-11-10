
-------------------------------consulto el max cierre que esta en la tabla--------------------


SELECT min(fecha),max(fecha)
FROM dwh.dbo.CA_DetalleFormato536



---------------------------creo la tabla revisando cuantos registros hay por obligación------------------------------



drop table #inicio
SELECT 
Fecha,
RIGHT(C18_AFECAplicacion,4)+ SUBSTRING(C18_AFECAplicacion,3,2) + LEFT(C18_AFECAplicacion,2) as 'Fecha_Aplicacion', 
Case When Unidad_Captura = '01' Then 'MOD'
            When Unidad_Captura = '02' Then 'REE'
            else 'Error' end as acodtiponegocia,
Obligacion
into #inicio
FROM dwh.dbo.CA_DetalleFormato536
where Fecha='20190731' and ---- cambiar fecha
RIGHT(C18_AFECAplicacion,4)+ SUBSTRING(C18_AFECAplicacion,3,2) + LEFT(C18_AFECAplicacion,2)>='20190701' and--cambiar rango fecha
RIGHT(C18_AFECAplicacion,4)+ SUBSTRING(C18_AFECAplicacion,3,2) + LEFT(C18_AFECAplicacion,2)<='20190731'--cambiar rango fecha

select * from #inicio

--valida


select*
from #inicio


------------------ creo nueva tabla agrupando por obligación cuantos registros se tienen----------------------


drop table #Base
SELECT 
Fecha,
acodtiponegocia,
COUNT(*) as Obligaciones,
Obligacion
into #Base
FROM #inicio
group by  Fecha,acodtiponegocia,Obligacion
order by Fecha



--valida


select*
from #Base


------------------------------------- creo nueva base  para enumerarla------------------------------



drop table #Base2
SELECT *
into #Base2
FROM dwh.dbo.CA_DetalleFormato536
where Fecha='20190731' and  --canbiar fecha
RIGHT(C18_AFECAplicacion,4)+ SUBSTRING(C18_AFECAplicacion,3,2) + LEFT(C18_AFECAplicacion,2)>='20190701' and ---cambiar rango de fecha
RIGHT(C18_AFECAplicacion,4)+ SUBSTRING(C18_AFECAplicacion,3,2) + LEFT(C18_AFECAplicacion,2)<='20190731'  ---cambiar rango de fecha



----valida


select*
from #Base2





----enumero la tabla de acuerdo al numero de creditos consolidados para identificar cuantas reestructuraciones consolidadas hubo






drop table #base3
SELECT dense_rank()over(partition by obligacion order by credito_Anterior desc) as Posicion,*
into #base3
from #base2



select*
from #Base3



----------------------------------------traer fecha de aplicacion -------------------------------------




alter table #Base add Fecha_Modificación int

update a
set a.Fecha_Modificación=b.Fecha_Aplicacion
from #Base as a left join
#inicio as b
on a.obligacion=b.obligacion




----------------------------consulto el maximo de obligaciones  consolidadas que presentan las obligaciones---------------------------




select max(obligaciones)
from #Base





------------------------------------ conociendo el maximo debo transponer tabla cruce------------------------------------------
==============repetir cuantas hasta el maximo de numero de consolidadas que hay






alter table #Base add Obligacion1 varchar(200)---ir cambiando hasta el max obligaciones



update a
set a.Obligacion1=b.Credito_Anterior--- ir cambiando el numero hasta el maximo de obligaciones
from #Base as a
left join 
#base3 as b
on a.obligacion=b.obligacion and a.Fecha=b.Fecha 
where b.posicion=1 ----ir cambiando el numero hasta el maximo de obligaciones




----validación



select*
from #Base




==================================HASTA AQUI==================================
==============================================================================




-----------------------------RESULTADOS---------------------------------------------


1.--Consolidadas Reestructuradas

select Fecha,acodtiponegocia,Obligaciones,Fecha_Modificación,Obligacion,
Obligacion1--,Obligacion2,Obligacion3,Obligacion4,Obligacion5--- agregar mas si el maximo es mayor a 6
from #Base
where acodtiponegocia='REE' AND Obligaciones>1




2.--Consolidadas Modificadas 

select Fecha,acodtiponegocia,Obligaciones,Fecha_Modificación,Obligacion,
Obligacion1--,Obligacion2,Obligacion3,Obligacion4,Obligacion5---agregar mas si el maximo es mayor a 6
from #Base
where acodtiponegocia='MOD' AND Obligaciones>1





3.--Reestructurados totales

select Fecha,acodtiponegocia,Obligaciones,Fecha_Modificación,Obligacion,
Obligacion1---,Obligacion2,Obligacion3,Obligacion4,Obligacion5--agregar mas si el maximo es mayor a 6
from #Base
where acodtiponegocia='REE' ---AND Obligaciones=1



4.--Modificados totales

select Fecha as Fecha_Corte,
Fecha_Modificación as Fecha_Modificacion,
Obligacion as N_Obligacion,
Obligaciones
---select*
from #Base
where acodtiponegocia='MOD' ----AND Obligaciones=1



