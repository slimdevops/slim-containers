gen_tidy_racers <- function(df) {
    res <- df %>%
      tibble::as_tibble(.) %>%
      tidyr::unnest_wider(col = "drivers") %>%
      tidyr::unnest_longer(col = "cars") %>%
      tidyr::unnest_wider(col = "cars")
    return(res)
}

#' @import dplyr
#' @noRd
gen_driver_images <- function(external = FALSE) {
  data(hotshot_data)
  drivers <- names(hotshot_data$drivers)
  if (external) {
    res <- gen_tidy_racers(hotshot_data) %>%
      select(driver_name, driver_img_url) %>%
      distinct() %>%
      pull(driver_img_url)
  } else {
    res <- fs::path(app_sys("app", "www", "driver_pics"), paste0(drivers, ".png"))
  }

  return(res)
}

#' @import dplyr
#' @noRd 
gen_car_df <- function(keep_df = NULL) {
  df <- gen_tidy_racers(hotshot_data)
  #print(head(df))
  
  if (!is.null(keep_df)) {
    # grab appropriate row
    keep_df <- dplyr::mutate(keep_df, keep = TRUE)
    
    other_df <- df %>%
      dplyr::filter(driver_name != keep_df$driver_name) %>%
      dplyr::group_by(driver_name) %>%
      dplyr::sample_n(1) %>%
      dplyr::ungroup() %>%
      dplyr::mutate(keep = FALSE)
    
    cars_df <- dplyr::bind_rows(keep_df, other_df) %>%
      dplyr::slice(sample(1:dplyr::n()))
    
  } else {
    # randomly select a car from each driver
    cars_df <- df %>%
      dplyr::group_by(driver_name) %>%
      dplyr::sample_n(1) %>%
      dplyr::ungroup()
  }
  
  return(cars_df)
}

gen_car_images <- function(cars_df, external = FALSE) {
  
  if (external) {
    res <- cars_df$car_img_url
  } else {
    res <- fs::path(app_sys("app", "www", "car_pics"), paste0("resized-", cars_df$car_name, ".png"))
  }
  return(res)
}

random_hotshot <- function(exclude_df = NULL, seed = NULL) {
  df <- gen_tidy_racers(hotshot_data)

  if (!is.null(exclude_df)) {
    df <- dplyr::filter(df, !car_name %in% exclude_df$car_name)
  }

  # randomly select a row
  if (!is.null(seed)) set.seed(seed)

  df_sub <- dplyr::sample_n(df, 1)

  return(df_sub)
}

racer_country_df <- function() {
  data(hotshot_data)
  data(country_data)

  df <- gen_tidy_racers(hotshot_data)

  res <- df %>%
    dplyr::select(driver_name, country) %>%
    dplyr::distinct(.) %>%
    dplyr::left_join(country_data, by = "country")

  return(res)
}

#' @import reactable
#' @noRd
gen_racer_table <- function(df = NULL, show_filter = TRUE) {
  if (is.null(df)) {
    df <- gen_tidy_racers(hotshot_data)
  }

  # red 1-3: #fe413d
  # yellow 4-7: #fefd03
  # green 8-10: #9cff32

  # define reactable object
    res <- reactable(
      df,
      filterable = show_filter,
      resizable = TRUE,
      showPageSizeOptions = TRUE,
      selection = 'multiple',
      onClick = 'select',
      highlight = TRUE,
      columns = list(
        driver_name = colDef(
          name = "Driver",
          minWidth = 100,
          cell = function(value, index) {
            # grab appropriate record from country flag data frame
            country_select <- dplyr::slice(df, index) %>% dplyr::pull(country)
            country_url <- dplyr::filter(country_data, country == country_select) %>% dplyr::pull(url)

            div(
              img(class = "flag", alt = paste(country_select, "flag"), src = country_url),
              value
            )
          }),
        country = colDef(show = FALSE),
        driver_img_url = colDef(show = FALSE),
        car_img_url = colDef(show = FALSE),
        car_name = colDef(name = "Car"),
        type = colDef(name = "Type"),
        speed = colDef(
          name = "Speed",
          width = 100,
          style = function(value) {
            if (!is.numeric(value)) return()
            color <- dplyr::case_when(
              value <= 3 ~ "#fe413d",
              dplyr::between(value, 4, 7) ~ "#fefd03",
              TRUE ~ "#9cff32"
            )
            list(background = color, color = "black")
          }),
        acceleration = colDef(
          name = "Acceleration",
          width = 100,
          style = function(value) {
            if (!is.numeric(value)) return()
            color <- dplyr::case_when(
              value <= 3 ~ "#fe413d",
              dplyr::between(value, 4, 7) ~ "#fefd03",
              TRUE ~ "#9cff32"
            )
            list(background = color, color = "black")
          }),
        drift = colDef(
          name = "Drift",
          width = 100,
          style = function(value) {
            if (!is.numeric(value)) return()
            color <- dplyr::case_when(
              value <= 3 ~ "#fe413d",
              dplyr::between(value, 4, 7) ~ "#fefd03",
              TRUE ~ "#9cff32"
            )
            list(background = color, color = "black")
          })
      ),
      theme = reactableTheme(
        color = "hsl(233, 9%, 87%)",
        backgroundColor = "hsl(233, 9%, 19%)",
        borderColor = "hsl(233, 9%, 22%)",
        stripedColor = "hsl(233, 12%, 22%)",
        highlightColor = "hsl(233, 12%, 24%)",
        inputStyle = list(backgroundColor = "hsl(233, 9%, 25%)"),
        selectStyle = list(backgroundColor = "hsl(233, 9%, 25%)"),
        pageButtonHoverStyle = list(backgroundColor = "hsl(233, 9%, 25%)"),
        pageButtonActiveStyle = list(backgroundColor = "hsl(233, 9%, 28%)")
      )
    )

    return(res)
}
