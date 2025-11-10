-----verifica la información donde acumulo todos los meses-------

select Fecha_Corte,Herramienta,COUNT(numero_id)
from ANDREAL.Costo_Amortizado_002_BaseTotal_Acum
where Fecha_Corte>='20180131'
group by Fecha_Corte,Herramienta
order by Fecha_Corte desc





--------------ACUMULAR EN LA BASE TOTAL-------------acumulo el mes que estoy trabajando





------------ ------REESTRUCTURADOS----------------------------------------

INSERT INTO ANDREAL.Costo_Amortizado_002_BaseTotal_Acum
SELECT*
FROM ANDREAL.Costo_Amortizado_001_Reestructurados_Acum
where Fecha_Corte='20250930'  --------------CAMBIAR FECHA ULTIMO CORTE EL QUE SE ESTA TRABAJANDO



------------------------RETENCIONES-------------------------------



INSERT INTO ANDREAL.Costo_Amortizado_002_BaseTotal_Acum
SELECT*
FROM ANDREAL.Costo_Amortizado_001_Retenciones_Acum
where Fecha_Corte='20250930' --------------CAMBIAR FECHA ULTIMO CORTE EL QUE SE ESTA TRABAJANDO


------------------------MODIFICADOS-------------------------------



INSERT INTO ANDREAL.Costo_Amortizado_002_BaseTotal_Acum
SELECT*
FROM ANDREAL.Costo_Amortizado_001_Modificados_Acum
where Fecha_Corte='20250930' --------------CAMBIAR FECHA ULTIMO CORTE EL QUE SE ESTA TRABAJANDO

-----valida

select Fecha_Corte,Herramienta,COUNT(numero_id)
from ANDREAL.Costo_Amortizado_002_BaseTotal_Acum
where Fecha_Corte>='20180131'
group by Fecha_Corte,Herramienta
order by Fecha_Corte desc


---*****************************************************************************************
-----------------------------------------------------------------------------
--======================traer la información  del mes para buscar la tasa, plazos, saldos==========================




drop table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info
select*
into ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info
from ANDREAL.Costo_Amortizado_002_BaseTotal_Acum
where Fecha_Corte='20250930' ----Cambiar fecha  por la que estamos trabajando


--valida----


select*
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info 


---------------------------Obligación nueva-------------------------------------



alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add Saldo decimal(18,2)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add TasaEfec decimal(11,8)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add TasaMes decimal(11,8)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add Plazo int


update a
set a.Tipo_Id = b.ACODIdenPerso,
	a.Numero_Id = b.ANUMIdenPerso,
	a.Modalidad = b.ACODModalSuper,
	a.Saldo=b.NVALSaldoCapital,
    a.TasaEfec=b.NPRCTasaActualEfec/100,
    a.TasaMes=b.NPRCTasaActualNomi/1200,
    a.Plazo=b.NNUMPlazo
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info as a left join
      (select* from dwh.dbo.CA_PRESTAMOS_PRELIMINAR where NFECCierre='20250930') as b--cierre actual el que estamos analizando
	  ---(select* from dwh.dbo.CA_PRESTAMOS_DIARIO where NFECCierre='20240725') as b
on a.Obligacion_Nueva=b.ANUMObligacion




----validación 
---de la obligación nueva debe traerme de todos información si no la trae se debe revisar porque no esta cruzando.


select*
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info
where Saldo is null 


select*
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info
where Obligacion_Nueva= '30018710277'

--delete ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info where Obligacion_Nueva = '30018710277' and Fecha_Corte = '20250228'
--delete ANDREAL.Costo_Amortizado_002_BaseTotal_Acum where Obligacion_Nueva = '30018710277' and Fecha_Corte = '20250228'


/*30021063612
0191200038371*/

--delete ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info where Obligacion_Nueva in
--('30021063612',
--'0000000000000',
--'30020044238',
--'30020472910',
--'30021372727')

---------------------------Obligación anterior 1-------------------------------------


alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add Saldo1 decimal(18,2)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add TasaEfec1 decimal(11,8)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add TasaMes1 decimal(11,8)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add Plazo1 int



update a
set a.Saldo1=b.NVALSaldoCapital,
    a.TasaEfec1=b.NPRCTasaActualEfec/100,
    a.TasaMes1=b.NPRCTasaActualNomi/1200,
    a.Plazo1=b.NNUMPlazo
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info as a left join
      (select* from dwh.dbo.CA_PRESTAMOS_DIARIO where NFECCierre='20250831') as b--cierre anterior al que estamos trabajando
on a.Obligacion1=b.ANUMObligacion

select * from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info


----validación 
---obligación1 si tiene numero de obligación debe cruzarme, de lo contrario se debe revisar porque no trae información. 


select *
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info
where Saldo1 is null AND Obligacion1 IS NOT NULL


--===============cruze para cuando es la misma obligación===================


update a
set a.Saldo1=b.NVALSaldoCapital,
    a.TasaEfec1=b.NPRCTasaActualEfec/100,
    a.TasaMes1=b.NPRCTasaActualNomi/1200,
    a.Plazo1=b.NNUMPlazo
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info as a left join
      (select* from dwh.dbo.Ca_PRESTAMOS_DEFINITIVOS where NFECCierre='20250831') as b--cierre anterior al que estamos trabajando
on a.Obligacion_Nueva=b.ANUMObligacion
where a.Obligacion1 is null

---select * from dwh.dbo.Ca_PRESTAMOS_preliminar where anumobligacion='4704371090676285'

----validación 
---obligación1 si tiene numero de obligación debe cruzarme, de lo contrario se debe revisar porque no trae información. 


select*
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info
where Saldo1 IS NULL


---------------------------Obligación reestructurada 2 -------------------------------------


alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add Saldo2 decimal(18,2)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add TasaEfec2 decimal(11,8)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add TasaMes2 decimal(11,8)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add Plazo2 int



update a
set a.Saldo2=b.NVALSaldoCapital,
    a.TasaEfec2=b.NPRCTasaActualEfec/100,
    a.TasaMes2=b.NPRCTasaActualNomi/1200,
    a.Plazo2=b.NNUMPlazo
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info as a left join
      (select* from dwh.dbo.Ca_PRESTAMOS_DEFINITIVOS where NFECCierre='20250831') as b--cierre anterior
on a.Obligacion2=b.ANUMObligacion
where a.Obligacion2 is not null


----validación 
---obligación1 si tiene numero de obligación debe cruzarme, de lo contrario se debe revisar porque no trae información. 
 
 
select*
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info
where Saldo2 is null and obligacion2 is not null



---------------------------Obligación reestructurada 3 -------------------------------------

alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add Saldo3 decimal(18,2)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add TasaEfec3 decimal(11,8)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add TasaMes3 decimal(11,8)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add Plazo3 int



update a
set a.Saldo3=b.NVALSaldoCapital,
    a.TasaEfec3=b.NPRCTasaActualEfec/100,
    a.TasaMes3=b.NPRCTasaActualNomi/1200,
    a.Plazo3=b.NNUMPlazo
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info as a left join
      (select* from dwh.dbo.Ca_PRESTAMOS_DEFINITIVOS where NFECCierre='20250831') as b--cierre anterior
on a.Obligacion3=b.ANUMObligacion
where a.Obligacion3 is not null


----validación 
---obligación1 si tiene numero de obligación debe cruzarme, de lo contrario se debe revisar porque no trae información. 


select*
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info
where Saldo3 is null and obligacion3 is not null



---------------------------Obligación reestructurada 4 -------------------------------------


alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add Saldo4 decimal(18,2)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add TasaEfec4 decimal(11,8)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add TasaMes4 decimal(11,8)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add Plazo4 int


update a
set a.Saldo4=b.NVALSaldoCapital,
    a.TasaEfec4=b.NPRCTasaActualEfec/100,
    a.TasaMes4=b.NPRCTasaActualNomi/1200,
    a.Plazo4=b.NNUMPlazo
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info as a left join
      (select* from dwh.dbo.Ca_PRESTAMOS_DEFINITIVOS where NFECCierre='20250831') as b--cierre anterior
on a.Obligacion4=b.ANUMObligacion
where a.Obligacion4 is not null



----validación 
---obligación1 si tiene numero de obligación debe cruzarme, de lo contrario se debe revisar porque no trae información. 



select*
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info
where Saldo4 is null and obligacion4 is not null



---------------------------Obligación reestructurada 5 -------------------------------------



alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add Saldo5 decimal(18,2)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add TasaEfec5 decimal(11,8)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add TasaMes5 decimal(11,8)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add Plazo5 int



update a
set a.Saldo5=b.NVALSaldoCapital,
    a.TasaEfec5=b.NPRCTasaActualEfec/100,
    a.TasaMes5=b.NPRCTasaActualNomi/1200,
    a.Plazo5=b.NNUMPlazo
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info as a left join
      (select* from dwh.dbo.Ca_PRESTAMOS_DEFINITIVOS where NFECCierre='20250831') as b --cierre anterior
on a.Obligacion5=b.ANUMObligacion




----validación 
---obligación1 si tiene numero de obligación debe cruzarme, de lo contrario se debe revisar porque no trae información. 



select*
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info
where Saldo5 is null and obligacion5 is not null


---------------------------Obligación reestructurada 6 -------------------------------------


alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add Saldo6 decimal(18,2)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add TasaEfec6 decimal(11,8)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add TasaMes6 decimal(11,8)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add Plazo6 int


update a
set a.Saldo6=b.NVALSaldoCapital,
    a.TasaEfec6=b.NPRCTasaActualEfec/100,
    a.TasaMes6=b.NPRCTasaActualNomi/1200,
    a.Plazo6=b.NNUMPlazo
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info as a left join
      (select* from dwh.dbo.Ca_PRESTAMOS_DEFINITIVOS where NFECCierre='20250831') as b--cierre anterior
on a.Obligacion6=b.ANUMObligacion


----validación 
---obligación1 si tiene numero de obligación debe cruzarme, de lo contrario se debe revisar porque no trae información. 


select*
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info
where Saldo6 is  null and obligacion6 is not null





---------------------------Obligación reestructurada 7 -------------------------------------

alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add Saldo7 decimal(18,2)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add TasaEfec7 decimal(11,8)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add TasaMes7 decimal(11,8)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add Plazo7 int


update a
set a.Saldo7=b.NVALSaldoCapital,
    a.TasaEfec7=b.NPRCTasaActualEfec/100,
    a.TasaMes7=b.NPRCTasaActualNomi/1200,
    a.Plazo7=b.NNUMPlazo
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info as a left join
      (select* from dwh.dbo.Ca_PRESTAMOS_DEFINITIVOS where NFECCierre='20250831') as b--cierre anterior
on a.Obligacion7=b.ANUMObligacion


----validación 
---obligación1 si tiene numero de obligación debe cruzarme, de lo contrario se debe revisar porque no trae información. 


select*
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info
where Saldo7 is null and obligacion7 is not null



---------------------------Obligación reestructurada 8 -------------------------------------

alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add Saldo8 decimal(18,2)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add TasaEfec8 decimal(11,8)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add TasaMes8 decimal(11,8)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add Plazo8 int


update a
set a.Saldo8=b.NVALSaldoCapital,
    a.TasaEfec8=b.NPRCTasaActualEfec/100,
    a.TasaMes8=b.NPRCTasaActualNomi/1200,
    a.Plazo8=b.NNUMPlazo
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info as a left join
      (select* from dwh.dbo.Ca_PRESTAMOS_DEFINITIVOS where NFECCierre='20250831') as b--cierre anterior
on a.Obligacion8=b.ANUMObligacion


----validación 
---obligación1 si tiene numero de obligación debe cruzarme, de lo contrario se debe revisar porque no trae información. 


select*
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info
where Saldo8 is null and obligacion8 is not null


---------------------------Obligación reestructurada 9 -------------------------------------

alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add Saldo9 decimal(18,2)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add TasaEfec9 decimal(11,8)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add TasaMes9 decimal(11,8)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add Plazo9 int


update a
set a.Saldo9=b.NVALSaldoCapital,
    a.TasaEfec9=b.NPRCTasaActualEfec/100,
    a.TasaMes9=b.NPRCTasaActualNomi/1200,
    a.Plazo9=b.NNUMPlazo
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info as a left join
      (select* from dwh.dbo.Ca_PRESTAMOS_DEFINITIVOS where NFECCierre='20250831') as b--cierre anterior
on a.Obligacion9=b.ANUMObligacion


----validación 
---obligación1 si tiene numero de obligación debe cruzarme, de lo contrario se debe revisar porque no trae información. 


select*
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info
where Saldo9 is null and obligacion9 is not null


---------------------------Obligación reestructurada 10 -------------------------------------

alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add Saldo10 decimal(18,2)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add TasaEfec10 decimal(11,8)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add TasaMes10 decimal(11,8)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add Plazo10 int


update a
set a.Saldo10=b.NVALSaldoCapital,
    a.TasaEfec10=(b.NPRCTasaActualEfec/100),
    a.TasaMes10=(b.NPRCTasaActualNomi/1200),
    a.Plazo10=b.NNUMPlazo
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info as a left join
      (select* from dwh.dbo.Ca_PRESTAMOS_DEFINITIVOS where NFECCierre='20250831') as b--cierre anterior
on a.Obligacion10=b.ANUMObligacion



----validación 
---obligación1 si tiene numero de obligación debe cruzarme, de lo contrario se debe revisar porque no trae información. 
 

select*
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info
where Saldo10 is null and obligacion10 is not null


---------------------------Obligación reestructurada 11 -------------------------------------

alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add Saldo11 decimal(18,2)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add TasaEfec11 decimal(11,8)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add TasaMes11 decimal(11,8)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add Plazo11 int


update a
set a.Saldo11=b.NVALSaldoCapital,
    a.TasaEfec11=(b.NPRCTasaActualEfec/100),
    a.TasaMes11=(b.NPRCTasaActualNomi/1200),
    a.Plazo11=b.NNUMPlazo
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info as a left join
      (select* from dwh.dbo.Ca_PRESTAMOS_DEFINITIVOS where NFECCierre='20250831') as b--cierre anterior
on a.Obligacion11=b.ANUMObligacion


----validación 
---obligación1 si tiene numero de obligación debe cruzarme, de lo contrario se debe revisar porque no trae información. 


select*
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info
where Saldo11 is null and obligacion11 is not null


---------------------------Obligación reestructurada 12 -------------------------------------


alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add Saldo12 decimal(18,2)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add TasaEfec12 decimal(11,8)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add TasaMes12 decimal(11,8)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add Plazo12 int


update a
set a.Saldo12=b.NVALSaldoCapital,
    a.TasaEfec12=(b.NPRCTasaActualEfec/100),
    a.TasaMes12=(b.NPRCTasaActualNomi/1200),
    a.Plazo12=b.NNUMPlazo
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info as a left join
      (select* from dwh.dbo.Ca_PRESTAMOS_DEFINITIVOS where NFECCierre='20250831') as b--cierre anterior
on a.Obligacion12=b.ANUMObligacion


----validación 
---obligación1 si tiene numero de obligación debe cruzarme, de lo contrario se debe revisar porque no trae información. 


select*
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info
where Saldo12 is null and obligacion12 is not null


---------------------------Obligación reestructurada 13 -------------------------------------

alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add Saldo13 decimal(18,2)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add TasaEfec13 decimal(11,8)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add TasaMes13 decimal(11,8)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add Plazo13 int


update a
set a.Saldo13=b.NVALSaldoCapital,
    a.TasaEfec13=(b.NPRCTasaActualEfec/100),
    a.TasaMes13=(b.NPRCTasaActualNomi/1200),
    a.Plazo13=b.NNUMPlazo
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info as a left join
      (select* from dwh.dbo.Ca_PRESTAMOS_DEFINITIVOS where NFECCierre='20250831') as b--cierre anterior
on a.Obligacion13=b.ANUMObligacion


----validación 
---obligación1 si tiene numero de obligación debe cruzarme, de lo contrario se debe revisar porque no trae información. 


select*
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info
where Saldo13 is null and obligacion13 is not null


---------------------------Obligación reestructurada 14 -------------------------------------


alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add Saldo14 decimal(18,2)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add TasaEfec14 decimal(11,8)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add TasaMes14 decimal(11,8)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add Plazo14 int


update a
set a.Saldo14=b.NVALSaldoCapital,
    a.TasaEfec14=(b.NPRCTasaActualEfec/100),
    a.TasaMes14=(b.NPRCTasaActualNomi/1200),
    a.Plazo14=b.NNUMPlazo
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info as a left join
      (select* from dwh.dbo.Ca_PRESTAMOS_DEFINITIVOS where NFECCierre='20250831') as b--cierre anterior
on a.Obligacion14=b.ANUMObligacion


----validación 
---obligación1 si tiene numero de obligación debe cruzarme, de lo contrario se debe revisar porque no trae información. 


select*
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info
where Saldo14 is null and obligacion14 is not null


---------------------------Obligación reestructurada 15 -------------------------------------

alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add Saldo15 decimal(18,2)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add TasaEfec15 decimal(11,8)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add TasaMes15 decimal(11,8)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add Plazo15 int

update a
set a.Saldo15=b.NVALSaldoCapital,
    a.TasaEfec15=(b.NPRCTasaActualEfec/100),
    a.TasaMes15=(b.NPRCTasaActualNomi/1200),
    a.Plazo15=b.NNUMPlazo
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info as a left join
      (select* from dwh.dbo.Ca_PRESTAMOS_DEFINITIVOS where NFECCierre='20250831') as b--cierre anterior
on a.Obligacion15=b.ANUMObligacion


----validación 
---obligación1 si tiene numero de obligación debe cruzarme, de lo contrario se debe revisar porque no trae información. 


select*
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info
where Saldo15 is null and obligacion15 is not null


---------------------------Obligación reestructurada 16 -------------------------------------

alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add Saldo16 decimal(18,2)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add TasaEfec16 decimal(11,8)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add TasaMes16 decimal(11,8)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add Plazo16 int


update a
set a.Saldo16=b.NVALSaldoCapital,
    a.TasaEfec16=(b.NPRCTasaActualEfec/100),
    a.TasaMes16=(b.NPRCTasaActualNomi/1200),
    a.Plazo16=b.NNUMPlazo
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info as a left join
      (select* from dwh.dbo.Ca_PRESTAMOS_DEFINITIVOS where NFECCierre='20250831') as b--cierre anterior
on a.Obligacion16=b.ANUMObligacion



----validación 
---obligación1 si tiene numero de obligación debe cruzarme, de lo contrario se debe revisar porque no trae información. 



select*
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info
where Saldo16 is null and obligacion16 is not null


---------------------------Obligación reestructurada 17 -------------------------------------


alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add Saldo17 decimal(18,2)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add TasaEfec17 decimal(11,8)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add TasaMes17 decimal(11,8)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add Plazo17 int


update a
set a.Saldo17=b.NVALSaldoCapital,
    a.TasaEfec17=(b.NPRCTasaActualEfec/100),
    a.TasaMes17=(b.NPRCTasaActualNomi/1200),
    a.Plazo17=b.NNUMPlazo
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info as a left join
      (select* from dwh.dbo.Ca_PRESTAMOS_DEFINITIVOS where NFECCierre='20250831') as b--cierre anterior
on a.Obligacion17=b.ANUMObligacion


----validación 
---obligación1 si tiene numero de obligación debe cruzarme, de lo contrario se debe revisar porque no trae información. 


select*
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info
where Saldo17 is null and obligacion17 is not null


---------------------------Obligación reestructurada 18 -------------------------------------


alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add Saldo18 decimal(18,2)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add TasaEfec18 decimal(11,8)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add TasaMes18 decimal(11,8)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add Plazo18 int



update a
set a.Saldo18=b.NVALSaldoCapital,
    a.TasaEfec18=(b.NPRCTasaActualEfec/100),
    a.TasaMes18=(b.NPRCTasaActualNomi/1200),
    a.Plazo18=b.NNUMPlazo
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info as a left join
      (select* from dwh.dbo.Ca_PRESTAMOS_DEFINITIVOS where NFECCierre='20250831') as b--cierre anterior
on a.Obligacion18=b.ANUMObligacion



----validación 
---obligación1 si tiene numero de obligación debe cruzarme, de lo contrario se debe revisar porque no trae información. 


select*
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info
where Saldo18 is null and obligacion18 is not null


---------------------------Obligación reestructurada 19 -------------------------------------


alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add Saldo19 decimal(18,2)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add TasaEfec19 decimal(11,8)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add TasaMes19 decimal(11,8)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add Plazo19 int



update a
set a.Saldo19=b.NVALSaldoCapital,
    a.TasaEfec19=(b.NPRCTasaActualEfec/100),
    a.TasaMes19=(b.NPRCTasaActualNomi/1200),
    a.Plazo19=b.NNUMPlazo
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info as a left join
      (select* from dwh.dbo.Ca_PRESTAMOS_DEFINITIVOS where NFECCierre='20250831') as b--cierre anterior
on a.Obligacion19=b.ANUMObligacion



----validación 
---obligación1 si tiene numero de obligación debe cruzarme, de lo contrario se debe revisar porque no trae información. 


select*
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info
where Saldo19 is null and obligacion19 is not null


---------------------------Obligación reestructurada 20 -------------------------------------

alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add Saldo20 decimal(18,2)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add TasaEfec20 decimal(11,8)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add TasaMes20 decimal(11,8)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add Plazo20 int


update a
set a.Saldo20=b.NVALSaldoCapital,
    a.TasaEfec20=(b.NPRCTasaActualEfec/100),
    a.TasaMes20=(b.NPRCTasaActualNomi/1200),
    a.Plazo20=b.NNUMPlazo
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info as a left join
      (select* from dwh.dbo.Ca_PRESTAMOS_DEFINITIVOS where NFECCierre='20250831') as b--cierre anterior
on a.Obligacion20=b.ANUMObligacion



----validación 
---obligación1 si tiene numero de obligación debe cruzarme, de lo contrario se debe revisar porque no trae información. 


select*
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info
where Saldo20 is null and obligacion20 is not null


---------------------------Obligación reestructurada 21 -------------------------------------

alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add Saldo21 decimal(18,2)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add TasaEfec21 decimal(11,8)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add TasaMes21 decimal(11,8)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add Plazo21 int



update a
set a.Saldo21=b.NVALSaldoCapital,
    a.TasaEfec21=(b.NPRCTasaActualEfec/100),
    a.TasaMes21=(b.NPRCTasaActualNomi/1200),
    a.Plazo21=b.NNUMPlazo
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info as a left join
      (select* from dwh.dbo.Ca_PRESTAMOS_DEFINITIVOS where NFECCierre='20250831') as b--cierre anterior
on a.Obligacion21=b.ANUMObligacion


----validación 
---obligación1 si tiene numero de obligación debe cruzarme, de lo contrario se debe revisar porque no trae información. 


select*
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info
where Saldo21 is null and obligacion21 is not null


---------------------------Obligación reestructurada 22 -------------------------------------

alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add Saldo22 decimal(18,2)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add TasaEfec22 decimal(11,8)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add TasaMes22 decimal(11,8)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add Plazo22 int

update a
set a.Saldo22=b.NVALSaldoCapital,
    a.TasaEfec22=(b.NPRCTasaActualEfec/100),
    a.TasaMes22=(b.NPRCTasaActualNomi/1200),
    a.Plazo22=b.NNUMPlazo
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info as a left join
      (select* from dwh.dbo.Ca_PRESTAMOS_DEFINITIVOS where NFECCierre='20250831') as b--cierre anterior
on a.Obligacion22=b.ANUMObligacion



----validación 
---obligación1 si tiene numero de obligación debe cruzarme, de lo contrario se debe revisar porque no trae información. 

select*
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info
where Saldo22 is null and obligacion22 is not null


---------------------------Obligación reestructurada 23 -------------------------------------


alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add Saldo23 decimal(18,2)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add TasaEfec23 decimal(11,8)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add TasaMes23 decimal(11,8)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add Plazo23 int



update a
set a.Saldo23=b.NVALSaldoCapital,
    a.TasaEfec23=(b.NPRCTasaActualEfec/100),
    a.TasaMes23=(b.NPRCTasaActualNomi/1200),
    a.Plazo23=b.NNUMPlazo
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info as a left join
      (select* from dwh.dbo.Ca_PRESTAMOS_DEFINITIVOS where NFECCierre='20250831') as b--cierre anterior
on a.Obligacion23=b.ANUMObligacion


----validación 
---obligación1 si tiene numero de obligación debe cruzarme, de lo contrario se debe revisar porque no trae información. 


select*
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info
where Saldo23 is null and obligacion23 is not null


---------------------------Obligación reestructurada 24 -------------------------------------

alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add Saldo24 decimal(18,2)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add TasaEfec24 decimal(11,8)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add TasaMes24 decimal(11,8)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add Plazo24 int



update a
set a.Saldo24=b.NVALSaldoCapital,
    a.TasaEfec24=(b.NPRCTasaActualEfec/100),
    a.TasaMes24=(b.NPRCTasaActualNomi/1200),
    a.Plazo24=b.NNUMPlazo
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info as a left join
      (select* from dwh.dbo.Ca_PRESTAMOS_DEFINITIVOS where NFECCierre='20250831') as b--cierre anterior
on a.Obligacion24=b.ANUMObligacion



----validación 
---obligación1 si tiene numero de obligación debe cruzarme, de lo contrario se debe revisar porque no trae información. 


select*
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info
where Saldo24 is null and obligacion24 is not null


---------------------------Obligación reestructurada 25 -------------------------------------

alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add Saldo25 decimal(18,2)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add TasaEfec25 decimal(11,8)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add TasaMes25 decimal(11,8)
alter table ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info add Plazo25 int



update a
set a.Saldo25=b.NVALSaldoCapital,
    a.TasaEfec25=(b.NPRCTasaActualEfec/100),
    a.TasaMes25=(b.NPRCTasaActualNomi/1200),
    a.Plazo25=b.NNUMPlazo
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info as a left join
      (select* from dwh.dbo.Ca_PRESTAMOS_DEFINITIVOS where NFECCierre='20250831') as b--cierre anterior
on a.Obligacion25=b.ANUMObligacion



----validación 
---obligación1 si tiene numero de obligación debe cruzarme, de lo contrario se debe revisar porque no trae información. 


select*
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info
where Saldo25 is null and obligacion25 is not null


---------------Retenciones le cambio la información de la de definitivos por la q --------------
---------------envia cartera ya que en cartera puede pasar que en el mismo mes le-------------------
---------------hacen la retención y tambien cambia de linea pesos a uvr entonces-------------------
---------------la nueva tasa puede ser mayor y solo se debe tener en cuenta la de la retención----
---------------se confia en la información de cartera---------------------

-----------------ESTO ES DE RETENIDOS----------------------------
--========tasa nueva-autorizada=============


update a
set --a.Saldo=b.NVALSaldoCapital,
    a.TasaEfec=b.Tasa_Autorizada/100,
    a.TasaMes=b.Tasa_Autorizada_Nominal/100
    --a.Plazo=b.NNUMPlazo
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info as a left join
      (select* from ANDREAL.Costo_Amortizado_0011_Retenciones_Acum 
       where Fecha_Corte='20250930') as b--cierre actual el que estamos analizando
on a.Obligacion_Nueva=b.N_Obligacion
where a.Herramienta='Retención'



--valida


select*
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info
where Herramienta='Retención'


--select*
--from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info WHERE Obligacion_Nueva = '0133201071630'

--============tasa anterior-ACTUAL==================

update a
set --a.Saldo=b.NVALSaldoCapital,
    a.TasaEfec1=b.Tasa_Actual /100,
    a.TasaMes1=b.Tasa_Actual_Nominal/100
    --a.Plazo=b.NNUMPlazo
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info as a left join
      (select* from ANDREAL.Costo_Amortizado_0011_Retenciones_Acum 
       where Fecha_Corte='20250930') as b--cierre actual el que estamos analizando
on a.Obligacion_Nueva=b.N_Obligacion
where a.Herramienta='Retención'

--valida

select*
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info
where Herramienta='Retención'

--INCIDENCIA JULIO 2022

--EN EL CASO DE LOS CLIENTES RETENIDOS QUE NO TRAEN INFORMACION DE LA OBLIGACION 1, 
--DADO QUE ES LA MISMA OBLIGACION, SE DEBE HACER LO SIGUIENTE, YA QUE EL CLIENTE CAMBIO LAS CONDICIONES DENTRO DEL MISMO MES

--PASO 1: VALIDACION

select*
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info
where Saldo1 is null --AND HERRAMIENTA ='Modificado' /*'reestructurado'--'Retención'-*/--'Modificado' /* Se debe buscar tambien para las otras herramientas*/
AND Obligacion1 is not NULL

select*
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info
where Saldo1 is null --AND HERRAMIENTA ='Modificado' /*'reestructurado'--'Retención'-*/--'Modificado' /* Se debe buscar tambien para las otras herramientas*/
AND Obligacion1 is NULL

--PASO 2: AL NO EXISTIR AL CIERRE DEL MES ANTERIOR, SE DEBE CONSULTAR EN EL DIARIO EN QUE FECHA LE CAMBIARON LAS CONDICIONES EN EL MES ACTUAL


select NFECModificacion,AINDModificado, acodestadopresta,NFECCIERRE,ANUMIDENPERSO, ANUMOBLIGACION,NVALSaldoCapital,NPRCTasaActualEfec/100,NPRCTasaActualNomi/1200,NNUMPlazo,NfecDesembolso,NfecCancelacion,NPRCTasaActualEfec,NPRCTasaActualNomi
from dwh.dbo.Ca_PRESTAMOS_DIARIO
where NFECCierre BETWEEN '20250901' AND '20250930' 
AND ANUMObligacion in ('0191200048575') --and acodestadopresta='01'--CONDICIONES CAMBIAN EN Marzo 29, POR LO TANTO PODEMOS CRUZARLO CON LA INFO DEL 30 DE DICIEMBRE
--AND ANUMIDENPERSO= '9527088'
ORDER BY NFECCIERRE ASC

select * from [DWH_CC].[HIST].[VHISNovedadModiRees] where ANUMObligacion ='0191200046620'

----------------------------Codigo para consultar obligaciones que no aparecen en la base de prestasmos diarios 

select NFECCIERRE,ANUMIDENPERSO, ANUMOBLIGACION,NVALSaldoCapital,NPRCTasaActualEfec/100,NPRCTasaActualNomi/1200,NNUMPlazo,NfecDesembolso,NfecCancelacion,NPRCTasaActualEfec,NPRCTasaActualNomi
from [DWH].[dbo].[CA_Prestamos_Definitivos]
where NFECCierre BETWEEN '20250501' AND '20250731' 
AND ANUMObligacion in ('0134200324048')--CONDICIONES CAMBIAN EN Marzo 29, POR LO TANTO PODEMOS CRUZARLO CON LA INFO DEL 30 DE DICIEMBRE
--AND ANUMIDENPERSO= '9527088'
ORDER BY NFECCIERRE ASC

--PASO 3: HACEMOS UPDATE DE LOS 3 CASOS PARA TRAER LA INFO ANTERIOR DE LA MISMA OBLIGACIÓN CON LAS FECHAS QUE DIJIMOS ANTES

---CUANDO ES UN MODFICADO INDIVIDUAL DE UNA OBLIGACION DIF---
update a
set a.Saldo1=b.NVALSaldoCapital,
    a.TasaEfec1=b.NPRCTasaActualEfec/100,
    a.TasaMes1=b.NPRCTasaActualNomi/1200,
    a.Plazo1=b.NNUMPlazo,
	a.Tipo_obligacion='Diferente Obligación',
	a.Obligacion1='0191200048575'
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info as a left join
      (select* from dwh.dbo.Ca_PRESTAMOS_DIARIO where NFECCierre='20250904' ) as b--cierre anterior al que estamos trabajando
on A.Numero_Id=B.ANUMIDENPERSO
where a.Obligacion_Nueva = '0191200048575'

update a
set a.Saldo1=b.NVALSaldoCapital,
    a.TasaEfec1=b.NPRCTasaActualEfec/100,
    a.TasaMes1=b.NPRCTasaActualNomi/1200,
    a.Plazo1=b.NNUMPlazo
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info as a left join
      (select* from dwh.dbo.Ca_PRESTAMOS_DIARIO where NFECCierre='20250901' ) as b--cierre anterior al que estamos trabajando
on /*a.Obligacion_Nueva=b.ANUMObligacion*/A.Numero_Id=B.ANUMIDENPERSO
where a.Obligacion1 = '0134200315811'



update a
set a.Saldo1=b.NVALSaldoCapital,
    a.TasaEfec1=b.NPRCTasaActualEfec/100,
    a.TasaMes1=b.NPRCTasaActualNomi/1200,
    a.Plazo1=b.NNUMPlazo
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info as a left join
      (select* from dwh.dbo.Ca_PRESTAMOS_DIARIO where NFECCierre='20250829') as b--cierre anterior al que estamos trabajando
on a.Obligacion_Nueva=b.ANUMObligacion
where a.Obligacion_Nueva = '0191200048525'

select * from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info  where Tipo_Obligacion='Misma Obligación' and Tipo_Herramienta='Individual' and  Obligacion_Nueva = '5406950067989728'

update a
set a.Saldo1=b.NVALSaldoCapital,
    a.TasaEfec1=b.NPRCTasaActualEfec/100,
    a.TasaMes1=b.NPRCTasaActualNomi/1200,
    a.Plazo1=b.NNUMPlazo
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info as a left join
      (select* from dwh.dbo.Ca_PRESTAMOS_DIARIO where NFECCierre='20250228') as b--cierre anterior al que estamos trabajando
on a.Obligacion1=b.ANUMObligacion
where a.Obligacion1 = '0133201216368'


update a
set a.Saldo2=b.NVALSaldoCapital,
    a.TasaEfec2=b.NPRCTasaActualEfec/100,
    a.TasaMes2=b.NPRCTasaActualNomi/1200,
    a.Plazo2=b.NNUMPlazo
from ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info as a left join
      (select* from dwh.dbo.Ca_PRESTAMOS_DIARIO where NFECCierre='20250224') as b--cierre anterior al que estamos trabajando
on a.Obligacion2=b.ANUMObligacion
where a.Obligacion2 = '4570221061550756'




--PASO 4: SE VALIDA QUE SE HAYA COMPLETADO LA INFO
-------ValiDACIÓN 1 PARA CEDULA

Select* From ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info
Where Tipo_Id  IS NULL AND Numero_Id IS NULL AND Modalidad IS NULL 

-------ValiDACIÓN 2 PARA SALDOS
Select* From ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info      
Where Saldo  IS NULL AND TasaEfec IS NULL AND TasaMes IS NULL AND Plazo IS NULL

-------ValiDACIÓN 3 PARA SALDOS

Select* From ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info      
Where Saldo1  IS NULL AND TasaEfec1 IS NULL AND TasaMes1 IS NULL AND Plazo1 IS NULL  and Obligacion1 is not null

-------ValiDACIÓN 4 PARA SALDOS
Select* From ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info      
Where Obligacion2 IS NOT NULL AND Saldo2  IS NULL AND TasaEfec2 IS NULL AND TasaMes2 IS NULL AND Plazo2 IS NULL

-------ValiDACIÓN 5 PARA SALDOS
Select* From ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info      
Where Obligacion3 IS NOT NULL AND Saldo3  IS NULL AND TasaEfec3 IS NULL AND TasaMes3 IS NULL AND Plazo3 IS NULL

-------ValiDACIÓN 6 PARA SALDOS
Select* From ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info      
Where Obligacion4 IS NOT NULL AND Saldo4  IS NULL AND TasaEfec4 IS NULL AND TasaMes4 IS NULL AND Plazo4 IS NULL


--****************************************************************************

------------------------guardarla en la base total---------------------------

INSERT INTO ANDREAL.Costo_Amortizado_004_BaseTotal_Acum_Info
SELECT*
FROM ANDREAL.Costo_Amortizado_003_BaseTotal_Mes_Info


--Validación

select Fecha_Corte,COUNT(*)
from ANDREAL.Costo_Amortizado_004_BaseTotal_Acum_Info
group by Fecha_Corte
order by Fecha_Corte Desc

---==================================================================================================
--------------------seleccionar elcorte que estoy trabajando para llevar al excel
---------------------donde se realiza el calculo de la perdida o ganancia con las variables que 
----------------------ya se recolectaron saldos, tasas y plazos

SELECT *
FROM ANDREAL.Costo_Amortizado_004_BaseTotal_Acum_Info
where Fecha_Corte='20250930'---cambiar fecha por la que estoy trabajando

select * from ANDREAL.Costo_Amortizado_004_BaseTotal_Acum_Info where Numero_Id = '40328599'

select NVALSaldoCapital,NPRCTasaDesemEfec, NPRCTasaActualNomi,	NPRCTasaActualEfec,NPRCTasaActualNomi,NPRCTasaActualEfec, * 
from DWH.dbo.CA_prestamos_definitivos WHERE ANUMObligacion = '0134200324048' AND NFECCierre = '20250930'
select NVALSaldoCapital,NPRCTasaDesemEfec, NPRCTasaActualNomi,	NPRCTasaActualEfec, * from DWH.dbo.CA_prestamos_Diario WHERE ANUMObligacion = '0134200324048' AND NFECCierre = '20251022'

--delete  ANDREAL.Costo_Amortizado_004_BaseTotal_Acum_Info where  Obligacion_Nueva = '0191200015164' and Fecha_Corte = '2022131'

--## PARA ELIMINAR REGISTROS REPETIDOS NO IDENTIFIACADOS EN PASOS ANTERIORES ##--

/*WITH CTE AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY Obligacion_Nueva ORDER BY (SELECT NULL)) AS RowNum
    FROM 
        --ANDREAL.Costo_Amortizado_001_Reestructurados_Acum--> Cambiar nombre de tabla en donde se desea elminar registro
    WHERE 
        Fecha_Corte = '20250228' AND Obligacion_Nueva = '30024196915'--> Cambiar obligacion y fecha de corte
)
--DELETE FROM CTE
WHERE RowNum > 1;*/