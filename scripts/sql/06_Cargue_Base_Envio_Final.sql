

--------------------------Paso 1: Se borra la información de la base actual

	Delete PORTAFOLIO.dbo.Costo_Amortizado

	Select * from PORTAFOLIO.dbo.Costo_Amortizado 

  

----------------------------OJO Valide el valor de las sumas para los campos Amortizacion_Mes y Valor_por_Amortizar 
----------------------------Revise que la plantilla de Excel no este dejando saldos en formato texto; esto antes de importar.

select sum (Valor_por_Amortizar) Valor_por_Amortizar,  sum (Amortizacion_Mes) Amortizacion_Mes from PORTAFOLIO.dbo.Costo_Amortizado
Select sum (Valor_por_Amortizar) Valor_por_Amortizar,  sum (Amortizacion_Mes) Amortizacion_Mes from PORTAFOLIO.dbo.Costo_Amortizado_Hist WHERE Fecha_Cierre = '20250729'


-----------------------------Paso 2: Después de cargar la información del último cierre en la base actual, se inserta en la  base histórica

	Insert Into PORTAFOLIO.dbo.Costo_Amortizado_Hist
	Select *
	From PORTAFOLIO.dbo.Costo_Amortizado
	-----WHERE Num_Obligacion_Nuevo='0133201218390'
	
---------------------------------------------03 -Se calida la base 

SELECT FECHA_CIERRE, COUNT(NUM_OBLIGACION_NUEVO) AS CUENTAS
FROM PORTAFOLIO.dbo.Costo_Amortizado
GROUP BY FECHA_CIERRE

SELECT FECHA_CIERRE, COUNT(NUM_OBLIGACION_NUEVO) AS CUENTAS
FROM PORTAFOLIO.dbo.Costo_Amortizado_Hist
GROUP BY FECHA_CIERRE 
ORDER BY FECHA_CIERRE DESC

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------CRUZA LA VASE PORTAFOLIO.dbo.Costo_Amortizado CORTE DEL MES PARA TRAER MODALIDAD, LINEA Y SISTEMA. ESTO PARA EL RESUMEN QUE SE ENVÍA A LA COORDINACIÓN DE PORTAFOLIO

	SELECT 
	RTRIM(Num_Obligacion_Nuevo)AS Num_Obligacion_Nuevo,
	ACODSISTEMA,
	CASE WHEN ACODModalSuper = 1 THEN 'COMERCIAL'
	     WHEN ACODModalSuper = 2 THEN 'CONSUMO'
	     WHEN ACODModalSuper = 3 THEN 'VIVIENDA'
	     WHEN ACODModalSuper = 4 THEN 'MICROCREDITO' ELSE 'VALIDAR' END AS ACODModalSuper , 
	ACODLINEA 
	FROM DWH.dbo.CA_Prestamos_Definitivos AS A
	INNER JOIN PORTAFOLIO.dbo.Costo_Amortizado AS B ON A.ANUMObligacion = B.Num_Obligacion_Nuevo
	WHERE NFECCIERRE = '20250831'---------------------------------------------------------------------Cierre de mes que se esta ejecutando
	
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	select *
	from PORTAFOLIO.dbo.Costo_Amortizado_Hist ---Costo_Amortizado_Hist
	WHERE Num_Obligacion_Nuevo in (
'0132208475583'
,'0132206916242'
,'0199201041418'

)
AND Fecha_Cierre = '20250825'

update PORTAFOLIO.dbo.Costo_Amortizado
set Indicador_Creacion ='CRE'
WHERE Num_Obligacion_Nuevo in (
'0132208475583'
,'0132206916242'
,'0199201041418'
)  AND Fecha_Cierre = '20250825' AND Indicador_Creacion ='AMO'


		update PORTAFOLIO.dbo.Costo_Amortizado_Hist
		set Indicador_Creacion ='CRE'
		WHERE Num_Obligacion_Nuevo in (
'0132208475583'
,'0132206916242'
,'0199201041418'
		)  AND Fecha_Cierre = '20250825' AND Indicador_Creacion ='AMO'







	select *
	from PORTAFOLIO.dbo.Costo_Amortizado
	WHERE Num_Obligacion_Nuevo in (
'4894441050931879'
	) AND Fecha_Cierre = '20250225'


	update PORTAFOLIO.dbo.Costo_Amortizado
	set Indicador_Creacion ='CRE'
	WHERE Num_Obligacion_Nuevo in (
	'4894441050931879'
	)  AND Fecha_Cierre = '20250225' AND Indicador_Creacion ='AMO'
	go
	update PORTAFOLIO.dbo.Costo_Amortizado_Hist
	set Indicador_Creacion ='CRE'
	FROM PORTAFOLIO.dbo.Costo_Amortizado_Hist
	WHERE Num_Obligacion_Nuevo in (
	'4894441050931879'
	)  AND Fecha_Cierre = '20250225' AND Indicador_Creacion ='AMO'

select Indicador_Creacion,count(*)
from PORTAFOLIO.dbo.Costo_Amortizado_Hist
where Fecha_Cierre = '20241228'
group by Indicador_Creacion
	
select Indicador_Creacion,count(*)
from PORTAFOLIO.dbo.Costo_Amortizado
where Fecha_Cierre = '20241219'
group by Indicador_Creacion
	
	--Paso 3: Se validan bases 

	Select Fecha_Cierre, Count(Num_Obligacion_Nuevo) As Cuentas
	From PORTAFOLIO.dbo.Costo_Amortizado
	Group By Fecha_Cierre

	Select Fecha_Cierre, Count(Num_Obligacion_Nuevo) As Cuentas
	From PORTAFOLIO.dbo.Costo_Amortizado_Hist
	Group By Fecha_Cierre
	Order By Fecha_Cierre Desc
	
	Select *
	From PORTAFOLIO.dbo.Costo_Amortizado_Hist 
	WHERE Num_Obligacion_Nuevo='0548200012451'

	update PORTAFOLIO.dbo.Costo_Amortizado_Hist
	set Indicador_Creacion ='AMO'
	WHERE Num_Obligacion_Nuevo = '0548200012451' and Fecha_Cierre ='20250729'


	update PORTAFOLIO.dbo.Costo_Amortizado
	set Indicador_Creacion ='AMO'
	WHERE Num_Obligacion_Nuevo = '0548200012451' and Fecha_Cierre ='20250729'

	
	Select *
	From PORTAFOLIO.dbo.Costo_Amortizado
	WHERE Num_Obligacion_Nuevo IN (
'0132201856876',
'4570215012130759',
'0199174962959',
'0199200724621',
'0548200012451')
	
	


