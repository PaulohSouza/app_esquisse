
server <- function(input, output, session) {
  
  data_rv <- reactiveValues(data = iris, name = "iris")
  
  observeEvent(input$data, {
    if (input$data == "iris") {
      data_rv$data <- iris
      data_rv$name <- "iris"
    } else {
      data_rv$data <- mtcars
      data_rv$name <- "mtcars"
    }
  })
  
  esquisse_server(
    id = "esquisse", 
    data_rv = data_rv, 
    default_aes = reactive(input$aes)
  )
  
}

if (interactive())
  shinyApp(ui, server)


### Whole Shiny app ###

library(shiny)
library(esquisse)


# Load some datasets in app environment
my_data <- data.frame(
  var1 = rnorm(100),
  var2 = sample(letters[1:5], 100, TRUE)
)


ui <- fluidPage(
  esquisse_ui(
    id = "esquisse", 
    container = esquisseContainer(fixed = TRUE)
  )
)

server <- function(input, output, session) {
  
  esquisse_server(id = "esquisse")
  
}

if (interactive())
  shinyApp(ui, server)


library(shiny)
library(esquisse)
library(datamods)

ui <- navbarPage(
  title = "FMT-GRÁFICOS",
  tabPanel(
    title = "Gerar gráfico",
    esquisse_ui(
      id = "esquisse", 
      header = FALSE,
      container = esquisseContainer(
        fixed = c(55, 0, 0, 0)
      )
    )
  )
)

server <- function(input, output, session) {
  
  # lauch import data modal
  import_modal(
    id = "import-data",
    from = c("env", "file", "copypaste"),
    title = "Import data"
  )
  data_imported_r <- datamods::import_server("import-data")
  
  data_rv <- reactiveValues(data = data.frame())
  observeEvent(data_imported_r$data(), {
    data_rv$data <- data_imported_r$data()
    data_rv$name <- data_imported_r$name()
  })
  
  esquisse_server(id = "esquisse", data_rv = data_rv)
  
}

if (interactive())
  shinyApp(ui, server)