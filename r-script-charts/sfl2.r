library(ggplot2)
library(tidyr)
library(dplyr)

target_path <- "C:\\temp\\"

path_output <- paste0(
  target_path, "images2\\"
)

file_memory <- paste0(
  target_path, "memory.csv"
)

file_time <- paste0(
  target_path, "time.csv"
)


generate_images_memory <- function(name_tool, ignore_application) {
  dados <- read.csv(file.path(file_memory),
    stringsAsFactors = FALSE,
    header = TRUE,
    sep = ";",
    dec = "."
  )
  dados <- subset(dados, Tool == name_tool)

  if (ignore_application != "") {
    vector_strings <- strsplit(ignore_application, ";")[[1]]

    for (i in 1:length(vector_strings)) {
      dados <- subset(dados, Project != vector_strings[i])
    }
  }


  dados <- subset(dados, select = -MinMB)
  dados <- subset(dados, select = -AvgMB)
  colnames(dados)[3] <- "Máximo"
  dados <- gather(dados, key = "Metric", value = "Value", -Project)
  dados <- subset(dados, Metric != "Tool")

  dados$Value <- gsub(",", ".", dados$Value)
  dados$Value <- as.numeric(dados$Value)

  p <- ggplot(dados, aes(x = Project, y = Value, fill = Metric)) +
    geom_bar(stat = "identity", position = position_dodge()) +
    scale_fill_manual(values = c("#333333")) +
    labs(x = name_tool, y = "Consumo máximo de memória em MB", fill = "Valores") +
    theme(
      legend.position = "bottom", aspect.ratio = 0.4,
      axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)
    ) +
    guides(fill = "none")

  ggsave(paste(name_tool, "Memory.eps", sep = "_"),
    plot = p, device = "eps",
    path = path_output,
    width = 7, height = 4.5, units = "in"
  )
  ggsave(paste(name_tool, "Memory.jpeg", sep = "_"),
    plot = p, device = "jpeg",
    path = path_output,
    width = 7, height = 4.5, units = "in"
  )
}

generate_images_memory_unified <- function() {
  dados <- read.csv(file.path(file_memory),
    stringsAsFactors = FALSE,
    header = TRUE,
    sep = ";",
    dec = "."
  )
  dados <- subset(dados, select = -MinMB)
  dados <- subset(dados, select = -AvgMB)

  dados$MaxMB <- gsub(",", ".", dados$MaxMB)
  dados$MaxMB <- as.numeric(dados$MaxMB)

  dados$Tool_Project <- interaction(dados$Tool, dados$Project, sep = "/")


  dados <- filter(dados, !(Tool == "Flacoco" & Project == "Collections"))
  dados <- filter(dados, !(Tool == "Flacoco" & Project == "Compress"))
  dados <- filter(dados, !(Tool == "Flacoco" & Project == "Gson"))
  dados <- filter(dados, !(Tool == "Flacoco" & Project == "Jsoup"))
  dados <- filter(dados, !(Tool == "GZoltarMaven" & Project == "Codec"))
  dados <- filter(dados, !(Tool == "GZoltarMaven" & Project == "Colelctions"))
  dados <- filter(dados, !(Tool == "GZoltarMaven" & Project == "JacksonDatabind"))
  dados <- filter(dados, !(Tool == "GZoltarMaven" & Project == "Time"))
  dados <- filter(dados, !(Tool == "Jaguar" & Project == "Compress"))
  dados <- filter(dados, !(Tool == "Jaguar" & Project == "Gson"))
  dados <- filter(dados, !(Tool == "Jaguar" & Project == "JacksonDatabind"))
  dados <- filter(dados, !(Tool == "Jaguar" & Project == "JacksonXml"))


  dados <- filter(dados, !(Project == "Time"))
  dados <- filter(dados, !(Project == "Lang"))
  dados <- filter(dados, !(Project == "Codec"))
  dados <- filter(dados, !(Project == "Collections"))
  dados <- filter(dados, !(Project == "JacksonDatabind"))
  dados <- filter(dados, !(Project == "Compress"))
  dados <- filter(dados, !(Project == "Jsoup"))

  # criar nova tabela com apenas uma linha por Project
  dados_unique_project <- distinct(dados, Project, .keep_all = TRUE)

  # configurar o eixo x usando a nova tabela

  p <- ggplot(dados, aes(x = Tool_Project, y = MaxMB, fill = Tool)) +
    geom_bar(stat = "identity") +
    labs(
      x = "Projeto",
      y = "Consumo máximo de memória em MB",
      fill = "Ferramenta"
    ) +
    # scale_x_discrete(labels = dados$Project) +
    scale_x_discrete(
      breaks = dados_unique_project$Tool_Project,
      labels = dados_unique_project$Project, position = "bottom", expand = waiver()
    ) +
    scale_fill_manual(values = c(
      "#000000", "#333333", "#666666",
      "#999999", "#aaaaaa", "#cccccc"
    )) +
    theme(legend.position = "bottom") +
    coord_flip()

  ggsave("Memory.eps",
    plot = p, device = "eps",
    path = path_output,
    width = 7, height = 7, units = "in"
  )
  ggsave("Memory.jpeg",
    plot = p, device = "jpeg",
    path = path_output,
    width = 7, height = 7, units = "in"
  )
}

generate_images_memory_unified2 <- function() {
  dados <- read.csv(file.path(file_memory),
    stringsAsFactors = FALSE,
    header = TRUE,
    sep = ";",
    dec = "."
  )
  dados <- subset(dados, select = -MinMB)
  dados <- subset(dados, select = -AvgMB)

  dados$MaxMB <- gsub(",", ".", dados$MaxMB)
  dados$MaxMB <- as.numeric(dados$MaxMB)

  dados$Tool_Project <- interaction(dados$Tool, dados$Project, sep = "/")


  dados <- filter(dados, !(Tool == "Flacoco" & Project == "Collections"))
  dados <- filter(dados, !(Tool == "Flacoco" & Project == "Compress"))
  dados <- filter(dados, !(Tool == "Flacoco" & Project == "Gson"))
  dados <- filter(dados, !(Tool == "Flacoco" & Project == "Jsoup"))
  dados <- filter(dados, !(Tool == "GZoltarMaven" & Project == "Codec"))
  dados <- filter(dados, !(Tool == "GZoltarMaven" & Project == "Colelctions"))
  dados <- filter(dados, !(Tool == "GZoltarMaven" & Project == "JacksonDatabind"))
  dados <- filter(dados, !(Tool == "GZoltarMaven" & Project == "Time"))
  dados <- filter(dados, !(Tool == "Jaguar" & Project == "Compress"))
  dados <- filter(dados, !(Tool == "Jaguar" & Project == "Gson"))
  dados <- filter(dados, !(Tool == "Jaguar" & Project == "JacksonDatabind"))
  dados <- filter(dados, !(Tool == "Jaguar" & Project == "JacksonXml"))

  dados <- filter(dados, !(Project == "Math"))
  dados <- filter(dados, !(Project == "Csv"))
  dados <- filter(dados, !(Project == "Gson"))
  dados <- filter(dados, !(Project == "JacksonXml"))
  # criar nova tabela com apenas uma linha por Project
  dados_unique_project <- distinct(dados, Project, .keep_all = TRUE)

  # configurar o eixo x usando a nova tabela

  p <- ggplot(dados, aes(x = Tool_Project, y = MaxMB, fill = Tool)) +
    geom_bar(stat = "identity") +
    labs(
      x = "Projeto",
      y = "Consumo máximo de memória em MB",
      fill = "Ferramenta"
    ) +
    scale_x_discrete(
      breaks = dados_unique_project$Tool_Project,
      labels = dados_unique_project$Project, position = "bottom"
    ) +
    scale_fill_manual(values = c(
      "#000000", "#333333", "#666666",
      "#999999", "#aaaaaa", "#cccccc"
    )) +
    theme(legend.position = "bottom") +
    coord_flip()

  ggsave("Memory2.eps",
    plot = p, device = "eps",
    path = path_output,
    width = 7, height = 10, units = "in"
  )
  ggsave("Memory2.jpeg",
    plot = p, device = "jpeg",
    path = path_output,
    width = 7, height = 10, units = "in"
  )
}



generate_images_time <- function(name_tool, ignore_application) {
  dados <- read.csv(file.path(file_time),
    stringsAsFactors = FALSE,
    header = TRUE,
    sep = ";",
    dec = "."
  )
  dados <- subset(dados, application == name_tool)

  if (ignore_application != "") {
    vector_strings <- strsplit(ignore_application, ";")[[1]]

    for (i in 1:length(vector_strings)) {
      dados <- subset(dados, project != vector_strings[i])
    }
  }

  dados <- dados %>%
    mutate(sum = sum / 1000)

  dados <-
    aggregate(cbind(sum) ~ project + application,
      data = dados,
      FUN = mean
    )

  p <- ggplot(dados, aes(x = project, y = sum, fill = application)) +
    geom_bar(stat = "identity", position = position_dodge()) +
    scale_fill_manual(values = c("#333333")) +
    labs(x = name_tool, y = "Tempo médio em segundos") +
    theme(
      legend.position = "bottom", aspect.ratio = 0.4,
      axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)
    ) +
    guides(fill = "none")

  ggsave(paste(name_tool, "Time.eps", sep = "_"),
    plot = p, device = "eps",
    path = path_output,
    width = 7, height = 4.5, units = "in"
  )
  ggsave(paste(name_tool, "Time.jpeg", sep = "_"),
    plot = p, device = "jpeg",
    path = path_output,
    width = 7, height = 4.5, units = "in"
  )
}


generate_images_time_unified <- function() {
  dados <- read.csv(file.path(file_time),
    stringsAsFactors = FALSE,
    header = TRUE,
    sep = ";",
    dec = "."
  )

  dados <- filter(dados, !(application == "Flacoco" & project == "Collections"))
  dados <- filter(dados, !(application == "Flacoco" & project == "Compress"))
  dados <- filter(dados, !(application == "Flacoco" & project == "Gson"))
  dados <- filter(dados, !(application == "Flacoco" & project == "Jsoup"))
  dados <- filter(dados, !(application == "GZoltarMaven" & project == "Codec"))
  dados <- filter(dados, !(application == "GZoltarMaven" & project == "Colelctions"))
  dados <- filter(dados, !(application == "GZoltarMaven" & project == "JacksonDatabind"))
  dados <- filter(dados, !(application == "GZoltarMaven" & project == "Time"))
  dados <- filter(dados, !(application == "Jaguar" & project == "Compress"))
  dados <- filter(dados, !(application == "Jaguar" & project == "Gson"))
  dados <- filter(dados, !(application == "Jaguar" & project == "JacksonDatabind"))
  dados <- filter(dados, !(application == "Jaguar" & project == "JacksonXml"))

  dados <- filter(dados, !(project == "JacksonXml"))
  dados <- filter(dados, !(project == "Gson"))
  dados <- filter(dados, !(project == "Jsoup"))
  dados <- filter(dados, !(project == "Codec"))
  dados <- filter(dados, !(project == "Math"))
  dados <- filter(dados, !(project == "Lang"))
  dados <- filter(dados, !(project == "Csv"))



  dados <- dados %>%
    mutate(sum = sum / 1000)

  dados <-
    aggregate(cbind(sum) ~ project + application,
      data = dados,
      FUN = mean
    )

  dados$Application_Project <-
    interaction(dados$application, dados$project, sep = "/")

  # criar nova tabela com apenas uma linha por Project
  dados_unique_project <- distinct(dados, project, .keep_all = TRUE)

  p <- ggplot(dados, aes(x = Application_Project, y = sum, fill = application)) +
    geom_bar(stat = "identity", position = position_dodge()) +
    labs(
      x = "Projeto",
      y = "Tempo médio em segundos",
      fill = "Ferramentas"
    ) +
    scale_x_discrete(
      breaks = dados_unique_project$Application_Project,
      labels = dados_unique_project$project, position = "bottom"
    ) +
    scale_fill_manual(values = c(
      "#000000", "#333333", "#666666",
      "#999999", "#aaaaaa", "#cccccc"
    )) +
    theme(
      legend.position = "bottom"
    ) +
    coord_flip()

  ggsave("Time.eps",
    plot = p, device = "eps",
    path = path_output,
    width = 7, height = 7, units = "in"
  )
  ggsave("Time.jpeg",
    plot = p, device = "jpeg",
    path = path_output,
    width = 7, height = 7, units = "in"
  )
}

generate_images_time_unified2 <- function() {
  dados <- read.csv(file.path(file_time),
    stringsAsFactors = FALSE,
    header = TRUE,
    sep = ";",
    dec = "."
  )

  dados <- filter(dados, !(application == "Flacoco" & project == "Collections"))
  dados <- filter(dados, !(application == "Flacoco" & project == "Compress"))
  dados <- filter(dados, !(application == "Flacoco" & project == "Gson"))
  dados <- filter(dados, !(application == "Flacoco" & project == "Jsoup"))
  dados <- filter(dados, !(application == "GZoltarMaven" & project == "Codec"))
  dados <- filter(dados, !(application == "GZoltarMaven" & project == "Colelctions"))
  dados <- filter(dados, !(application == "GZoltarMaven" & project == "JacksonDatabind"))
  dados <- filter(dados, !(application == "GZoltarMaven" & project == "Time"))
  dados <- filter(dados, !(application == "Jaguar" & project == "Compress"))
  dados <- filter(dados, !(application == "Jaguar" & project == "Gson"))
  dados <- filter(dados, !(application == "Jaguar" & project == "JacksonDatabind"))
  dados <- filter(dados, !(application == "Jaguar" & project == "JacksonXml"))

  dados <- filter(dados, !(project == "Compress"))
  dados <- filter(dados, !(project == "Collections"))
  dados <- filter(dados, !(project == "Time"))
  dados <- filter(dados, !(project == "JacksonDatabind"))



  dados <- dados %>%
    mutate(sum = sum / 1000)

  dados <-
    aggregate(cbind(sum) ~ project + application,
      data = dados,
      FUN = mean
    )

  dados$Application_Project <-
    interaction(dados$application, dados$project, sep = "/")

  # criar nova tabela com apenas uma linha por Project
  dados_unique_project <- distinct(dados, project, .keep_all = TRUE)

  p <- ggplot(dados, aes(x = Application_Project, y = sum, fill = application)) +
    geom_bar(stat = "identity", position = position_dodge()) +
    labs(
      x = "Projeto",
      y = "Tempo médio em segundos",
      fill = "Ferramentas"
    ) +
    scale_x_discrete(
      breaks = dados_unique_project$Application_Project,
      labels = dados_unique_project$project, position = "bottom"
    ) +
    scale_fill_manual(values = c(
      "#000000", "#333333", "#666666",
      "#999999", "#aaaaaa", "#cccccc"
    )) +
    theme(
      legend.position = "bottom"
    ) +
    coord_flip()

  ggsave("Time2.eps",
    plot = p, device = "eps",
    path = path_output,
    width = 7, height = 10, units = "in"
  )
  ggsave("Time2.jpeg",
    plot = p, device = "jpeg",
    path = path_output,
    width = 7, height = 10, units = "in"
  )
}

generate_images <- function(name_tool, ignore_project) {
  generate_images_memory(name_tool, ignore_project)
  generate_images_time(name_tool, ignore_project)
}

# generate_images("Flacoco", "Collections;Compress;Gson;Jsoup")
# generate_images("GZoltarCLI", "")
# generate_images("GZoltarMaven", "Code;Colelctions;JacksonDatabind;Time")
# generate_images("Jaguar", "Compress;Gson;JacksonDatabind;JacksonXml")
# generate_images("Jaguar2", "")
# generate_images("Verify", "")
generate_images_memory_unified()
generate_images_memory_unified2()
generate_images_time_unified()
generate_images_time_unified2()