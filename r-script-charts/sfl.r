library(ggplot2)
library(tidyr)
library(dplyr)

target_path <- "C:\\temp\\"

path_output <- paste0(
  target_path, "images\\"
)

file_memory <- paste0(
  target_path, "memory.csv"
)

file_time <- paste0(
  target_path, "time.csv"
)

generate_images_memory <- function(name_project, ignore_application) {
  dados <- read.csv(file.path(file_memory),
    stringsAsFactors = FALSE,
    header = TRUE,
    sep = ";",
    dec = "."
  )
  dados <- subset(dados, Project == name_project)

  if (ignore_application != "") {
    vector_strings <- strsplit(ignore_application, ";")[[1]]

    for (i in 1:length(vector_strings)) {
      dados <- subset(dados, Tool != vector_strings[i])
    }
  }

  colnames(dados)[3] <- "Mínimo"
  colnames(dados)[4] <- "Máximo"
  colnames(dados)[5] <- "Médio"

  dados <- gather(dados, key = "Metric", value = "Value", -Tool)
  dados <- subset(dados, Metric != "Project")

  dados$Value <- gsub(",", ".", dados$Value)
  dados$Value <- as.numeric(dados$Value)

  p <- ggplot(dados, aes(x = Tool, y = Value, fill = Metric)) +
    geom_bar(stat = "identity", position = position_dodge()) +
    scale_fill_manual(values = c("#333333", "#666666", "#999999")) +
    labs(x = name_project, y = "Consumo de Memória em MB", fill = "Valores") +
    theme(legend.position = "bottom", aspect.ratio = 0.5)

  ggsave(paste(name_project, "Memory.eps", sep = "_"),
    plot = p, device = "eps",
    path = path_output,
    width = 7, height = 4.5, units = "in"
  )
  ggsave(paste(name_project, "Memory.jpeg", sep = "_"),
    plot = p, device = "jpeg",
    path = path_output,
    width = 7, height = 4.5, units = "in"
  )
}


generate_images_time <- function(name_project, ignore_application) {
  dados <- read.csv(file.path(file_time),
    stringsAsFactors = FALSE,
    header = TRUE,
    sep = ";",
    dec = "."
  )

  dados <- dados %>%
    mutate(sum = sum / 1000)
  dados <- dados %>%
    mutate(compile = compile / 1000)

  dados <- subset(dados, project == name_project)

  if (ignore_application != "") {
    vector_strings <- strsplit(ignore_application, ";")[[1]]

    for (i in 1:length(vector_strings)) {
      dados <- subset(dados, application != vector_strings[i])
    }
  }

  media <-
    aggregate(cbind(sum, compile) ~ project + application,
      data = dados,
      FUN = mean
    )

  colnames(media)[3] <- "Total"
  colnames(media)[4] <- "Compilação"
  dados_melt <- gather(media, tipo, valor, Total, Compilação)

  p <- ggplot(dados_melt, aes(x = application, y = valor, fill = tipo)) +
    geom_bar(stat = "identity", position = position_dodge()) +
    scale_fill_manual(values = c("#999999", "#333333")) +
    labs(x = name_project, y = "Tempo médio em segundos", fill = "Valores") +
    theme(legend.position = "bottom", aspect.ratio = 0.5)

  ggsave(paste(name_project, "Time.eps", sep = "_"),
    plot = p, device = "eps",
    path = path_output,
    width = 7, height = 4.5, units = "in"
  )
  ggsave(paste(name_project, "Time.jpeg", sep = "_"),
    plot = p, device = "jpeg",
    path = path_output,
    width = 7, height = 4.5, units = "in"
  )
}

generate_images <- function(name_project, ignore_application) {
  generate_images_memory(name_project, ignore_application)
  generate_images_time(name_project, ignore_application)
}

generate_images("Csv", "")
generate_images("Collections", "GZoltarMaven;Flacoco")
generate_images("Compress", "Flacoco;Jaguar")
generate_images("Gson", "Flacoco;Jaguar")
generate_images("JacksonDatabind", "GZoltarMaven;Jaguar")
generate_images("Time", "GZoltarMaven;Jaguar")
generate_images("Jsoup", "Flacoco")
generate_images("Codec", "GZoltarMaven")
generate_images("Math", "")
generate_images("Lang", "")
generate_images("JacksonXml", "Jaguar")
