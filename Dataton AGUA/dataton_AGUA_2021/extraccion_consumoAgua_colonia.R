library(tidyverse)
library(data.table)
library(reshape2)
library(plotly)


consAguaColonia <- read.csv("/home/jfractal/Documentos/dataton_2021/dataton_AGUA_2021/consumoAguaColonia2.csv")
names(consAguaColonia)


##Filtramos por alcaldía--------------------------------------------------------


consAguaColonia$rango <- ifelse(consAguaColonia$consumo_total <=175729, "Bajo",
                           ifelse(consAguaColonia$consumo_total >175729 & consAguaColonia$consumo_total <=710590, "Medio",
                                  ifelse(consAguaColonia$consumo_total >710590 & consAguaColonia$consumo_total <=2976649, "Alto",
                                         consAguaColonia$consumo_total >710590)))

coloniasConsumo <- dcast(consAguaColonia, alcaldia_x~rango, margins = T)
coloniasConsumo <- coloniasConsumo%>%mutate(porcientobajo =  round(Bajo/coloniasConsumo$`(all)`,digits = 2)*100,
                                            porcientoMedio =  round(Medio/coloniasConsumo$`(all)`,digits = 2)*100,
                                            porcientoAlto =  round(Alto/coloniasConsumo$`(all)`,digits = 2)*100 )



coloniasConsumo%>%plot_ly()%>% 
        add_trace(x = ~alcaldia_x, y = ~Bajo, type = 'bar', name = 'Bajo',
                  marker = list(color = '#7B1FA2',
                                line = list(color = 'white', width = 1.5)))%>% 
        add_trace(x = ~alcaldia_x, y = ~Medio, type = 'bar', name = 'Medio',
                  marker = list(color = '#5DADE2',
                                line = list(color = 'white', width = 1.5)))%>% 
        add_trace(x = ~alcaldia_x, y = ~Alto, type = 'bar', name = 'Alto',
                  marker = list(color = '#880E4F',
                                line = list(color = 'white', width = 1.5)))%>%
        layout(title = '<b>Número de colonias por nivel de consumo de agua\nCDMX Primer Semestre 2019</b>', 
               font=list(size =14, color ="black", family = "Arial"))%>%
        layout( yaxis = list(title = 'Número de colonias'), 
                xaxis = list(title = "Alcaldías"))%>%
        layout(legend=list(title=list(text='<b>Nivel de Consumo</b>')))
       




