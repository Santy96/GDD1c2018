USE [GDDPrueba7]
GO
/****** Object:  Schema [gd_esquema]    Script Date: 12/04/2018 22:36:24 ******/
CREATE SCHEMA GDDATR
GO

--/ CREACION DE TABLAS /--
--BEGIN TRY

CREATE TABLE GDDATR.Rol(rol_id int identity PRIMARY KEY,
						rol_descripcion varchar(100) UNIQUE,
						rol_estado bit DEFAULT 1 NOT NULL)

CREATE TABLE GDDATR.Funcionalidad(func_id int identity PRIMARY KEY,
								  func_nombre char(100) NOT NULL,
								  func_descripcion varchar(100))

CREATE TABLE GDDATR.FuncionalidadxRol(fxr_id int identity PRIMARY KEY,
									  fxr_funcionalidad int FOREIGN KEY references GDDATR.Funcionalidad(func_id),
									  fxr_rol int FOREIGN KEY references GDDATR.Rol(rol_id),
									  fxr_descripcion char(100))

CREATE TABLE GDDATR.Usuario(usua_username char(100) PRIMARY KEY,
							usua_password char(100) NOT NULL,
							usua_rol int FOREIGN KEY references GDDATR.Rol(rol_id),
							usua_nombre char(100),
							usua_apellido char(100),
							usua_tipo_doc char(100),
							usua_numero_doc int,
							usua_mail char(100),
							usua_telefono int,
							usua_direccion char(100),
							usua_fecha_nac date)

CREATE TABLE GDDATR.Estado(esta_id int identity PRIMARY KEY,
						   esta_fecha_inicio date NOT NULL,
						   esta_fecha_fin date NOT NULL)

CREATE TABLE GDDATR.Hotel(hote_id int identity PRIMARY KEY, /*AutoIncremental?*/
						  hote_nombre varchar(100),
						  hote_mail varchar(100),
						  hote_telefono int,
						  hote_calle nvarchar(255) NOT NULL,
						  hote_nro_calle numeric NOT NULL,
						  hote_cant_estrellas numeric NOT NULL,
						  hote_recarga_estrella numeric NOT NULL,
						  hote_ciudad nvarchar(255) NOT NULL,
						  hote_pais char(100),
						  hote_fecha_creacion date,
						  hote_estado int FOREIGN KEY references GDDATR.Estado(esta_id))

CREATE TABLE GDDATR.UsuarioXHotel(uxh_id int identity PRIMARY KEY,
								  uxh_usuario char(100) FOREIGN KEY references GDDATR.Usuario(usua_username),
								  uxh_hotel int FOREIGN KEY references GDDATR.Hotel(hote_id))

CREATE TABLE GDDATR.Habitacion_Tipo(htip_codigo numeric PRIMARY KEY,
									htip_descripcion nvarchar(255) NOT NULL,
									htip_porcentual numeric NOT NULL)

CREATE TABLE GDDATR.Habitacion(habi_id int identity PRIMARY KEY,
							   habi_numero numeric NOT NULL,
							   habi_piso numeric NOT NULL,
							   habi_ubicacion nvarchar(1) NOT NULL,
							   habi_tipo numeric FOREIGN KEY references GDDATR.Habitacion_Tipo(htip_codigo),
							   habi_descripcion varchar(100),
							   habi_hotel int FOREIGN KEY references GDDATR.Hotel(hote_id),
							   habi_comodidades varchar(100),
							   habi_estado int FOREIGN KEY references GDDATR.Estado(esta_id))

CREATE TABLE GDDATR.Regimen(regi_id int identity PRIMARY KEY,
							regi_descripcion nvarchar(255) NOT NULL,
							regi_precio_base numeric NOT NULL,
							regi_estado bit DEFAULT 1 NOT NULL)

CREATE TABLE GDDATR.HotelXRegimen(hxr_id int identity PRIMARY KEY,
								  hxr_regimen int FOREIGN KEY references GDDATR.Regimen(regi_id),
								  hxr_hotel int FOREIGN KEY references GDDATR.Hotel(hote_id))

CREATE TABLE GDDATR.Cliente(clie_id int identity PRIMARY KEY,
							clie_tipo_doc char(100) DEFAULT 'Pasaporte' NOT NULL,
							clie_numero_doc numeric NOT NULL,
							clie_nombre nvarchar(255) NOT NULL,
							clie_apellido nvarchar(255) NOT NULL,
							clie_mail nvarchar(255) NOT NULL,
							clie_telefono int,
							clie_domcalle nvarchar(255) NOT NULL, /*Se puede juntar en un unico campo direccion?*/
							clie_domnum numeric NOT NULL,
							clie_dompiso numeric NOT NULL,
							clie_domdepto nvarchar(1) NOT NULL,
							clie_domloc char(100),
							clie_dompais char(100),
							clie_nacionalidad nvarchar(255) NOT NULL,
							clie_fecha_nac datetime NOT NULL)

CREATE TABLE GDDATR.Reserva(rese_codigo numeric PRIMARY KEY,
							rese_fecha_creacion date DEFAULT GetDate() NOT NULL, /*Cambiar el default*/
							rese_fecha_inicio datetime NOT NULL,
							rese_cant_noches numeric NOT NULL,
							rese_fecha_fin datetime,
							rese_estado char(100),
							rese_cliente int FOREIGN KEY references GDDATR.Cliente(clie_id),
							rese_regimen int FOREIGN KEY references GDDATR.Regimen(regi_id))

CREATE TABLE GDDATR.ReservaXHabitacion(rxh_id int identity PRIMARY KEY,
									   rxh_habitacion int FOREIGN KEY references GDDATR.Habitacion(habi_id),
									   rxh_reserva numeric FOREIGN KEY references GDDATR.Reserva(rese_codigo))

CREATE TABLE GDDATR.Estadia(estd_id int identity PRIMARY KEY,
							estd_fecha_inicio datetime NOT NULL,
							estd_cant_noches numeric NOT NULL,
							estd_reserva numeric FOREIGN KEY references GDDATR.Reserva(rese_codigo),
							estd_fecha_fin date DEFAULT GetDate() NOT NULL) /*Cambiar el default*/

CREATE TABLE GDDATR.Reserva_Cancelada(rcan_id int identity PRIMARY KEY,
									  rcan_reserva numeric FOREIGN KEY references GDDATR.Reserva(rese_codigo),
									  rcan_motivo varchar(100),
									  rcan_usuario char(100) FOREIGN KEY references GDDATR.Usuario(usua_username),
									  rcan_fecha date DEFAULT GetDate() NOT NULL) /*Cambiar el default*/

CREATE TABLE GDDATR.Factura(fact_id int identity PRIMARY KEY,
							fact_nro numeric NOT NULL,
							fact_fecha datetime NOT NULL, /*Cambiar el default*/
							fact_total numeric NOT NULL)

CREATE TABLE GDDATR.Consumible(cons_codigo numeric PRIMARY KEY,
							   cons_precio numeric NOT NULL,
							   cons_descripcion nvarchar(255) NOT NULL)

CREATE TABLE GDDATR.Item_Factura(item_id int identity PRIMARY KEY,
								 item_factura int FOREIGN KEY references GDDATR.Factura(fact_id),
								 item_cantidad numeric NOT NULL,
								 item_descripcion varchar(100),
								 item_esConsumible bit NOT NULL,
								 item_monto numeric NOT NULL,
								 item_estadia numeric FOREIGN KEY references GDDATR.Reserva(rese_codigo),
								 item_consumible numeric FOREIGN KEY references GDDATR.Consumible(cons_codigo))

CREATE TABLE GDDATR.Reparacion(repa_id int identity PRIMARY KEY,
							   repa_hotel int FOREIGN KEY references GDDATR.Hotel(hote_id),
							   repa_fecha_inicio date NOT NULL,
							   repa_fecha_fin date NOT NULL,
							   repa_descripcion varchar(100))

--/ MIGRACION DE LA TABLA MAESTRA /--

INSERT INTO GDDATR.Hotel(hote_ciudad, hote_calle, hote_nro_calle, hote_cant_estrellas, hote_recarga_estrella)
	SELECT DISTINCT Hotel_Ciudad, Hotel_Calle, Hotel_Nro_Calle, Hotel_CantEstrella, Hotel_Recarga_Estrella
	FROM gd_esquema.Maestra

INSERT INTO GDDATR.Habitacion_Tipo(htip_codigo, htip_descripcion, htip_porcentual)
	SELECT DISTINCT Habitacion_Tipo_Codigo, Habitacion_Tipo_Descripcion, Habitacion_Tipo_Porcentual
	FROM gd_esquema.Maestra

INSERT INTO GDDATR.Habitacion(habi_numero, habi_piso, habi_ubicacion, habi_hotel)
	SELECT DISTINCT Habitacion_Numero, Habitacion_Piso, Habitacion_Frente, (SELECT TOP 1 hote_id FROM GDDATR.Hotel WHERE M.Hotel_Ciudad = hote_ciudad AND M.Hotel_Calle = hote_calle AND M.Hotel_Nro_Calle = hote_nro_calle AND M.Hotel_CantEstrella = hote_cant_estrellas AND M.Hotel_Recarga_Estrella = hote_recarga_estrella)
	FROM gd_esquema.Maestra as M

INSERT INTO GDDATR.Regimen(regi_descripcion, regi_precio_base)
	SELECT DISTINCT Regimen_Descripcion, Regimen_Precio
	FROM gd_esquema.Maestra

INSERT INTO GDDATR.HotelXRegimen(hxr_hotel, hxr_regimen)
	SELECT (SELECT TOP 1 hote_id FROM GDDATR.Hotel WHERE M.Hotel_Calle = hote_calle AND M.Hotel_Nro_Calle = hote_nro_calle AND M.Hotel_Ciudad = hote_ciudad), (SELECT regi_id FROM GDDATR.Regimen WHERE M.Regimen_Descripcion = regi_descripcion AND M.Regimen_Precio = regi_precio_base)
	FROM (SELECT DISTINCT Hotel_Calle, Hotel_Nro_Calle, Hotel_Ciudad, Regimen_Descripcion, Regimen_Precio FROM gd_esquema.Maestra) as M

INSERT INTO GDDATR.Cliente(clie_numero_doc, clie_apellido, clie_nombre, clie_fecha_nac, clie_mail, clie_domcalle, clie_domnum, clie_dompiso, clie_domdepto, clie_nacionalidad)
	SELECT DISTINCT Cliente_Pasaporte_Nro, Cliente_Apellido, Cliente_Nombre, Cliente_Fecha_Nac, Cliente_Mail, Cliente_Dom_Calle, Cliente_Nro_Calle, Cliente_Piso, Cliente_Depto, Cliente_Nacionalidad
	FROM gd_esquema.Maestra

INSERT INTO GDDATR.Reserva(rese_codigo, rese_fecha_inicio, rese_cant_noches, rese_cliente, rese_regimen)
	SELECT DISTINCT Reserva_Codigo, Reserva_Fecha_Inicio, Reserva_Cant_Noches, (SELECT clie_id FROM GDDATR.Cliente WHERE M.Cliente_Pasaporte_Nro = clie_numero_doc AND clie_tipo_doc = 'Pasaporte' AND M.Cliente_Apellido = clie_apellido AND M.Cliente_Nombre = clie_nombre AND M.Cliente_Nacionalidad = clie_nacionalidad), (SELECT regi_id FROM GDDATR.Regimen WHERE M.Regimen_Descripcion = regi_descripcion AND M.Regimen_Precio = regi_precio_base) 
	FROM gd_esquema.Maestra as M

INSERT INTO GDDATR.ReservaXHabitacion(rxh_habitacion, rxh_reserva)
	SELECT (SELECT TOP 1 habi_id FROM GDDATR.Habitacion JOIN GDDATR.Hotel ON(habi_hotel = hote_id) JOIN GDDATR.Habitacion_Tipo ON (habi_tipo = htip_codigo) WHERE M.Habitacion_Numero = habi_numero AND Habitacion_Frente = habi_ubicacion AND Habitacion_Piso = habi_piso AND M.Habitacion_Tipo_Codigo = habi_tipo AND M.Hotel_Calle = hote_calle AND M.Hotel_Nro_Calle = hote_nro_calle AND M.Hotel_Ciudad = hote_ciudad), Reserva_Codigo
	FROM (SELECT DISTINCT Reserva_Codigo, Habitacion_Frente, Habitacion_Numero, Habitacion_Piso, Habitacion_Tipo_Codigo, Hotel_Calle, Hotel_Ciudad, Hotel_Nro_Calle FROM gd_esquema.Maestra) as M

INSERT INTO GDDATR.Estadia(estd_fecha_inicio, estd_cant_noches, estd_reserva)
	SELECT DISTINCT Estadia_Fecha_Inicio, Estadia_Cant_Noches, Reserva_Codigo
	FROM gd_esquema.Maestra WHERE Estadia_Fecha_Inicio IS NOT NULL AND Estadia_Cant_Noches IS NOT NULL

INSERT INTO GDDATR.Factura(fact_nro, fact_fecha, fact_total)
	SELECT DISTINCT Factura_Nro, Factura_Fecha, Factura_Total
	FROM gd_esquema.Maestra

INSERT INTO GDDATR.Consumible(cons_codigo, cons_descripcion, cons_precio)
	SELECT DISTINCT Consumible_Codigo, Consumible_Descripcion, Consumible_Precio
	FROM gd_esquema.Maestra

INSERT INTO GDDATR.Item_Factura(item_cantidad, item_monto, item_factura, item_consumible, item_esConsumible)
	SELECT Item_Factura_Cantidad, Item_Factura_Monto, (SELECT fact_id FROM GDDATR.Factura WHERE M.Factura_Nro = fact_nro AND M.Factura_Fecha = fact_fecha), Consumible_Codigo, 1
	FROM gd_esquema.Maestra as M
	WHERE Consumible_Codigo IS NOT NULL

INSERT INTO GDDATR.Item_Factura(item_cantidad, item_monto, item_factura, item_estadia, item_esConsumible)
	SELECT Item_Factura_Cantidad, Item_Factura_Monto, (SELECT fact_id FROM GDDATR.Factura WHERE M.Factura_Nro = fact_nro AND M.Factura_Fecha = fact_fecha), (SELECT estd_id FROM GDDATR.Estadia WHERE estd_reserva = M.Reserva_Codigo) , 0
	FROM gd_esquema.Maestra as M
	WHERE Consumible_Codigo IS NULL AND Item_Factura_Monto IS NOT NULL