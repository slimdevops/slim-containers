## app.R ##
library(shiny)
server <- function(input, output) {
  output$distPlot <- renderPlot({
    hist(rnorm(input$obs), col = 'darkgray', border = 'white')
  })
}

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      sliderInput("obs", "Number of observations:", min = 10, max = 500, value = 100)
    ),
    mainPanel(plotOutput("distPlot"))
  )
)

obj <- shinyApp(ui = ui, server = server, options = list(host='0.0.0.0', port = 7123))
shiny::runApp(appDir = obj, launch.browser = FALSE)
