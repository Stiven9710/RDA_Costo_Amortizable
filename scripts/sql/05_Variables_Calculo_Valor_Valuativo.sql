
--====================================PASO1======================================================
------------VALIDAR QUE HAYA SUBIDO LOS REGISTROS CORRECTAMENTE------------
-----------estos registros son del excel donde calcule la perdida/ganancia masiva


SELECT Fecha_Corte,COUNT(Numero_Id)
FROM ANDREAL.Costo_Amortizado_0044_BaseTotal_Acum_Info_Calculo_PerdidaGanancia
WHERE Fecha_Corte>='20180131'
GROUP BY Fecha_Corte
ORDER BY Fecha_Corte Desc


SELECT*
FROM  ANDREAL.Costo_Amortizado_0044_BaseTotal_Acum_Info_Calculo_PerdidaGanancia----------------------Recuperar!
WHERE Fecha_Corte ='20250930'  --cambiar fecha

--------DELETE 
--------FROM ANDREAL.Costo_Amortizado_0044_BaseTotal_Acum_Info_Calculo_PerdidaGanancia
--------WHERE Fecha_Corte='20250831'

------------------Insertar los registros que me generan perdida o ganancia 
------------------de todos los meses desde enero del 2018 a la fecha -----
-------------------"los de valor cero no" a la base 005, con pocas variables.

drop table ANDREAL.Costo_Amortizado_005_BaseTotal_Acum_PerdidaGanancia_Valuativa
SELECT  null as Fecha_cierre,
        Fecha_Corte as FechaCorte,
        null as Fecha_Reestructuracion,
        Obligación_Nueva as Numero_de_credito,
        Monto_Nuevo as Monto_a_reestructurar,
        TasaEfecNueva as Tasa_nueva,
        TasaMesNueva as Tasa_mes,
        PlazoNuevo as Plazo,
        ValorCuotaNiff as Valor_cuota,
        PerdidaGanancia as [Pérdida/(Ganancia)],
        null as Estado,
        null as Tipo,
        null as Altura,
        Herramienta,
        Tipo_Herramienta,
        Tipo_Obligacion,
        null Fecha_Cancelacion
INTO ANDREAL.Costo_Amortizado_005_BaseTotal_Acum_PerdidaGanancia_Valuativa
FROM ANDREAL.Costo_Amortizado_0044_BaseTotal_Acum_Info_Calculo_PerdidaGanancia
WHERE Fecha_Corte>='20180131' AND (PerdidaGanancia >= 1 or PerdidaGanancia <= -1)



/*
insert into ANDREAL.Costo_Amortizado_005_BaseTotal_Acum_PerdidaGanancia_Valuativa
(Fecha_cierre,FechaCorte,Fecha_Reestructuracion,Numero_de_credito,Monto_a_reestructurar,Tasa_nueva,Tasa_mes,Plazo,Valor_cuota,[Pérdida/(Ganancia)],
Estado,Tipo,Altura,Herramienta,Tipo_Herramienta,Tipo_Obligacion,Fecha_Cancelacion)
SELECT  null as Fecha_cierre,
        Fecha_Corte as FechaCorte,
        null as Fecha_Reestructuracion,
        Obligación_Nueva as Numero_de_credito,
        Monto_Nuevo as Monto_a_reestructurar,
        TasaEfecNueva as Tasa_nueva,
        TasaMesNueva as Tasa_mes,
        PlazoNuevo as Plazo,
        ValorCuotaNiff as Valor_cuota,
        PerdidaGanancia as [Pérdida/(Ganancia)],
        null as Estado,
        null as Tipo,
        null as Altura,
        Herramienta,
        Tipo_Herramienta,
        Tipo_Obligacion,
        null Fecha_Cancelacion
from ANDREAL.Costo_Amortizado_0044_BaseTotal_Acum_Info_Calculo_PerdidaGanancia
*/



--Validación

select*
from  ANDREAL.Costo_Amortizado_005_BaseTotal_Acum_PerdidaGanancia_Valuativa 
WHERE FechaCorte ='20250930'



--============================ELIMINO LO QUE YA ESTA CANCELADO, TITULARIZADO Y CASTIGADO================================

---------como cada mes se manda a amortizar el valor total de los creditos que ya no son vigentes
---------ni son cartera propia, no se pueden volver a reportar, es decir que debo sacar de la base 
---------todos los creditos que mes a mes mando a dar de baja.

---------hay una tabla creada que se llama cancelados y titularizados donde mes a mes incluyo los que 
---------mando a cancelar, por lo cual puedo cruzar esta información y excluir 
---------todos los que se encuentren en esta tabla porque ya estan cancelados en meses anteriores

-----------------------------sacar lo que ya mande a cancelar --------------------------------------

alter table ANDREAL.Costo_Amortizado_005_BaseTotal_Acum_PerdidaGanancia_Valuativa add Cancelados varchar(255)

update a
set a.Cancelados= b.Numero_de_Credito
from ANDREAL.Costo_Amortizado_005_BaseTotal_Acum_PerdidaGanancia_Valuativa as a
     left join
     ANDREAL.Costo_Amortizado_006_Base_Cancelados_Titularizados as b
on a.Numero_de_Credito=b.Numero_de_Credito AND a.FechaCorte=b.fechaCorte


---valida

select *
from  ANDREAL.Costo_Amortizado_005_BaseTotal_Acum_PerdidaGanancia_Valuativa
WHERE Cancelados IS NOT NULL 
ORDER BY FechaCorte

-----------------------------------------------------Elimina------------------------------------------------------

	
delete
from ANDREAL.Costo_Amortizado_005_BaseTotal_Acum_PerdidaGanancia_Valuativa
where Cancelados is not null

------------------cruzo con definitivos para traer estado altura, 
--------------------tipo al corte del mes que estoy revisando-----------

Update  a
set    a.Fecha_cierre=b.NFECCierre,
       a.Fecha_Reestructuracion=b.Nfecinicireestruc,
       a.Estado=b.Acodestadopresta,
       a.Tipo=b.Acodtipocartera,
       a.Altura=b.nnumaltura,
       a.Fecha_Cancelacion=b.NFECCancelacion
from ANDREAL.Costo_Amortizado_005_BaseTotal_Acum_PerdidaGanancia_Valuativa as a
     left join
     dwh.dbo.CA_PRESTAMOS_PRELIMINAR as b
on  a.Numero_de_credito=b.ANUMObligacion 
where b.NFECCierre='20250930' ---------------cambiar por el corte que se esta trabajando



---validacion

select*
from ANDREAL.Costo_Amortizado_005_BaseTotal_Acum_PerdidaGanancia_Valuativa
where Fecha_cierre is null 


------Esta parte se crea porque hay obligaciones con procesos de retencion que estan llegando duplicadas pero sin saldo Monto_a_reestructurar
delete
from ANDREAL.Costo_Amortizado_005_BaseTotal_Acum_PerdidaGanancia_Valuativa
where Monto_a_reestructurar is null
-----------------------llena la fecha de reestructuración cuando esta en 0 o vacia-------------

update a
set a.Fecha_Reestructuracion=b.Fecha_Corte
from  ANDREAL.Costo_Amortizado_005_BaseTotal_Acum_PerdidaGanancia_Valuativa as a left join 
 ANDREAL.Costo_Amortizado_002_BaseTotal_Acum as b
 on a.Numero_de_credito=b.Obligacion_Nueva
where a.Herramienta='Reestructurado' and (a.Fecha_Reestructuracion=0 or a.Fecha_Reestructuracion is null)


update a
set a.Fecha_Reestructuracion=b.Fecha_Retencion
from   ANDREAL.Costo_Amortizado_005_BaseTotal_Acum_PerdidaGanancia_Valuativa as a left join 
 ANDREAL.Costo_Amortizado_0011_Retenciones_Acum as b
 on a.Numero_de_credito=b.N_Obligacion and a.FechaCorte=b.Fecha_Corte
where a.Herramienta='Retención' 
     and (a.Fecha_Reestructuracion=0 or a.Fecha_Reestructuracion is null) ---- Se agrego una condición en el campo Monto_a_reestructurar debido a que esta trayendo problemas para ejecutar la macro.


update a
set a.Fecha_Reestructuracion=b.Fecha_Modificacion
from  ANDREAL.Costo_Amortizado_005_BaseTotal_Acum_PerdidaGanancia_Valuativa as a left join 
 ANDREAL.Costo_Amortizado_0011_Modificados_Acum as b
 on a.Numero_de_credito=b.N_Obligacion and a.FechaCorte=b.Fecha_Corte
where a.Herramienta='Modificado' and (a.Fecha_Reestructuracion = 0 or a.Fecha_Reestructuracion is null)


----validacion

----no deben haber registros. Deben estar vacias las siguientes validaciones

select*
from ANDREAL.Costo_Amortizado_005_BaseTotal_Acum_PerdidaGanancia_Valuativa
where Fecha_Reestructuracion=0 or Fecha_Reestructuracion is null


select*
from ANDREAL.Costo_Amortizado_005_BaseTotal_Acum_PerdidaGanancia_Valuativa
where Fecha_Cierre=0 or Fecha_Cierre is null order by fechacorte------ Las fechas de cierre nulas se borran en el paso de los duplicados ---

/*UPDATE ANDREAL.Costo_Amortizado_005_BaseTotal_Acum_PerdidaGanancia_Valuativa
SET Fecha_Cierre='20220731'  
WHERE  numero_de_credito IN ('0132208289434')*/

select*
from ANDREAL.Costo_Amortizado_005_BaseTotal_Acum_PerdidaGanancia_Valuativa
where Monto_a_Reestructurar=0 or Valor_cuota=0 or Monto_a_Reestructurar is null or Valor_cuota is null
order by fechacorte


---------cambiar la altura calculada de acuerdo a los meses que han pasado desde que entraron----------------

update ANDREAL.Costo_Amortizado_005_BaseTotal_Acum_PerdidaGanancia_Valuativa
set Altura=(Fecha_cierre/100/100-FechaCorte/100/100)*12+(((Fecha_cierre/100)%100)-((FechaCorte/100)%100))


--Validación


select FechaCorte,Altura
from ANDREAL.Costo_Amortizado_005_BaseTotal_Acum_PerdidaGanancia_Valuativa
group by FechaCorte,Altura
order by FechaCorte


--============================REVISAR DUPLICADOS Y ELIMINARLOS================================

---------Estas obligaciones son duplicadas porque se le ha hecho mas de 1 retención AL CLIENTE----------
---------estas obligaciones se vienen arreglando para no enviarlas duplicadas, se cancelo
---------la mas vieja y se deja la mas actual, sin embargo de ahora en adelante 
---------para estos casos no se cancelan sino se agrupan, pero la historia ya no es posible arreglarla
--------por lo cual se debe eliminar


alter table ANDREAL.Costo_Amortizado_005_BaseTotal_Acum_PerdidaGanancia_Valuativa add Duplicada varchar(200)

update a
set a.Duplicada= b.obligacion
from ANDREAL.Costo_Amortizado_005_BaseTotal_Acum_PerdidaGanancia_Valuativa as a
     left join
     ANDREAL.Costo_Amortizado_008_Duplicados_Eliminar as b
on a.Numero_de_Credito=b.obligacion AND a.FechaCorte=b.fecha


--valida


select *
from ANDREAL.Costo_Amortizado_005_BaseTotal_Acum_PerdidaGanancia_Valuativa
where Duplicada is not null


--Elimina

delete
from ANDREAL.Costo_Amortizado_005_BaseTotal_Acum_PerdidaGanancia_Valuativa
where Duplicada is not null

---- Validación

select *
from ANDREAL.Costo_Amortizado_005_BaseTotal_Acum_PerdidaGanancia_Valuativa
where Fecha_cierre is null


------------------cruzo con diario estado y tipo para mandar a amortizar el total -----------------------------------------------------

------------------como ya elimine lo que en meses pasados mande a cancelar, ahora se debe identificar------
------------------que se va a mandar cancelar este mes, por tanto cruzo con el diario mas reciente-----
------------------para saber que obligaciones se cancelaron o se titularizaron es el ultimo mes-----
------------------para mandarlas a amortizar en su totalidad.


Select MAX(NFECCierre) from dwh.dbo.CA_PRESTAMOS_DIARIO

Update  a
set     a.Estado=b.Acodestadopresta,
        a.Tipo=b.Acodtipocartera,
        a.Fecha_Cancelacion=b.NFECCancelacion
from ANDREAL.Costo_Amortizado_005_BaseTotal_Acum_PerdidaGanancia_Valuativa as a
     left join
     dwh.dbo.CA_PRESTAMOS_DIARIO as b
on  a.Numero_de_credito=b.ANUMObligacion 
where b.NFECCierre='20251025'  ----cambio la fecha a la que esta en el diario

--validacion


select*
from ANDREAL.Costo_Amortizado_005_BaseTotal_Acum_PerdidaGanancia_Valuativa
where  Estado!=1 or Tipo!=1

-------------------------------------------sofia
--------------los ingreso en la tabla de cancelados y titularizados ----------------------------
----------------para el prox mes sacarlos en el paso anterior--------------------------------------


-------------Como en el paso anterior ya identifique los que debo mandar a cancelar este mes-----
-------------entonces los ingreso a la tabla de cancelados y titularizados para que en el proximo ---
-----------*-mes que corra el proceso de nuevo los pueda excluir porque no se pueden volver a reportar

INSERT INTO ANDREAL.Costo_Amortizado_006_Base_Cancelados_Titularizados
select Fecha_cierre,FechaCorte,Numero_de_Credito,Estado,Tipo,Altura,Fecha_Cancelacion, 
null as Fecha_Titularizado
from ANDREAL.Costo_Amortizado_005_BaseTotal_Acum_PerdidaGanancia_Valuativa
where Estado!=1 or Tipo!=1  
--where  Numero_de_credito='0185200020173'--cuando quiero ingresar un credito manualmente

------------- elimino todos los cancelados en lo corrido del mes------
--------- porque ya el provisionador amortiza la totalidad cuando se cancelan------------

delete
from ANDREAL.Costo_Amortizado_005_BaseTotal_Acum_PerdidaGanancia_Valuativa
where (Estado!=1 or Tipo!=1)


----------------- llenar tabla final para calculo valuativo--------------------


drop table dbo.bd_perdidas_ganancias_dwh
Select 
rolando.fecha(Fecha_cierre) as Fecha_cierre, -- esta formula cambia el formato de entero a fecha
rolando.fecha(FechaCorte) as Fecha_Reestructuracion, -- esta formula cambia el formato de entero a fecha
Estado,
Tipo,
Numero_de_credito, 
Monto_a_reestructurar,
Tasa_nueva, 
Tasa_mes, 
Plazo, 
Valor_cuota,
Altura,
[Pérdida/(Ganancia)]
Into dbo.bd_perdidas_ganancias_dwh
From ANDREAL.Costo_Amortizado_005_BaseTotal_Acum_PerdidaGanancia_Valuativa	


---validación

select COUNT(*)
from ANDREAL.Costo_Amortizado_005_BaseTotal_Acum_PerdidaGanancia_Valuativa


Select COUNT(*)
from dbo.bd_perdidas_ganancias_dwh


Select*
from dbo.bd_perdidas_ganancias_dwh
Where Plazo < Altura
--Igualar el plazo a la altura de los créditos que el plazo es menor a la altura

Update dbo.bd_perdidas_ganancias_dwh
Set Plazo = Altura
Where Plazo < Altura


/* select *
from bd_perdidas_ganancias_dwh */ 

select * 
from ANDREAL.Costo_Amortizado_005_BaseTotal_Acum_PerdidaGanancia_Valuativa
where Monto_a_reestructurar is null

select * 
from dbo.bd_perdidas_ganancias_dwh
where Monto_a_reestructurar is null


--Delete bd_perdidas_ganancias_dwh where Monto_a_reestructurar is null

--========================================================================================================
--=======================================HASTA ACA========================================================
--========================================================================================================

--------------Me voy a excel y corro la macro, una vez se tengan los resultados volver a subirlos a la tabla-----------------
----------------------------------- "Costo_Amortizado_009_Base_Valuativa" --------------------

--validar su subio completa

select fecha_cierre, COUNT(*)
from [ANDREAL].[Costo_Amortizado_009_Base_Valuativa] 
group by fecha_cierre
order by fecha_cierre Desc


select *
from [ANDREAL].[Costo_Amortizado_009_Base_Valuativa]
WHERE fecha_cierre = '20250930'


  
--==============================================================================================================
--===========================================SEGUNDA PARTE=======================================================
--================================================================================================================


-------------------------------------------AGRUPAR LA INFORMACIÓN PARA LOS QUE TIENEN MAS DE UN REGISTRO-----------------

-----------------Dado a que no se pueden enviar mas de un registro de una obligación a tecnologia, debo agrupar la información por obligación, es decir:
-----------------si tengo dos registros de la misma obligación debo sumar las perdidas o ganancias, la amortización del mes, en un solo registro------------ 



UPDATE [ANDREAL].[Costo_Amortizado_009_Base_Valuativa] SET [AMORTIZACIÓN ACUMULADA]=0 WHERE [AMORTIZACIÓN ACUMULADA] IS NULL


drop table #BASEFINALVALIDA
SELECT FECHA_CIERRE,NUM_OBLIGACION_NUEVO AS OBLIGACION,SUM([PERDIDA/GANANCIA]) AS [PERDIDA/GANANCIA],SUM(VALOR_POR_AMORTIZAR) AS VALOR_POR_AMORTIZAR,
SUM(AMORTIZACION_MES) AS AMORTIZACION_MES,
'CRE' AS INDICADOR_CREACION,
MAX(FECHA_REEST) AS FECHA_REESTRUCTURACION,MAX(ALTURA) AS ALTURA, COUNT(*) CUENTAS
INTO #BASEFINALVALIDA
FROM [ANDREAL].[Costo_Amortizado_009_Base_Valuativa]
where [Fecha_Cierre]='20250831' ---cambio el corte por el que estoy trabajando
GROUP BY FECHA_CIERRE,NUM_OBLIGACION_NUEVO


--valido

select*
from #BASEFINALVALIDA

----------------------------------REVISÓ SI ALGUNA DE LAS OBLIGACIONES NUEVAS QUE VOY A ENVÍAR YA LAS HABIA REPORTADO ANTES Y FUERON AMORTIZADAS TOTALMENTE----


---------Esto es con el fin de identificarlas para enviar a tecnologia con el indicador REM quq significa remplazar, ya que antes--------------------
---------el sistema no permitia abrir una nueva amortización a un credito, asi estuviera cerrado el anterior. ejemplos los titularizados-----------------

ALTER TABLE #BASEFINALVALIDA ADD REPORTADA_ANTES VARCHAR(200)

UPDATE A
SET A.REPORTADA_ANTES=B.Numero_de_Credito
FROM (SELECT* FROM #BASEFINALVALIDA WHERE ALTURA=0) AS A
LEFT JOIN
ANDREAL.Costo_Amortizado_006_Base_Cancelados_Titularizados AS B
ON A.OBLIGACION=B.NUMERO_DE_CREDITO 
WHERE B.ALTURA!=0


--VALIDA


SELECT*
FROM #BASEFINALVALIDA
WHERE REPORTADA_ANTES IS NOT NULL   --- En el siguiente paso se le asigna Indicador de creación= REM


----------------------------------CALCULO EL INDICADOR DE ACUERDO A LAS VALIDACIONES--------------

---CUENTAS>1 THEN 'REM'  Este caso es cuando una obligación tiene un proceso abierto que se esta amortizando, pero nace un nuevo proceso sin haberse cerrado
----el anterior entonces como lo tengo agrupado se cuantos registros agrupe con el contar. Esto se reporta tambien con REM reemplazar ya que no empieza a 
-----amortizar la suma de los dos.


----REPORTADA_ANTES IS NOT NUL  Son obligaciones que antes ya habian tenido un proceso pero que ya estaba cerrado, sin embargo se deben identificar para 
----enviarlas con el indicador REM reemplazar para que el sistema le permita empezar a contabilizar un proceso nuevo.


----ALTURA=0 THEN 'CRE'  Son las obligaciones nuevas en el proceso. Las reporto por primera vez se deben reportar con el indicador CRE crear para que 
----el sistema permita abrirle un proceso.


-----ELSE 'AMO'  Estas son obligaciones que se amortizan normalmente que en el mes no se presentó nada de las opciones anteriores


UPDATE #BASEFINALVALIDA
SET INDICADOR_CREACION=CASE WHEN CUENTAS>1 THEN 'REM'
                            WHEN REPORTADA_ANTES IS NOT NULL THEN  'REM'
							WHEN ALTURA=0 THEN 'CRE'
							ELSE 'AMO'
					   END


--VALIDA


SELECT INDICADOR_CREACION,ALTURA,CUENTAS,COUNT(*)
FROM #BASEFINALVALIDA
GROUP BY CUENTAS,ALTURA,INDICADOR_CREACION
ORDER BY INDICADOR_CREACION,ALTURA,CUENTAS


--------------------------GUARDA EN LA BASE HISTORICA AGRUPADA--------------------------


insert into ANDREAL.Costo_Amortizado_010_Base_Valuativa_Agrupada
SELECT*
FROM #BASEFINALVALIDA

--VALIDA

select *
from #BASEFINALVALIDA  ----> Información pra la hoja "BASE" 




select FECHA_CIERRE, count(*)
from ANDREAL.Costo_Amortizado_010_Base_Valuativa_Agrupada  
group by FECHA_CIERRE order by FECHA_CIERRE desc



---------------------------------resultado para llevar al excel----------------------

SELECT *
FROM ANDREAL.Costo_Amortizado_010_Base_Valuativa_Agrupada
WHERE FECHA_CIERRE='20250630' -- cambiar la fecha del ultimo corte
--AND OBLIGACION ='0157200004638'

SELECT *
FROM ANDREAL.Costo_Amortizado_010_Base_Valuativa_Agrupada
WHERE FECHA_CIERRE>='20250630' -- cambiar la fecha del ultimo corte
AND OBLIGACION ='0185200064123'


---------- Tabla Casos especiales Comercial--------------------

Select * from PORTAFOLIO.dbo.Costo_Amortizado_Casos_Especiales_Hist
where NFECcierre = '202509' ---------cambiar al mes de evaluación 


and anumobligacion = '0157200004931' 
Order by nfeccierre

Select * from PORTAFOLIO.dbo.Costo_Amortizado_Casos_Especiales_Hist
where anumobligacion = '0157210003524'
Order by nfeccierre


