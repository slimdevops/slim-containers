#' The application User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#'     DO NOT REMOVE.
#' @import shiny
#' @import bslib
#' @import slickR
#' @noRd
app_ui <- function(request) {
  my_theme <- bs_theme(
    bg = "#0090f9", 
    fg = "#f0f0e6", 
    primary = "#71cc65", 
    base_font = font_google("Oswald", local = FALSE),
    "font-size-base" = "1.1rem"
  )

  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # List the first level UI elements here 
    fluidPage(
      theme = my_theme,
      shinyWidgets::setBackgroundImage(src = "www/misc_images/hotshot_background_filter.jpg"),
      div(
        align = "center",
        wellPanel(
          style = "background: #0090f9",
          fluidRow(
            col_2(
              img(alt = "wimpy's world", src = "www/misc_images/wimpy_gaming_logo.jpg")
            ),
            col_10(
              h1("Wimpy's World Hot Shot Racing Driver Selector!")
            )
          ),
          div(
            align = "left",
            includeMarkdown(app_sys("app", "docs", "intro.md"))
          )
        )
      ),
      mod_hotshot_picker_ui("hotshot_picker_ui_1")
    )
  )
}

#' Add external Resources to the Application
#' 
#' This function is internally used to add external 
#' resources inside the Shiny application. 
#' 
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function(){
  
  add_resource_path(
    'www', app_sys('app/www')
  )
 
  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'hotshots.random'
    ),
    shinyjs::useShinyjs()
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert() 
  )
}

