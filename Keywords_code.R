#Instalar librerías 
install.packages("flextable")
install.packages("readxl")
install.packages("tidyverse")
install.packages("wordcloud")

###cargar librerías
library(readxl)
library(flextable)
library(tidyverse)
library(wordcloud)


articles <- read_excel("articles.xlsx")
View(articles)

keywords <- articles$keywords

keywords <- unlist(strsplit(keywords, ";"))

keywords <- na.omit(keywords)

keywords <- keywords[!grepl("\\b\\d+\\b", keywords)]

print(keywords)

keywords <- as.data.frame(keywords)

keywords <- keywords %>% group_by(keywords) %>% summarize(Frecuencia = n()) %>% arrange(desc(Frecuencia))

keywords$Porcentaje  <- round(keywords$Frecuencia / sum(keywords$Frecuencia) * 100, 1) 

keywords$Porcentaje_Acumulado <- cumsum(keywords$Porcentaje)

keywords %>% slice(1:20) %>% 
  flextable() %>%
  add_header_lines("Tabla 1. Palabras clave más frecuentes en los últimos 5 años") %>%
  fontsize(part = "all", size = 8) %>%
  font(part = "all", fontname = "Arial") %>%
  bold(part = "header") %>%
  set_table_properties(layout = "autofit") %>%
  set_header_labels(keywords = "Palabra Clave", Frecuencia = "n", Porcentaje = "%", Porcentaje_Acumulado = "% a") %>% 
  flextable::save_as_docx(path = "Keywords_table.docx")


png("Nube_keywords.png", width = 800, height = 600)  
wordcloud(words = keywords$keywords, freq = keywords$Frecuencia, 
          min.freq = 1,
          scale = ,
          max.words = 20,
          random.order=FALSE, 
          rot.per=0.20, 
          family="Arial")  
dev.off()

###Topics

Topics <- articles$Topics

Topics <- unlist(strsplit(Topics, ","))

Topics <- na.omit(Topics)

Topics <- Topics[!grepl("\\b\\d+\\b", Topics)]


Topics <- as.data.frame(Topics)


Topics <- Topics %>% group_by(Topics) %>% summarize(Frecuencia = n()) %>% arrange(desc(Frecuencia))

Topics$Porcentaje  <- round(Topics$Frecuencia / sum(Topics$Frecuencia) * 100, 1) 

Topics$Porcentaje_Acumulado <- cumsum(Topics$Porcentaje)

Topics %>% slice(1:20) %>% 
  flextable() %>%
  add_header_lines("Tabla 1. Tópicos más frecuentes en los últimos 5 años") %>%
  fontsize(part = "all", size = 8) %>%
  font(part = "all", fontname = "Arial") %>%
  bold(part = "header") %>%
  set_table_properties(layout = "autofit") %>%
  set_header_labels(Topics = "Tópico", Frecuencia = "n", Porcentaje = "%", Porcentaje_Acumulado = "% a") %>% 
  flextable::save_as_docx(path = "Topics_table.docx")


png("Nube_Topics.png", width = 800, height = 600)  
wordcloud(words = Topics$Topics, freq = Topics$Frecuencia, 
          min.freq = 1,
          scale = ,
          max.words = 20,
          random.order=FALSE, 
          rot.per=0.20, 
          family="Arial")  
dev.off()
