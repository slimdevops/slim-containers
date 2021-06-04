#' hotshot_picker UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
#' @import slickR
#' @import reactable
mod_hotshot_picker_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
      col_12(
        br()
      )
    ),
    fluidRow(
      col_12(
        div(
          align = "center",
          #class = "d-flex justify-content-center",
          shinyWidgets::actionBttn(
            ns("start"),
            "Launch!",
            icon = icon("rocket"),
            style = "gradient",
            color = "primary",
            size = "lg"
          ),
          shinyWidgets::actionBttn(
            ns("clear"),
            "Clear",
            icon = icon("eraser"),
            style = "gradient",
            color = "danger",
            size = "lg"
          ),
          shinyWidgets::actionBttn(
            ns("advanced"),
            "Advanced Settings",
            icon = icon("thumbs-up"),
            style = "gradient",
            color = "success",
            size = "lg"
          )
        )
      )
    ),
    fluidRow(
      col_12(
        br()
      )
    ),
    fluidRow(
      col_12(
        fluidRow(
          col_4(
            conditionalPanel(
              condition = "output.active_random",
              ns = ns,
              slickROutput(
                ns("driver_slick_output"),
                width = '60%',
                height = '230px'
              ),
              slickROutput(
                ns("driver_text_output"),
                width = '60%',
                height = '100px'
              )
            )
          ),
          col_4(
            slickROutput(
              ns("car_slick_output"),
              width = '60%',
              height = '700px'
            ),
            slickROutput(
              ns("car_text_output"),
              width = '60%',
              height = '150px'
            )
          )
        )
      )
    ),
    # fluidRow(
    #   conditionalPanel(
    #     condition = 'output.show_selected_table',
    #     ns = ns,
    #     col_12(
    #       reactable::reactableOutput(ns("selected_driver_dt"))
    #     )
    #   )
    # ),
    fluidRow(
      col_6(
        #reactable::reactableOutput(ns("selected_driver_dt"))
        conditionalPanel(
          condition = 'output.show_selected_table',
          ns = ns,
            wellPanel(
              style = "background: #0090f9",
              h3("Previous Selected Cars")
            ),
            reactable::reactableOutput(ns("selected_driver_dt"))
          )
      ),
      col_6(
        conditionalPanel(
          condition = 'output.show_excluded_table',
          ns = ns,
          wellPanel(
            style = "background: #0090f9",
            h3("Excluded Cars")
          ),
          reactable::reactableOutput(ns("excluded_driver_dt"))
        )
      )
    )
  )
}
    
#' hotshot_picker Server Function
#'
#' @noRd 
mod_hotshot_picker_server <- function(input, output, session, default_time = 4){
  ns <- session$ns

  # obtain tidy version of hotshot_data
  df <- gen_tidy_racers(hotshot_data)

  # assemble additional sets
  country_df <- racer_country_df()
  
  # obtain paths to driver image files
  driver_files <- gen_driver_images()
  

  # reactive value for slick objects
  driver_slick_rv <- reactiveVal(NULL)
  driver_text_rv <- reactiveVal(NULL)
  car_slick_rv <- reactiveVal(NULL)
  car_text_rv <- reactiveVal(NULL)
  active_slick <- reactiveValues()
  car_files <- reactiveVal(NULL)
  driver_index_select <- reactiveVal(NULL)
  car_index_select <- reactiveVal(NULL)

  driver_selected_rv <- reactiveVal(NULL)
  driver_selected_show_rv <- reactiveVal(FALSE)

  driver_excluded_rv <- reactiveVal(NULL)
  
  exclude_previous_gp_cars <- reactiveVal(FALSE)
  #previous_gp_cars <- reactiveVal(c("eagle", "shadow", "t-66_super", "rosso", "diamond_back", "vector", "bullet", "eight_rock", "blaze", "furious", "el_toro", "athena", "sentinel"))
  previous_gp_cars <- reactiveVal(NULL)

  # reactive values for timer
  timer <- reactiveVal(default_time)
  active <- reactiveVal(FALSE)

  # server-side reactive for conditionalPanel
  output$active_random <- reactive({
    any(active(), !is.null(driver_selected_rv()))
  })

  output$show_selected_table <- reactive({
    all(driver_selected_show_rv(), !is.null(driver_selected_rv()))
  })

  output$show_excluded_table <- reactive({
    !is.null(hs_state())
  })

  outputOptions(output, "active_random", suspendWhenHidden = FALSE)
  outputOptions(output, "show_selected_table", suspendWhenHidden = FALSE)
  outputOptions(output, "show_excluded_table", suspendWhenHidden = FALSE)

  # observer that invalidates every second
  # https://stackoverflow.com/a/49254510
  observe({
    invalidateLater(1000, session)
    isolate({
      if (active()) {
        timer(timer() - 1)
        if (timer() < 1) {
          active(FALSE)
          x <- driver_slick_rv() + settings(autoplay = FALSE, infinite = FALSE, initialSlide = driver_index_select())
          x2 <- driver_text_rv() + settings(autoplay = FALSE, infinite = FALSE, initialSlide = driver_index_select())
          y <- car_slick_rv() + settings(autoplay = FALSE, infinite = FALSE, initialSlide = car_index_select())
          y2 <- car_text_rv() + settings(autoplay = FALSE, infinite = FALSE, initialSlide = car_index_select())
          driver_slick_rv(x)
          driver_text_rv(x2)
          car_slick_rv(y)
          car_text_rv(y2)
          timer(default_time)
          driver_index_select(NULL)
          car_index_select(NULL)
          driver_selected_show_rv(TRUE)
        }
      }
    })
  })

  observe({
    shinyjs::toggleState("start", !active())
  })

  # reactive for driver slickR object
  driver_slick_obj <- reactive({
    if (any(stringr::str_detect(driver_files, "^https"))) {
      driver_files <- purrr::map(driver_files, ~htmltools::tags$img(src = .x))
    }
    
    x <- slickR(driver_files, slideId = 'driver_slick', height = 400, width = '100%')

    # set up style for text elemeent
    x_text <- names(hotshot_data$drivers)
    x_text <- purrr::map(names(hotshot_data$drivers), ~htmltools::tags$p(.x, style = htmltools::css(color = 'red', font.size = '40px'))) 
    x_text_dom <- slickR::slick_list(x_text)
    x2 <- slickR(x_text_dom, slideId = 'driver_text') + settings(arrows = FALSE)

    #x <- x + settings(autoplay = TRUE)
    if (is.null(driver_slick_rv())) {
      driver_slick_rv(x)
    }

    if (is.null(driver_text_rv())) {
      driver_text_rv(x2)
    }
    return(x)
  })

  output$driver_slick_output <- renderSlickR({
    req(driver_slick_obj())
    req(driver_slick_rv())
    driver_slick_rv()
  })

  output$driver_text_output <- renderSlickR({
    req(driver_slick_obj())
    req(driver_text_rv())
    driver_text_rv()
  })

  output$car_slick_output <- renderSlickR({
    req(car_slick_rv())
    car_slick_rv()
  })

  output$car_text_output <- renderSlickR({
    req(car_text_rv())
    car_text_rv()
  })

  observeEvent(input$start, {
    req(driver_slick_rv())
    driver_selected_show_rv(FALSE)

    # randomly select driver and car
    # first ensure previous selections and/or excluded records are accounted for
    exclude_df <- NULL
    
    if (exclude_previous_gp_cars()) {
      tmp_df <- gen_tidy_racers(hotshot_data) %>%
        filter(car_name %in% previous_gp_cars())
      
      driver_excluded_rv(tmp_df)
      exclude_previous_gp_cars(FALSE)
      
      exclude_tmp <- dplyr::bind_rows(driver_selected_rv(), tmp_df)
    } else {
      exclude_tmp <- dplyr::bind_rows(driver_selected_rv(), driver_excluded_rv())
    }
    

    if (nrow(exclude_tmp) > 0) exclude_df <- exclude_tmp

    hs_select <- random_hotshot(exclude_df = exclude_df)

    if (!is.null(driver_selected_rv())) {
      driver_selected_rv(dplyr::bind_rows(driver_selected_rv(), hs_select))
    } else {
      driver_selected_rv(hs_select)
    } 

    hs_driver <- hs_select$driver_name
    hs_type <- hs_select$type
    hs_car <- hs_select$car_name

    # obtain index position of driver name, then subtract 1 to properly set slickr after selection complete
    drivers <- names(hotshot_data$drivers)
    driver_index <- which(drivers %in% hs_driver) - 1
    driver_index_select(driver_index)

    car_df <- gen_car_df(keep_df = hs_select)
    car_files <- gen_car_images(car_df, external = FALSE)
    if (any(stringr::str_detect(car_files, "^https"))) {
      car_files <- purrr::map(car_files, ~htmltools::tags$img(src = .x))
    }

    type_index <- which(car_df$car_name %in% hs_car) - 1
    car_index_select(type_index)

    car_slick <- slickR(car_files, slideId = 'car_slick', height = 200, width = '100%')
    car_text <- purrr::map(car_df$car_name, ~htmltools::tags$p(.x, style = htmltools::css(color = 'red', font.size = '40px'))) 
    car_text_dom <- slickR::slick_list(car_text)
    car_text_slick <- slickR(car_text_dom, slideId = 'car_text') + settings(arrows = FALSE)

    x <- driver_slick_rv() + settings(autoplay = TRUE, autoplaySpeed = 10, speed = 100)
    x2 <- driver_text_rv() + settings(autoplay = TRUE, autoplaySpeed = 10, speed = 100)
    y <- car_slick + settings(autoplay = TRUE, autoplaySpeed = 10, speed = 100)
    y2 <- car_text_slick + settings(autoplay = TRUE, autoplaySpeed = 10, speed = 100)

    driver_slick_rv(x)
    driver_text_rv(x2)
    car_slick_rv(y)
    car_text_rv(y2)
    active(TRUE)
  })

  observeEvent(input$clear, {
    driver_selected_rv(NULL)
    driver_slick_rv(NULL)
    driver_text_rv(NULL)
    car_slick_rv(NULL)
    car_text_rv(NULL)
  })

  observeEvent(input$advanced, {
    showModal(
      modalDialog(
        title = "Advanced Settings",
        tagList(
          fluidRow(
            col_2(
              numericInput(
                ns("time"),
                "Timer (Seconds)",
                value = 3,
                min = 1,
                max = 1000,
                step = 1
              ),
              numericInput(
                ns("seed"),
                "Random Seed",
                value = 8675309,
                min = 1,
                max = 100000000,
                step = 1
              )
            ),
            col_10(
              reactable::reactableOutput(ns("driver_filter")),
              verbatimTextOutput(ns("debug"))
            )
          )
        ),
        easyClose = TRUE,
        size = "l"
      )
    )
  })

  output$driver_filter <- reactable::renderReactable({
    df <- gen_tidy_racers(hotshot_data)
    res <- gen_racer_table(df)
    return(res)
  })

  # reactive for selected rows
  hs_state <- reactive({
    getReactableState("driver_filter", "selected")
  })

  hs_exclude <- reactive({
    if (is.null(hs_state())) return(NULL)
    df <- dplyr::slice(gen_tidy_racers(hotshot_data), hs_state())
    return(df)
  })

  observeEvent(hs_state(), {
    if (!is.null(hs_state())) {
      df <- dplyr::slice(gen_tidy_racers(hotshot_data), hs_state())
      driver_excluded_rv(df)
    } else {
      driver_excluded_rv(NULL)
    }
  })

  output$selected_driver_dt <- reactable::renderReactable({
    req(driver_selected_rv())
    res <- gen_racer_table(driver_selected_rv(), show_filter = FALSE)
    return(res)
  })

  output$excluded_driver_dt <- reactable::renderReactable({
    #req(hs_state())
    req(driver_excluded_rv())
    res <- gen_racer_table(driver_excluded_rv(), show_filter = FALSE)
    return(res)
  })

  output$debug <- renderPrint({
    hs_state()
  })
 
}
    
## To be copied in the UI
# mod_hotshot_picker_ui("hotshot_picker_ui_1")
    
## To be copied in the server
# callModule(mod_hotshot_picker_server, "hotshot_picker_ui_1")
 