#' Plotting heatmap
#'
#' This function allows you to plot various types of heatmaps of starting x and y coordinates:
#' hex bin heatmap,
#' density heatmap, and
#' bin heatmap
#'
#' @param data The dataframe that stores your data. Dataframe must contain atleast the following columns: `x`, `y`, `finalX`, `finalY`.
#' @param type indicates the type of heatmap to plot. "hex" indicates hex bins, "density" indicates density (default),
#' "bin" indicates bin heatmap pass and "jdp" indicates a binned heatmap according jdp pitch markings. 
#' @param data_type Type of data that is being put in: opta or statsbomb. Default set to "statsbomb".
#' @param bin indicates the size of the bin to construct heatmap for type "bin". Default set to 20.
#' @param theme indicates what theme the map must be shown in: dark (default), white, rose, almond.
#' @return returns a ggplot2 object
#'
#' @importFrom magrittr %>%
#' @import dplyr
#' @import ggplot2
#' @import ggsoccer
#' @import viridis
#' @export
#'
#' @examples
#' \dontrun{
#' plot <- plot_heatmap(touchData, type = "hex")
#' plot
#' }

plot_heatmap <- function(data, type = "", data_type = "statsbomb", bin = 20, theme = "") {
  
  if (nrow(data) > 0 &&
      sum(x = c("x", "y", "finalX", "finalY") %in% names(data)) == 4) {
    
    if (data_type == "opta") {
      to_sb <- rescale_coordinates(from = pitch_opta, to = pitch_statsbomb)
      data$x <- to_sb$x(data$x)
      data$y <- to_sb$y(data$y)
    }
    
    plot <- data %>%
      ggplot(aes(x = x, y = y))
    
    if (theme == "dark" || theme == "") {
      fill_b <- "#0d1117"
      colour_b <- "white"
    } else if (theme == "white") {
      fill_b <- "#F5F5F5"
      colour_b <- "black"
    } else if (theme == "rose") {
      fill_b <- "#FFE4E1"
      colour_b <- "#696969"
    } else if (theme == "almond") {
      fill_b <- "#FFEBCD"
      colour_b <- "#696969"
    }
    
    plot <- plot + annotate_pitch(dimensions = pitch_statsbomb, colour = colour_b,
                                  fill = fill_b) +
      theme_pitch() +
      theme(panel.background = element_rect(fill = fill_b))
    
    if (type == "" || type == "density") {
      plot <- plot +
        stat_density_2d(aes(x = x, y = 80 - y, fill = ..level..), geom = "polygon")
    } else if (type == "hex") {
      plot <- plot +
        geom_hex(aes(x = x, y = 80 - y))
    } else if (type == "bin") {
      plot <- plot +
        geom_bin2d(aes(x = x, y = 80 - y),
                   binwidth = c(bin, bin),
                   alpha = 0.9)
    } else if (type == "jdp") {
      
      binX1 <- c(0, 18, 39, 60, 81, 102, 120)
      binY1 <- c(0, 18)
      
      binX2 <- c(0, 18, 39, 60, 81, 102, 120)
      binY2 <- c(62, 80)
      
      binX3 <- c(18, 60, 102)
      binY3 <- c(18, 30, 50, 62)
      
      binX4 <- c(0, 18)
      binY4 <- c(18, 62)
      
      binX5 <- c(102, 120)
      binY5 <- c(18, 62)
      
      plot <- plot +
        geom_bin_2d(breaks = list(binX1, binY1), colour = colour_b, alpha = 0.9) +
        geom_bin_2d(breaks = list(binX2, binY2), colour = colour_b, alpha  = 0.9) +
        geom_bin_2d(breaks = list(binX3, binY3), colour = colour_b, alpha = 0.9) +
        geom_bin_2d(breaks = list(binX4, binY4), colour = colour_b, alpha = 0.9) +
        geom_bin_2d(breaks = list(binX5, binY5), colour = colour_b, alpha = 0.9)
    }
    
    plot <- plot +
      scale_fill_continuous(type = "viridis") +
      labs(
        fill = "Density"
      )
    
    plot
    
  } else {
    plot
  }
}