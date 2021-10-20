


require(pacman)
p_load(leaflet,leaflet.extras,mapview,questionr,janitor,leafem,rgdal,raster,plyr,dplyr,
       data.table,readr,
       tidyverse,htmltools,htmlwidgets,mapview,sp,sf,readxl,BAMMtools)

conAguaCol <- fread("/home/jfractal/Documentos/dataton_2021/dataton_AGUA_2021/consumoAguaColonia2.csv")
cdmx_shp <- readOGR("/home/jfractal/Documentos/Trabajos R/alcaldias_CDMX/alcaldias.shp")


getJenksBreaks(conAguaCol$consumo_total, 4)##Calculamos rupturas Jenks para la escala de consumo

conAguaCol$rango <- ifelse(conAguaCol$consumo_total <=175729, "Bajo",
                    ifelse(conAguaCol$consumo_total >175729 & conAguaCol$consumo_total <=710590, "Medio",
                    ifelse(conAguaCol$consumo_total >710590 & conAguaCol$consumo_total <=2976649, "Alto",
                           conAguaCol$consumo_total >710590)))

coordinates(conAguaCol)<-~lon+lat## Convertimos a formato class SpatilPointDataFrame

conAguaCol@data$cdmx <- paste("CDMX",conAguaCol$alcaldia_x, sep = "/")

#CREAMOS EL TÍTULO
tag.map.title <- tags$style(HTML("
  .leaflet-control.map-title { 
                                 transform: translate(-50%,20%);
                                 position: fixed !important;
                                 left: 50%;
                                 text-align: center;
                                 padding-left: 10px; 
                                 padding-right: 10px; 
                                 background: rgba(255,255,255,0.75);
                                 font-weight: bold;
                                 font-size: 21px;
                                 color: black;
                                 font-family: arial
                                 }
                                 ")) 
#OTORGAMOS CARACTERÍSTICAS PARA EL TÍTULO
title <- tags$div(
    
    tag.map.title, HTML(paste("Consumo de Agua en Colonias de la CDMX <br> Primer Bimestre 2019")) 
)  




conAguaCol$etiqueta1 <- sprintf(
  "<strong><FONT SIZE=3> %s </font></strong><br/><strong><FONT SIZE=3>CONSUMO DE AGUA: %g metros cúbicos</font></strong> ",
  conAguaCol$alcaldia_colonia, conAguaCol$consumo_total
) %>% lapply(htmltools::HTML)

conAguaCol$etiqueta2 <- sprintf(
    "<strong><FONT SIZE=3> %s </font></strong><br/><strong><FONT SIZE=3>CONSUMO DE AGUA: %g metros cúbicos</font></strong> ",
    conAguaCol$alcaldia_colonia, conAguaCol$consumo_total
) %>% lapply(htmltools::HTML)

AO <- conAguaCol[which(conAguaCol$alcaldia_x =="ALVARO OBREGON"),]
AZCAPO <- conAguaCol[which(conAguaCol$alcaldia_x =="AZCAPOTZALCO"),]
BJ <- conAguaCol[which(conAguaCol$alcaldia_x =="BENITO JUAREZ"),]
COY <-conAguaCol[which(conAguaCol$alcaldia_x =="COYOACAN"),]
CUA <- conAguaCol[which(conAguaCol$alcaldia_x =="CUAUHTEMOC"),]
CUAJ <- conAguaCol[which(conAguaCol$alcaldia_x =="CUAJIMALPA"),]
GAM <- conAguaCol[which(conAguaCol$alcaldia_x =="GUSTAVO A. MADERO"),]
IZTAC<- conAguaCol[which(conAguaCol$alcaldia_x =="IZTACALCO"),]
IZTAP <- conAguaCol[which(conAguaCol$alcaldia_x == "IZTAPALAPA"),]
MC <- conAguaCol[which(conAguaCol$alcaldia_x =="MAGDALENA CONTRERAS"),]
MH <- conAguaCol[which(conAguaCol$alcaldia_x =="MIGUEL HIDALGO"),]
MILPA <- conAguaCol[which(conAguaCol$alcaldia_x =="MILPA ALTA"),]
TLH <- conAguaCol[which(conAguaCol$alcaldia_x =="TLAHUAC"),]
TLP <- conAguaCol[which(conAguaCol$alcaldia_x =="TLALPAN"),]
VC <- conAguaCol[which(conAguaCol$alcaldia_x =="VENUSTIANO CARRANZA"),]
XOC <- conAguaCol[which(conAguaCol$alcaldia_x =="XOCHIMILCO"),]






bajo <- conAguaCol[which(conAguaCol$rango =="Bajo"),]
medio <- conAguaCol[which(conAguaCol$rango =="Medio"),]
alto <- conAguaCol[which(conAguaCol$rango =="Alto"),]


leaflet()%>%leafem::addMouseCoordinates() %>% 
    addProviderTiles('Esri.WorldImagery',group = "Satélite") %>%
    addProviderTiles(providers$CartoDB.Positron, group = "Blanco y Negro")%>%
 
    addDrawToolbar(editOptions = F) %>% addScaleBar(options = scaleBarOptions(metric = T)) %>%
    addPolygons(data = cdmx_shp,fill = F,color = "#D32F2F",weight = 2.2)%>%
    addMarkers(data = conAguaCol, label = conAguaCol$etiqueta1, 
               clusterOptions = markerClusterOptions(removeOutsideVisibleBounds = F),
               group = "CDMX")%>%
    addMarkers(data = AO, label = AO$etiqueta2, 
                clusterOptions = markerClusterOptions(removeOutsideVisibleBounds = F),
                group = "ALVARO OBREGON")%>%
    addMarkers(data = AZCAPO, label = AZCAPO$etiqueta2, 
               clusterOptions = markerClusterOptions(removeOutsideVisibleBounds = F),
               group = "AZCAPOTZALCO")%>%
    addMarkers(data = BJ, label = BJ$etiqueta2, 
               clusterOptions = markerClusterOptions(removeOutsideVisibleBounds = F),
               group = "BENITO JUAREZ")%>%
    addMarkers(data = COY, label = COY$etiqueta2, 
               clusterOptions = markerClusterOptions(removeOutsideVisibleBounds = F),
               group = "COYOACAN")%>%
    addMarkers(data = CUA, label = CUA$etiqueta2, 
               clusterOptions = markerClusterOptions(removeOutsideVisibleBounds = F),
               group = "CUAUHTEMOC")%>%
    addMarkers(data = CUAJ, label = CUAJ$etiqueta2, 
               clusterOptions = markerClusterOptions(removeOutsideVisibleBounds = F),
               group = "CUAJIMALPA")%>%
    addMarkers(data = GAM, label = GAM$etiqueta2, 
               clusterOptions = markerClusterOptions(removeOutsideVisibleBounds = F),
               group = "GUSTAVO A. MADERO")%>%
    addMarkers(data = IZTAC, label = IZTAC$etiqueta2, 
               clusterOptions = markerClusterOptions(removeOutsideVisibleBounds = F),
               group = "IZTACALCO")%>%
    addMarkers(data = IZTAP, label = IZTAP$etiqueta2, 
               clusterOptions = markerClusterOptions(removeOutsideVisibleBounds = F),
               group = "IZTAPALAPA")%>%
    addMarkers(data = MC, label = MC$etiqueta2, 
               clusterOptions = markerClusterOptions(removeOutsideVisibleBounds = F),
               group = "MAGDALENA CONTRERAS")%>%
    addMarkers(data = MH, label = MH$etiqueta2, 
               clusterOptions = markerClusterOptions(removeOutsideVisibleBounds = F),
               group = "MIGUEL HIDALGO")%>%
    addMarkers(data = MILPA, label = MILPA$etiqueta2, 
               clusterOptions = markerClusterOptions(removeOutsideVisibleBounds = F),
               group = "MILPA ALTA")%>%
    addMarkers(data = TLH, label = TLH$etiqueta2, 
               clusterOptions = markerClusterOptions(removeOutsideVisibleBounds = F),
               group = "TLAHUAC")%>%
    addMarkers(data = TLP, label = TLP$etiqueta2, 
               clusterOptions = markerClusterOptions(removeOutsideVisibleBounds = F),
               group = "TLALPAN")%>%
    addMarkers(data = VC, label = VC$etiqueta2, 
               clusterOptions = markerClusterOptions(removeOutsideVisibleBounds = F),
               group = "VENUSTIANO CARRANZA")%>%
    addMarkers(data = XOC, label = XOC$etiqueta2, 
               clusterOptions = markerClusterOptions(removeOutsideVisibleBounds = F),
               group = "XOCHIMILCO")%>%
    addMarkers(data = bajo, label = bajo$etiqueta2, 
               clusterOptions = markerClusterOptions(removeOutsideVisibleBounds = F),
               group = "Bajo")%>%
    addMarkers(data = medio, label = medio$etiqueta2, 
               clusterOptions = markerClusterOptions(removeOutsideVisibleBounds = F),
               group = "Medio")%>%
    addMarkers(data = alto, label = alto$etiqueta2, 
               clusterOptions = markerClusterOptions(removeOutsideVisibleBounds = F),
               group = "Alto")%>%
    
    
    addLayersControl(overlayGroups = c("<b>Consumo de AGUA</>","CDMX","ALVARO OBREGON","AZCAPOTZALCO","BENITO JUAREZ","COYOACAN","CUAUHTEMOC",
                                       "CUAJIMALPA","GUSTAVO A. MADERO","IZTACALCO","IZTAPALAPA","MAGDALENA CONTRERAS",
                                       "MIGUEL HIDALGO","MILPA ALTA","TLAHUAC", "TLALPAN","VENUSTIANO CARRANZA","XOCHIMILCO","<b>Nivel de Consumo</>","Bajo","Medio","Alto" ),
                     baseGroups = c("Blanco y Negro", "Satélite"),
                     options =layersControlOptions(collapsed = F) )%>%
    hideGroup(c("<b>Consumo de AGUA</>","CDMX","ALVARO OBREGON","AZCAPOTZALCO","BENITO JUAREZ","COYOACAN","CUAUHTEMOC",
                "CUAJIMALPA","GUSTAVO A. MADERO","IZTACALCO","IZTAPALAPA","MAGDALENA CONTRERAS",
                "MIGUEL HIDALGO","MILPA ALTA","TLAHUAC", "TLALPAN","VENUSTIANO CARRANZA","XOCHIMILCO","<b>Nivel de Consumo</>","Bajo","Medio","Alto" )) %>%
    addControl(title,position = "topleft",className="map-title")%>%
    onRender(jsCode = JS("function(btn,map){  
    
  
    let bt=document.getElementsByClassName('leaflet-control-layers-overlays')[0]
    bt.style.width='180px';
    bt.style.height='435px';
    bt=document.getElementsByClassName('leaflet-control-layers-overlays')
                                                 
                                                 var lc=document.getElementsByClassName('leaflet-control-layers-overlays')[0]/*elegimos addLayer para crear titulos*/
                                                 
                                                 lc.getElementsByTagName('input')[0].style.display='none';
                                                 lc.getElementsByTagName('div')[0].style.fontSize='160%';
                                                 lc.getElementsByTagName('div')[0].style.textAlign='center';
                                                 
                                                 lc.getElementsByTagName('input')[18].style.display='none';
                                                 lc.getElementsByTagName('div')[18].style.fontSize='160%';
                                                 lc.getElementsByTagName('div')[18].style.textAlign='center';
                                                 
                                        
                                        lc.getElementsByTagName('div')[1].style.backgroundColor='#33691E';
                                        lc.getElementsByTagName('div')[2].style.backgroundColor='#1A237E';
                                        lc.getElementsByTagName('div')[3].style.backgroundColor='#880E4F';
                                        lc.getElementsByTagName('div')[4].style.backgroundColor='#7B1FA2';
                                        lc.getElementsByTagName('div')[5].style.backgroundColor='#1A237E';
                                        lc.getElementsByTagName('div')[6].style.backgroundColor='#880E4F';
                                        lc.getElementsByTagName('div')[7].style.backgroundColor='#7B1FA2';
                                        lc.getElementsByTagName('div')[8].style.backgroundColor='#1A237E';
                                        lc.getElementsByTagName('div')[9].style.backgroundColor='#880E4F';
                                        lc.getElementsByTagName('div')[10].style.backgroundColor='#7B1FA2';
                                        lc.getElementsByTagName('div')[11].style.backgroundColor='#1A237E';
                                        lc.getElementsByTagName('div')[12].style.backgroundColor='#880E4F';
                                        lc.getElementsByTagName('div')[13].style.backgroundColor='#7B1FA2';
                                        lc.getElementsByTagName('div')[14].style.backgroundColor='#1A237E';
                                        lc.getElementsByTagName('div')[15].style.backgroundColor='#880E4F';
                                        lc.getElementsByTagName('div')[16].style.backgroundColor='#7B1FA2';
                                        lc.getElementsByTagName('div')[17].style.backgroundColor='#1A237E';
                                        
                           
                                        lc.getElementsByTagName('div')[19].style.backgroundColor='#FBC02D';
                                        lc.getElementsByTagName('div')[20].style.backgroundColor='#F9A825';
                                        lc.getElementsByTagName('div')[21].style.backgroundColor='#F57F17';
                                        
                                        

lc.getElementsByTagName('div')[1].style.color='white';
lc.getElementsByTagName('div')[2].style.color='white';
lc.getElementsByTagName('div')[3].style.color='white';
lc.getElementsByTagName('div')[4].style.color='white';
lc.getElementsByTagName('div')[5].style.color='white';
lc.getElementsByTagName('div')[6].style.color='white';
lc.getElementsByTagName('div')[7].style.color='white';
lc.getElementsByTagName('div')[8].style.color='white';
lc.getElementsByTagName('div')[9].style.color='white';
lc.getElementsByTagName('div')[10].style.color='white';
lc.getElementsByTagName('div')[11].style.color='white';
lc.getElementsByTagName('div')[12].style.color='white';
lc.getElementsByTagName('div')[13].style.color='white';
lc.getElementsByTagName('div')[14].style.color='white';
lc.getElementsByTagName('div')[15].style.color='white';
lc.getElementsByTagName('div')[16].style.color='white';
lc.getElementsByTagName('div')[17].style.color='white';
lc.getElementsByTagName('div')[18].style.color='black';
lc.getElementsByTagName('div')[19].style.color='black';
lc.getElementsByTagName('div')[20].style.color='black';
lc.getElementsByTagName('div')[21].style.color='black';

lc.getElementsByTagName('div')[0].style.fontFamily='Arial';
lc.getElementsByTagName('div')[1].style.fontFamily='Arial';
lc.getElementsByTagName('div')[2].style.fontFamily='Arial';
lc.getElementsByTagName('div')[3].style.fontFamily='Arial';
lc.getElementsByTagName('div')[4].style.fontFamily='Arial';
lc.getElementsByTagName('div')[5].style.fontFamily='Arial';
lc.getElementsByTagName('div')[6].style.fontFamily='Arial';
lc.getElementsByTagName('div')[7].style.fontFamily='Arial';
lc.getElementsByTagName('div')[10].style.fontFamily='Arial';
lc.getElementsByTagName('div')[11].style.fontFamily='Arial';
lc.getElementsByTagName('div')[12].style.fontFamily='Arial';
lc.getElementsByTagName('div')[13].style.fontFamily='Arial';
lc.getElementsByTagName('div')[14].style.fontFamily='Arial';
lc.getElementsByTagName('div')[15].style.fontFamily='Arial';
lc.getElementsByTagName('div')[16].style.fontFamily='Arial';
lc.getElementsByTagName('div')[17].style.fontFamily='Arial';
lc.getElementsByTagName('div')[18].style.fontFamily='Arial';
lc.getElementsByTagName('div')[19].style.fontFamily='Arial';
lc.getElementsByTagName('div')[20].style.fontFamily='Arial';
lc.getElementsByTagName('div')[21].style.fontFamily='Arial';

}"))

##AGREGAR GIF QUE LAURA NO QUIZO
# addLogo ( m ,  "https://c.tenor.com/TJWgc9CPntwAAAAi/tlaloc-curiosamente.gif",
#             
#           offset.x  =  10 , 
#           offset.y  =  10 , 
#           width  =  80 , 
#           height  = 80, alpha =1,position = "bottomleft")
# 
# 
# 
  