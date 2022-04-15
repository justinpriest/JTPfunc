#' @title Theme Crisp for ggplot2
#' @description Use a custom theme for crisp, clean plots with ggplot.
#' @param base_size The base font size. Default = 12.
#' @param base_family The base family font. Default = "Arial".
#' @param rotate_x TRUE/FALSE whether x axis text should be rotated 45 degrees.
#' Default = FALSE.
#' @param rmborder TRUE/FALSE whether the outer plot border should be removed.
#' Default = FALSE.
#'
#' @return
#' @export
#' @import extrafont
#' @importFrom ggplot2 ggplot theme_light theme element_blank
#' element_rect element_text element_line
#'
#' @examples
#' library(ggplot2)
#' ggplot(mtcars, aes(x = wt, y = mpg)) + geom_point() + theme_crisp()
theme_crisp <- function(base_size = 12, base_family = "Arial", rotate_x=FALSE, rmborder=FALSE) {
  # This is based heavily on Sean Anderson's theme_sleek from ggsidekick
  # https://github.com/seananderson/ggsidekick

  half_line <- base_size/2
  theme_light(base_size = base_size, base_family = base_family) +
    theme(
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      axis.ticks.length = unit(half_line / 2.2, "pt"),
      strip.background = element_rect(fill = NA, color = NA),
      strip.text.x = element_text(color = "gray30"),
      strip.text.y = element_text(color = "gray30"),
      axis.text = element_text(color = "gray30"),
      axis.title = element_text(color = "gray30"),
      legend.title = element_text(color = "gray30", size = rel(0.9)),
      panel.border = element_rect(fill = NA, color = "gray70", size = 1),
      legend.key.size = unit(0.9, "lines"),
      legend.text = element_text(size = rel(0.7), color = "gray30"),
      legend.key = element_rect(color = NA, fill = NA),
      legend.background = element_rect(color = NA, fill = NA),
      plot.title = element_text(color = "gray30", size = rel(1)),
      plot.subtitle = element_text(color = "gray30", size = rel(.85))
    ) +
    {if(rmborder==TRUE){
      theme(axis.line = element_line(size = 0.5, color = "gray70"),
            panel.border = element_blank())
    }
      else{
        theme()
      }} + # If modifying in future, need {} around entire if statement
    if(rotate_x==TRUE){
      theme(axis.text.x = element_text(angle = 45, vjust=1, hjust=1))
    } else{
      theme(axis.text.x = element_text(angle = 0))
    }
}


