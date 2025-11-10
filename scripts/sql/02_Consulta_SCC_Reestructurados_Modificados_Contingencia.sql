
-------------------------------consulto el max cierre que esta en la tabla--------------------


SELECT min(nfeccierre),max(nfeccierre)
FROM [DWH_CC].[HIST].[VHISNovedadModiRees]

--select top 10 * from [DWH_CC].[HIST].[VHISNovedadModiRees]
--where ANUMObligacion = '5470610019139860'

---eliminar esta 33017098548--25032025 porque al validar se evidencio un error de reestructurado y modificado. Al final se dejo en modificado, porque fue con la que quedo en prestamos definitivos

---------------------------creo la tabla revisando cuantos registros hay por obligación


drop table #Base
SELECT NFECCIERRE,acodtiponegocia,count(*) as Obligaciones,ANUMObligacion
into #Base
FROM [DWH_CC].[HIST].[VHISNovedadModiRees]
where NFECAplicacion>='20250901' and NFECAplicacion<='20250930'-----CAMBIAR RANGO DEL MES QUE  ESTAMOS REVISANDO
group by  NFECCIERRE,acodtiponegocia,ANUMObligacion
order by NFECCIERRE



--valida


select*
from #Base



select * from [DWH_CC].[HIST].[VHISNovedadModiRees] where ANUMObligacion ='0191200046238'

------------------------------------- creo nueva base con el corte  para enumerarla--------------------------




drop table #Base2
SELECT *
into #Base2
FROM [DWH_CC].[HIST].[VHISNovedadModiRees]
where NFECAplicacion>='20250901' and NFECAplicacion<='20250930' ----CAMBIAR RANGO DEL MES QUE  ESTAMOS REVISANDO


--valida

select*
from #Base2





--------------------- enumero la tabla de acuerdo al numero de creditos consolidados para identificar cuantas reestructuraciones consolidadas hubo.--------------------



drop table #base3
SELECT dense_rank()over(partition by anumobligacion order by anumcredianter desc) as Posicion,*
into #base3
from #base2


--valida


select*
from #Base3


----------------------------------------traer fecha de aplicacion -------------------------------------



alter table #Base add Fecha_Modificación int


update a
set a.Fecha_Modificación=b.nfecaplicacion
from #Base as a left join
#Base3 as b
on a.anumobligacion=b.anumobligacion




----------------------------consulto el maximo de obligaciones  consolidadas que presentan las obligaciones---------------------------


select max(obligaciones)
from #Base
--- quiere decir que un solo credito unifico hasta X obligaciones


select * from #Base





------------------------------------ conociendo el maximo debo transponer tabla cruce------------------------------------------
--==============repetir cuantas hasta el maximo de numero de consolidadas que hay





alter table #Base add Obligacion3 varchar(200) ---ir cambiando hasta el max obligaciones

go	

update a
set a.Obligacion3 =b.anumcredianter --- ir cambiando el numero hasta el maximo de obligaciones
from #Base as a
left join 
#base3 as b
on a.anumobligacion=b.anumobligacion and a.nfeccierre=b.nfeccierre 
where b.posicion =3 ----ir cambiando el numero hasta el maximo de obligaciones




----validación



select*
from #Base






--==================================HASTA AQUI==================================
--==============================================================================




-----------------------------RESULTADOS---------------------------------------------


--1.--Consolidadas Reestructuradas

select NFECCIERRE,acodtiponegocia,Obligaciones,Fecha_Modificación,ANUMObligacion,
Obligacion1,Obligacion2,Obligacion3-----,Obligacion4 ,obligacion5---,Obligacion6,Obligacion7,Obligacion8,
--Obligacion9,Obligacion10 --- agregar mas si el maximo es mayor
from #Base
where acodtiponegocia='REE' AND Obligaciones>1



--2.--Consolidadas Modificadas 

select NFECCIERRE,acodtiponegocia,Obligaciones,Fecha_Modificación,ANUMObligacion,
Obligacion1,Obligacion2,Obligacion3---, Obligacion4 ,Obligacion5---,Obligacion6,Obligacion7,
--Obligacion8,Obligacion9,Obligacion10---agregar mas si el maximo es mayor
from #Base
where acodtiponegocia='MOD' AND Obligaciones>1




--3.--Reestructurados totales



select NFECCIERRE,acodtiponegocia,Obligaciones,Fecha_Modificación,ANUMObligacion,
Obligacion1,Obligacion2,Obligacion3----, Obligacion4 ,Obligacion5---,Obligacion6,Obligacion7,
--Obligacion8,Obligacion9,Obligacion10 --agregar mas si el maximo es mayor a 6
from #Base
where acodtiponegocia='REE' ----AND Obligaciones=1



--4.--Modificados totales



select NFECCIERRE as Fecha_Corte,
Fecha_Modificación as Fecha_Modificacion,
ANUMObligacion as N_Obligacion,
Obligaciones
--select*
from #Base
where acodtiponegocia='MOD' ----AND Obligaciones=1




--Validacion Daniel: Para saber si las que tienen solo una obligacion la obligacion 2 si es vacía

select NFECCIERRE,acodtiponegocia,Obligaciones,Fecha_Modificación,ANUMObligacion,
Obligacion1,Obligacion2,Obligacion3---, Obligacion4  --,Obligacion5,Obligacion6,Obligacion7 --agregar mas si el maximo es mayor a 6
from #Base
where acodtiponegocia='MOD' AND Obligaciones=1 AND Obligacion2 IS NOT NULL

