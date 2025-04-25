## ----setup, include = FALSE---------------------------------------------------
library(readstata13)
dir.create("res")
options(rmarkdown.html_vignette.check_title = FALSE)

knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## -----------------------------------------------------------------------------
data (cars)

# Save the 'cars' dataset to a Stata file
save.dta13(cars, file = "res/cars.dta")

# Read the saved Stata file back into R
dat <- read.dta13("res/cars.dta")

## -----------------------------------------------------------------------------
# prints the attributes
attributes(dat)

## -----------------------------------------------------------------------------
# Save the cars dataset as a Stata 7 dta file
save.dta13(cars, "res/cars_version.dta", version = 7)

# Read the file back and check its reported version
dat3 <- read.dta13("res/cars_version.dta")
attr(dat3, "version")

## -----------------------------------------------------------------------------
library(readstata13)
x <- read.dta13(system.file("extdata/statacar.dta", 
                            package = "readstata13"),
                convert.factors = FALSE)

## -----------------------------------------------------------------------------
attr(x, "var.labels")

## -----------------------------------------------------------------------------
varlabel(x, var.name = "type")

## -----------------------------------------------------------------------------
attr(x, "val.labels")

## -----------------------------------------------------------------------------
attr(x, "label.table")$type_en

## -----------------------------------------------------------------------------
get.label.name(x, var.name = "type")
get.label(x, "type_en")

## -----------------------------------------------------------------------------
# Create a factor variable 'type_en' from the 'type' variable using stored labels
x$type_en <- set.label(x, "type")

# Display the original numeric column and the new factor column
x[, c("type", "type_en")]

## -----------------------------------------------------------------------------
# Check available languages and the default language
get.lang(x)

# Create a factor using the German labels
x$type_de <- set.label(x, "type", lang = "de")

# Display the original and both language factor columns
x[, c("type", "type_en", "type_de")]

## ----eval = isTRUE(requireNamespace("labelled"))------------------------------
# Requires labelled package version > 2.8.0 due to a past bug
library(labelled)

# Read the data and convert to the 'labelled' class format
xl <- read.dta13(system.file("extdata/statacar.dta", 
                             package = "readstata13"),
                convert.factors = FALSE)

xl <- to_labelled(xl)
xl

## ----eval = isTRUE(requireNamespace("expss")) & isTRUE(requireNamespace("labelled"))----
library(expss)

# Example: Use expss to create a table summarizing horse power by car brand
# First, handle missing or negative HP values
xl[xl$hp < 0 | is.na(xl$hp), "hp"] <- NA

# Create the table using expss piping syntax
xl %>%
  tab_cells(hp) %>% # Specify the variable for cells
  tab_cols(brand) %>% # Specify the variable for columns
  tab_stat_mean_sd_n() %>% # Calculate mean, standard deviation, and N
  tab_pivot() %>% # Pivot the table
  set_caption("Horse power by car brand.") # Add a caption

## -----------------------------------------------------------------------------
# Read only the first 3 rows of the dataset
dat_1 <- read.dta13("res/cars.dta", select.rows = c(1,3)); dat_1

# Read only the 'dist' variable from the dataset
dat_2 <- read.dta13("res/cars.dta", select.cols = "dist"); head(dat_2)

## -----------------------------------------------------------------------------
# Save the cars dataset with compression enabled
save.dta13(cars, file = "res/cars_compress.dta", compress = TRUE)

# Import the compressed file and check the resulting data types
dat2 <- read.dta13(file = "res/cars_compress.dta")
attr(dat2, "types")

## -----------------------------------------------------------------------------
rbind(file.info("res/cars.dta")["size"],
      file.info("res/cars_compress.dta")["size"])

## -----------------------------------------------------------------------------
dtas_path <- system.file("extdata", "myproject2.dtas",
                         package="readstata13")

# Get information about frames in the .dtas file
get.frames(dtas_path)

## -----------------------------------------------------------------------------
# Read all frames from the .dtas file
read.dtas(dtas_path)

## -----------------------------------------------------------------------------
# Read only the "counties" frame
read.dtas(dtas_path, select.frames = "counties")

## -----------------------------------------------------------------------------
# Read frames with different column selections for each
read.dtas(dtas_path,
          read.dta13.options = list(counties = list(select.cols = "median_income"),
                                    persons = list(select.cols = "income")))

## -----------------------------------------------------------------------------
# Create a directory for exporting strLs
dir.create("res/strls/")

# Read a dta file containing strLs and export their content
dat_strl <- read.dta13("stata_strl.dta", 
                       strlexport = TRUE, 
                       strlpath = "res/strls/")

# List the files created in the export directory.
# The filenames indicate the variable and observation index (e.g., 15_1).
dir("res/strls/")

## -----------------------------------------------------------------------------
# Read the content of the text file strL export
readLines("res/strls/15_1")

## ----fig.alt="Display of the R logo extracted from a long string."------------
library(png)
library(grid) # grid is needed for grid.raster

# Read the PNG image file
img <- readPNG("res/strls/16_1")

# Display the image
grid::grid.raster(img)

## ----include=FALSE------------------------------------------------------------
# Clean up the created directory and files
unlink("res/", recursive = TRUE)

