----------VERIFICACIONES DATOS----------------------
----------------Reestructurados--------------------------------

select count (*) from [ANDREAL].[Costo_Amortizado_001_Reestructurados_Acum] where Fecha_Corte ='20250930'
select count(*) from [ANDREAL].[Costo_Amortizado_001_Modificados_Acum]		where Fecha_Corte ='20250930'
select count(*) from [ANDREAL].[Costo_Amortizado_001_Retenciones_Acum] 		where Fecha_Corte ='20250930'


select Fecha_Corte,count(Obligacion_Nueva)
from ANDREAL.Costo_Amortizado_001_Reestructurados_Acum
where Fecha_Corte>='20180131'
group by Fecha_Corte
ORDER BY Fecha_Corte DESC

select*
from ANDREAL.Costo_Amortizado_001_Reestructurados_Acum
where Fecha_Corte='20250930' ---cambio corte que estoy revisando

/*UPDATE ANDREAL.Costo_Amortizado_001_Reestructurados_Acum
SET Fecha_Corte='20240531'
WHERE Fecha_Corte IN ('20240505')*/


----------------Retenciones----------------------------------


select Fecha_Corte,count(Obligacion_Nueva)
from ANDREAL.Costo_Amortizado_001_Retenciones_Acum	  
where Fecha_Corte>='20180131' 
group by Fecha_Corte
ORDER BY Fecha_Corte DESC

select*
from ANDREAL.Costo_Amortizado_001_Retenciones_Acum
where Fecha_Corte ='20250930' ---cambio corte que estoy revisando



-----------------------------------0011 verificacion----------

select count(*) from [ANDREAL].[Costo_Amortizado_0011_Retenciones_Acum]		where Fecha_Corte ='20250930'
select count(*) from [ANDREAL].[Costo_Amortizado_0011_Modificados_Acum]  	where Fecha_Corte ='20250930'


select Fecha_Corte,count(N_Obligacion)
from ANDREAL.Costo_Amortizado_0011_Retenciones_Acum 
where Fecha_Corte>='20180131' 
group by Fecha_Corte
ORDER BY Fecha_Corte DESC

select*
from ANDREAL.Costo_Amortizado_0011_Retenciones_Acum
where Fecha_Corte='20250930' ---cambio corte que estoy revisando

/*UPDATE ANDREAL.Costo_Amortizado_0011_Retenciones_Acum
SET Fecha_Corte='20240531'
WHERE Fecha_Corte IN ('20240510',
'20240509',
'20240508',
'20240507',
'20240506')*/

SELECT * FROM ANDREAL.Costo_Amortizado_0011_Retenciones_Acum WHERE Fecha_Corte IS NULL

-----------------Modificados-----------------------------------



select Fecha_Corte,count(Obligacion_Nueva)
from ANDREAL.Costo_Amortizado_001_Modificados_Acum
where Fecha_Corte>='20180131' 
group by Fecha_Corte
ORDER BY Fecha_Corte DESC


select*
from ANDREAL.Costo_Amortizado_001_Modificados_Acum
where Fecha_Corte='20250930' ---cambio corte que estoy revisando

SELECT * FROM ANDREAL.Costo_Amortizado_001_Modificados_Acum WHERE Fecha_Corte IS NULL

-----------------------------------0011 modificadas----------


select Fecha_Corte,count(N_Obligacion)
FROM ANDREAL.Costo_Amortizado_0011_Modificados_Acum
where Fecha_Corte>='20180131' 
group by Fecha_Corte
ORDER BY Fecha_Corte DESC

select*
from ANDREAL.Costo_Amortizado_0011_Modificados_Acum
where Fecha_Corte='20250930' ---cambio corte que estoy revisando


SELECT * FROM ANDREAL.Costo_Amortizado_0011_Modificados_Acum WHERE Fecha_Corte IS NULL

--update ANDREAL.Costo_Amortizado_0011_Modificados_Acum
--set Fecha_Corte='20240930'
--where Fecha_Corte IN ('20240910')*/





-----------------COMPLETITUD DE LAS VARIABLES----------------------
------------------Cruzar modalidad para todos---------------------


-------reestructurados


update a
set a.Modalidad=b.ACODModalSuper,a.Tipo_Id=b.ACODIdenPerso,a.Numero_Id=b.ANUMIdenPerso
from ANDREAL.Costo_Amortizado_001_Reestructurados_Acum as a left join
dwh.dbo.CA_PRESTAMOS_PRELIMINAR as b
on a.Obligacion_Nueva=b.ANUMObligacion 
WHERE a.Fecha_Corte='20250930' and b.NFECCierre='20250930'------cambiar fecha


select*
from ANDREAL.Costo_Amortizado_001_Reestructurados_Acum
WHERE Fecha_Corte='20250930' -- cambio corte que estoy revisando



-----------------------


------retenciones


update a
set a.Modalidad=b.ACODModalSuper,a.Tipo_Id=b.ACODIdenPerso,a.Numero_Id=b.ANUMIdenPerso
from ANDREAL.Costo_Amortizado_001_Retenciones_Acum as a left join
dwh.dbo.CA_PRESTAMOS_PRELIMINAR as b
on a.Obligacion_Nueva=b.ANUMObligacion
WHERE a.Fecha_Corte='20250930' and b.NFECCierre='20250930'------cambiar fecha

select*
from ANDREAL.Costo_Amortizado_001_Retenciones_Acum 
WHERE Fecha_Corte='20250930' -- cambio corte que estoy revisando

select * from dwh.dbo.CA_PRESTAMOS_PRELIMINAR WHERE NFECCierre='20180131' 
---------------


-----modificados


update a
set a.Modalidad=b.ACODModalSuper,a.Tipo_Id=b.ACODIdenPerso,a.Numero_Id=b.ANUMIdenPerso
from ANDREAL.Costo_Amortizado_001_Modificados_Acum as a left join
dwh.dbo.CA_PRESTAMOS_PRELIMINAR as b
on a.Obligacion_Nueva=b.ANUMObligacion
WHERE a.Fecha_Corte='20250930' and b.NFECCierre='20250930'------cambiar fecha

select*
from ANDREAL.Costo_Amortizado_001_Modificados_Acum
WHERE Fecha_Corte='20250930' -- cambio corte que estoy revisando

