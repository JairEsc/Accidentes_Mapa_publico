setwd("C:/Users/SIGEH/Desktop/Lalo/Gob/Proyectos")

datos = sf::read_sf("Accidentes_Mapa/Datos/Sin filtrar/2021_shp/ATUS_2021/conjunto_de_datos/BASE MUNICIPAL_ACCIDENTES DE TRANSITO GEORREFERENCIADOS_2021.shp")
datos$vehiculos_invol = apply(datos |> sf::st_drop_geometry() |> dplyr::select(AUTOMOVIL:BICICLETA),MARGIN = 1,FUN=function(row){
  names_reng=names(row)
  cadena_final=''
  for(id in 1:12){
    val=row[id]
    if(val!=0){
      cadena_final=paste0(cadena_final,val," ",names_reng[id]," ")
    }
  }
  return(cadena_final)
})
datos = datos |> dplyr::select(TIPACCID, CLASE, ANIO, MES, DIA, HORA, MINUTOS, EDO, MPIO, SEXO, EDAD, CAUSAACCI, DIASEMANA, vehiculos_invol, TOTMUERTOS, TOTHERIDOS, CONDMUERTO, CONDHERIDO) |> dplyr::filter(EDO == 13)

tipaccid_correcion = function(str) {
  return(switch(as.character(str),
                "0" = "Certificado cero",
                "1" = "Colisión con vehículo automotor",
                "2" = "Colisión con peatón (atropellamiento)",
                "3" = "Colisión con animal",
                "4" = "Colisión con objeto fijo",
                "5" = "Volcadura",
                "6" = "Caída de pasajero",
                "7" = "Salida del camino",
                "8" = "Incendio",
                "9" = "Colisión con ferrocarril",
                "10" = "Colisión con motocicleta",
                "11" = "Colisión con ciclista",
                "12" = "Otro",
                str  # valor por defecto si no hay coincidencia
  ))
}
clase_correcion = function(str) {
  return(switch(as.character(str),
                "1" = "Fatal",
                "2" = "No fatal",
                "3" = "Sólo daños",
                str  # valor por defecto si no hay coincidencia
  ))
}
edo_correcion = function(str) {
  return(switch(as.character(str),
                "13" = "Hidalgo",
                str  # valor por defecto si no hay coincidencia
  ))
}
sexo_correcion = function(str) {
  return(switch(as.character(str),
                "1" = "Se fugó",
                "2" = "Hombre",
                "3" = "Mujer",
                str  # valor por defecto si no hay coincidencia
  ))
}
causaacci_correcion = function(str) {
  return(switch(as.character(str),
                "1" = "Conductor",
                "2" = "Peatón o pasajero",
                "3" = "Falla del vehículo",
                "4" = "Mala condición del camino",
                "5" = "Otra",
                str  # valor por defecto si no hay coincidencia
  ))
}
dia_semanal = function(str) {
  return(switch(as.character(str),
                "1" = "Lunes",
                "2" = "Martes",
                "3" = "Miércoles",
                "4" = "Jueves",
                "5" = "Viernes",
                "6" = "Sábado",
                "7" = "Domingo",
                str  # valor por defecto si no hay coincidencia
  ))
}


datos$TIPACCID = sapply(datos$TIPACCID, tipaccid_correcion, simplify = T, USE.NAMES = F)
datos$CLASE = sapply(datos$CLASE, clase_correcion, simplify = T, USE.NAMES = F)
datos$EDO = sapply(datos$EDO, edo_correcion, simplify = T, USE.NAMES = F)
datos$SEXO = sapply(datos$SEXO, sexo_correcion, simplify = T, USE.NAMES = F)
datos$CAUSAACCI = sapply(datos$CAUSAACCI, causaacci_correcion, simplify = T, USE.NAMES = F)
datos$DIASEMANA = sapply(datos$DIASEMANA, dia_semanal, simplify = T, USE.NAMES = F)

mun = sf::read_sf("../Importantes_documentos_usar/Municipios/municipiosjair.shp")
mun = mun |> dplyr::select(CVE_MUN, NOM_MUN) |> sf::st_drop_geometry()

datos = merge(x = datos |> dplyr::mutate(MPIO = as.numeric(MPIO)) , y = mun |> dplyr::mutate(CVE_MUN = as.numeric(CVE_MUN)), by.x = "MPIO", by.y = "CVE_MUN")

datos = datos |> dplyr::select(TIPACCID, CLASE, ANIO, MES, DIA, HORA, MINUTOS, EDO, NOM_MUN, SEXO, EDAD, CAUSAACCI, DIASEMANA, vehiculos_invol, TOTMUERTOS, TOTHERIDOS, CONDMUERTO, CONDHERIDO) |>
  dplyr::arrange(ANIO, MES, DIA, HORA, MINUTOS)

sf::st_write(datos, "Accidentes_Mapa/Datos/Filtrados/2021/2021.geojson", driver = "GeoJSON")
sf::st_write(datos, "../../../Monse/Accidentes/2021/2021.shp")

### 2022

datos = sf::read_sf("Accidentes_Mapa/Datos/Sin filtrar/2022_shp/conjunto_de_datos/BASE MUNICIPAL_ACCIDENTES DE TRANSITO GEORREFERENCIADOS_2022.shp")
datos$vehiculos_invol = apply(datos |> sf::st_drop_geometry() |> dplyr::select(AUTOMOVIL:BICICLETA),MARGIN = 1,FUN=function(row){
  names_reng=names(row)
  cadena_final=''
  for(id in 1:12){
    val=row[id]
    if(val!=0){
      cadena_final=paste0(cadena_final,val," ",names_reng[id]," ")
    }
  }
  return(cadena_final)
})
datos = datos |> dplyr::select(TIPACCID, CLASE, ANIO, MES, DIA, HORA, MINUTOS, EDO, MPIO, SEXO, EDAD, CAUSAACCI, DIASEMANA, vehiculos_invol, TOTMUERTOS, TOTHERIDOS, CONDMUERTO, CONDHERIDO) |> dplyr::filter(EDO == 13)

datos$TIPACCID = sapply(datos$TIPACCID, tipaccid_correcion, simplify = T, USE.NAMES = F)
datos$CLASE = sapply(datos$CLASE, clase_correcion, simplify = T, USE.NAMES = F)
datos$EDO = sapply(datos$EDO, edo_correcion, simplify = T, USE.NAMES = F)
datos$SEXO = sapply(datos$SEXO, sexo_correcion, simplify = T, USE.NAMES = F)
datos$CAUSAACCI = sapply(datos$CAUSAACCI, causaacci_correcion, simplify = T, USE.NAMES = F)
datos$DIASEMANA = sapply(datos$DIASEMANA, dia_semanal, simplify = T, USE.NAMES = F)

mun = sf::read_sf("../Importantes_documentos_usar/Municipios/municipiosjair.shp")
mun = mun |> dplyr::select(CVE_MUN, NOM_MUN) |> sf::st_drop_geometry()

datos = merge(x = datos |> dplyr::mutate(MPIO = as.numeric(MPIO)) , y = mun |> dplyr::mutate(CVE_MUN = as.numeric(CVE_MUN)), by.x = "MPIO", by.y = "CVE_MUN")

datos = datos |> dplyr::select(TIPACCID, CLASE, ANIO, MES, DIA, HORA, MINUTOS, EDO, NOM_MUN, SEXO, EDAD, CAUSAACCI, DIASEMANA, vehiculos_invol, TOTMUERTOS, TOTHERIDOS, CONDMUERTO, CONDHERIDO) |>
  dplyr::arrange(ANIO, MES, DIA, HORA, MINUTOS)

sf::st_write(datos, "Accidentes_Mapa/Datos/Filtrados/2022/2022.geojson", driver = "GeoJSON")
sf::st_write(datos, "../../../Monse/Accidentes/2022/2022.shp")

### 2023
setwd("C:/Users/SIGEH/Desktop/Lalo/Gob/Proyectos")

datos = sf::read_sf("Accidentes_Mapa/Datos/Sin filtrar/2023_shp/conjunto_de_datos/BASE MUNICIPAL_ACCIDENTES DE TRANSITO GEORREFERENCIADOS_2023.shp")
datos$vehiculos_invol = apply(datos |> sf::st_drop_geometry() |> dplyr::select(AUTOMOVIL:BICICLETA),MARGIN = 1,FUN=function(row){
  names_reng=names(row)
  cadena_final=''
  for(id in 1:12){
    val=row[id]
    if(val!=0){
      cadena_final=paste0(cadena_final,val," ",names_reng[id]," ")
    }
  }
  return(cadena_final)
})
datos = datos |> dplyr::select(TIPACCID, CLASE, ANIO, MES, DIA, HORA, MINUTOS, EDO, MPIO, SEXO, EDAD, CAUSAACCI, DIASEMANA, vehiculos_invol, TOTMUERTOS, TOTHERIDOS, CONDMUERTO, CONDHERIDO) |> dplyr::filter(EDO == 13)

datos$TIPACCID = sapply(datos$TIPACCID, tipaccid_correcion, simplify = T, USE.NAMES = F)
datos$CLASE = sapply(datos$CLASE, clase_correcion, simplify = T, USE.NAMES = F)
datos$EDO = sapply(datos$EDO, edo_correcion, simplify = T, USE.NAMES = F)
datos$SEXO = sapply(datos$SEXO, sexo_correcion, simplify = T, USE.NAMES = F)
datos$CAUSAACCI = sapply(datos$CAUSAACCI, causaacci_correcion, simplify = T, USE.NAMES = F)
datos$DIASEMANA = sapply(datos$DIASEMANA, dia_semanal, simplify = T, USE.NAMES = F)

mun = sf::read_sf("../Importantes_documentos_usar/Municipios/municipiosjair.shp")
mun = mun |> dplyr::select(CVE_MUN, NOM_MUN) |> sf::st_drop_geometry()

datos = merge(x = datos |> dplyr::mutate(MPIO = as.numeric(MPIO)) , y = mun |> dplyr::mutate(CVE_MUN = as.numeric(CVE_MUN)), by.x = "MPIO", by.y = "CVE_MUN")

datos = datos |> dplyr::select(TIPACCID, CLASE, ANIO, MES, DIA, HORA, MINUTOS, EDO, NOM_MUN, SEXO, EDAD, CAUSAACCI, DIASEMANA, vehiculos_invol, TOTMUERTOS, TOTHERIDOS, CONDMUERTO, CONDHERIDO) |>
  dplyr::arrange(ANIO, MES, DIA, HORA, MINUTOS)

datos = datos[- 2076, ]

sf::st_write(datos, "Accidentes_Mapa/Datos/Filtrados/2023/2023.geojson", driver = "GeoJSON")
sf::st_write(datos, "../../../Monse/Accidentes/2023/2023.shp")

##############
### Puntos ###
##############

# 2021
datos = sf::read_sf("Accidentes_Mapa/Datos/Sin filtrar/2021_shp/ATUS_2021/conjunto_de_datos/BASE MUNICIPAL_ACCIDENTES DE TRANSITO GEORREFERENCIADOS_2021.shp")
datos = datos |> dplyr::filter(EDO == 13) |> dplyr::select(LATITUD, LONGITUD) |> sf::st_drop_geometry()
datos$interes = paste0("[", datos$LATITUD, ",", datos$LONGITUD, "]")
write.csv(datos, "Accidentes_Mapa/Datos/Filtrados/2021/2021_puntos.csv", fileEncoding = "UTF-8", row.names = F)


# 2022
datos = sf::read_sf("Accidentes_Mapa/Datos/Sin filtrar/2022_shp/conjunto_de_datos/BASE MUNICIPAL_ACCIDENTES DE TRANSITO GEORREFERENCIADOS_2022.shp")
datos = datos |> dplyr::filter(EDO == 13) |> dplyr::select(LATITUD, LONGITUD) |> sf::st_drop_geometry()
datos$interes = paste0("[", datos$LATITUD, ",", datos$LONGITUD, "]")
write.csv(datos, "Accidentes_Mapa/Datos/Filtrados/2022/2022_puntos.csv", fileEncoding = "UTF-8", row.names = F)

# 2023
datos = sf::read_sf("Accidentes_Mapa/Datos/Sin filtrar/2023_shp/conjunto_de_datos/BASE MUNICIPAL_ACCIDENTES DE TRANSITO GEORREFERENCIADOS_2023.shp")
datos = datos |> dplyr::filter(EDO == 13) |> dplyr::select(LATITUD, LONGITUD) |> sf::st_drop_geometry()
datos$interes = paste0("[", datos$LATITUD, ",", datos$LONGITUD, "]")
write.csv(datos, "Accidentes_Mapa/Datos/Filtrados/2023/2023_puntos.csv", fileEncoding = "UTF-8", row.names = F)

























##########
### C5 ###
##########


## Filtracion
datos = sf::read_sf("Accidentes_Mapa/Datos/Sin filtrar/2025_C5/siniestros_bien.shp")
datos$EDO = "Hidalgo"

datos$TOTMUERTOS = datos |> dplyr::select(CONDMUE,PASAMUE,PEATMUE,CICLMUE,OTROMUE) |> sf::st_drop_geometry() |> rowSums(na.rm = T)
datos$TOTHERIDOS = datos |> dplyr::select(CONDHER,PASAHER,PEATONH,CICLHER,OTROHER) |> sf::st_drop_geometry() |> rowSums(na.rm = T)
datos$CONDMUE[is.na(datos$CONDMUE)] = 0
datos$CONDHER[is.na(datos$CONDHER)] = 0
datos$TIPACCI = datos$TIPACCI |> stringr::str_squish()


datos = datos |> dplyr::select(ID,TIPACCI, CLASACC, AÑO, MES, DIA, ID_HORA, ID_MINU, EDO, ID_MUNI, SEXO, ID_EDAD, CAUSAAC, DIASEMA, TOTMUERTOS, TOTHERIDOS, CONDMUE, CONDHER) |>
  dplyr::arrange(AÑO, MES, DIA, ID_HORA, ID_MINU)

colnames(datos) = c("ID","TIPACCID", "CLASE", "ANIO", "MES", "DIA", "HORA", "MINUTOS", "EDO", "NOM_MUN", "SEXO", "EDAD", "CAUSAACCI", "DIASEMANA", "TOTMUERTOS", "TOTHERIDOS", "CONDMUERTO", "CONDHERIDO", "geometry")
datos = datos |>  dplyr::mutate(CLASE=ifelse( TOTHERIDOS > 0 & TOTMUERTOS ==0, 'No fatal', ifelse(TOTMUERTOS >0,"Fatal",'Sólo daños')))
datos[is.na(datos)] = 0


sf::st_write(datos, "Accidentes_Mapa/Datos/Filtrados/2025_C5/2025.geojson", driver = "GeoJSON")
sf::write_sf(datos, "Accidentes_Mapa/Datos/Filtrados/2025_C5/2025.shp")
sf::st_write(datos, "../../../Monse/Accidentes/2025/2025.shp")








## Puntos
datos = sf::read_sf("Accidentes_Mapa/Datos/Sin filtrar/2025_C5/siniestros_bien.shp")
datos = datos |> dplyr::select(Y,X) |> sf::st_drop_geometry()
datos$interes = paste0("[", datos$Y, ",", datos$X, "]")
write.csv(datos, "Accidentes_Mapa/Datos/Filtrados/2025_C5/2025_puntos.csv", fileEncoding = "UTF-8", row.names = F)






p = sf::read_sf("Accidentes_Mapa/Datos/Filtrados/2025_C5/2025.shp")
