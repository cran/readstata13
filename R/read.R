#
# Copyright (C) 2014-2025 Jan Marvin Garbuszus and Sebastian Jeworutzki
# Copyright (C) of 'convert.dates' and 'missing.types' Thomas Lumley
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the
# Free Software Foundation; either version 2 of the License, or (at your
# option) any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
# more details.
#
# You should have received a copy of the GNU General Public License along
# with this program. If not, see <http://www.gnu.org/licenses/>.

#' Read Stata Binary Files
#'
#' \code{read.dta13} reads a Stata dta-file and imports the data into a
#'  data.frame.
#'
#' @param file  \emph{character.} Path to the dta file you want to import.
#' @param convert.factors \emph{logical.} If \code{TRUE}, factors from Stata
#'  value labels are created.
#' @param generate.factors \emph{logical.} If \code{TRUE} and convert.factors is
#'  TRUE, missing factor labels are created from integers. If duplicated labels
#'  are found, unique labels will be generated according the following scheme:
#'  "label_(integer code)".
#' @param encoding \emph{character.} Strings can be converted from Windows-1252
#'  or UTF-8 to system encoding. Options are "latin1" or "UTF-8" to specify
#'  target encoding explicitly. Since Stata 14 files are UTF-8 encoded and
#'  may contain strings which can't be displayed in the current locale.
#'  Set encoding=NULL to stop reencoding.
#' @param fromEncoding \emph{character.} We expect strings to be encoded as
#'  "CP1252" for Stata Versions 13 and older. For dta files saved with Stata 14
#'  or newer "UTF-8" is used. In some situation the used encoding can differ for
#'  Stata 14 files and must be manually set.
#' @param convert.underscore \emph{logical.} If \code{TRUE}, "_" in variable
#'  names will be changed to "."
#' @param missing.type \emph{logical.} Stata knows 27 different missing types:
#'  ., .a, .b, ..., .z. If \code{TRUE}, attribute \code{missing} will be
#'   created.
#' @param replace.strl \emph{logical.} If \code{TRUE}, replace the reference to
#'  a strL string in the data.frame with the actual value. The strl attribute
#'  will be removed from the data.frame (see details).
#' @param convert.dates \emph{logical.} If \code{TRUE}, Stata dates are
#'  converted.
#' @param add.rownames \emph{logical.} If \code{TRUE}, the first column will be
#'  used as rownames. Variable will be dropped afterwards.
#' @param nonint.factors \emph{logical.} If \code{TRUE}, factors labels
#'  will be assigned to variables of type float and double.
#' @param select.rows \emph{integer.} Vector of one or two numbers. If single
#'  value rows from 1:val are selected. If two values of a range are selected
#'  the rows in range will be selected.
#' @param select.cols \emph{character.} or \emph{numeric.} Vector of variables
#'  to select. Either variable names or position.
#' @param strlexport \emph{logical.} Should strl content be exported as binary
#'  files?
#' @param strlpath \emph{character.} Path for strl export.
#' @param tz \emph{character.} time zone specification to be used for
#'  POSIXct values. ‘""’ is the current time zone, and ‘"GMT"’ is UTC
#'  (Universal Time, Coordinated).
#'
#' @details If the filename is a url, the file will be downloaded as a temporary
#'  file and read afterwards.
#'
#' Stata files are encoded in ansinew. Depending on your system's default
#'  encoding certain characters may appear wrong. Using a correct encoding may
#'  fix these.
#'
#' Variable names stored in the dta-file will be used in the resulting
#'  data.frame. Stata types char, byte, and int will become integer; float and
#'  double will become numerics. R only knows a single missing type, while Stata
#'  knows 27, so all Stata missings will become NA in R.  If you need to keep
#'  track of Statas original missing types, you may use
#'  \code{missing.type=TRUE}.
#'
#' Stata dates are converted to R's Date class the same way foreign handles
#' dates.
#'
#' Stata 13 introduced a new character type called strL. strLs are able to store
#'  strings up to 2 billion characters.  While R is able to store
#'  strings of this size in a character vector, the printed representation of
#'  such vectors looks rather cluttered, so it's possible to save only a
#'  reference in the data.frame with option \code{replace.strl=FALSE}.
#'
#' In R, you may use rownames to store characters (see for instance
#'  \code{data(swiss)}). In Stata, this is not possible and rownames have to be
#'  stored as a variable. If you want to use rownames, set add.rownames to TRUE.
#'  Then the first variable of the dta-file will hold the rownames of the
#'  resulting data.frame.
#'
#' Reading dta-files of older and newer versions than 13 was introduced
#'  with version 0.8.
#'
#' Stata 18 introduced alias variables and frame files. Alias variables are
#'  currently ignored when reading the file and a warning is printed. Stata
#'  frame files (file extension `.dtas`) contain zipped `dta` files which can
#'  be imported with \code{\link{read.dtas}}. 
#'
#' @return The function returns a data.frame with attributes. The attributes
#'  include
#' \describe{
#'   \item{datalabel:}{Dataset label}
#'   \item{time.stamp:}{Timestamp of file creation}
#'   \item{formats:}{Stata display formats. May be used with
#'    \code{\link{sprintf}}}
#'   \item{types:}{Stata data type (see Stata Corp 2014)}
#'   \item{val.labels:}{For each variable the name of the associated value
#'    labels in "label"}
#'   \item{var.labels:}{Variable labels}
#'   \item{version:}{dta file format version}
#'   \item{label.table:}{List of value labels.}
#'   \item{strl:}{Character vector with long strings for the new strl string
#'    variable type. The name of every element is the identifier.}
#'   \item{expansion.fields:}{list providing variable name, characteristic name
#'    and the contents of Stata characteristic field.}
#'   \item{missing:}{List of numeric vectors with Stata missing type for each
#'    variable.}
#'   \item{byteorder:}{Byteorder of the dta-file. LSF or MSF.}
#'   \item{orig.dim:}{Dimension recorded inside the dta-file.}
#' }
#' @note read.dta13 uses GPL 2 licensed code by Thomas Lumley and R-core members
#'  from foreign::read.dta().
#' @seealso \code{\link[foreign]{read.dta}} in package \code{foreign} and
#'  \code{memisc} for dta files from Stata
#' versions < 13 and \code{read_dta} in package \code{haven} for Stata version
#'  >= 13.
#' @references Stata Corp (2014): Description of .dta file format
#'  \url{https://www.stata.com/help.cgi?dta}
#' @examples
#' \dontrun{
#'   library(readstata13)
#'   r13 <- read.dta13("https://www.stata-press.com/data/r13/auto.dta")
#' }
#' @author Jan Marvin Garbuszus \email{jan.garbuszus@@ruhr-uni-bochum.de}
#' @author Sebastian Jeworutzki \email{sebastian.jeworutzki@@ruhr-uni-bochum.de}
#' @useDynLib readstata13, .registration = TRUE
#' @importFrom utils download.file
#' @importFrom stats na.omit
#' @export
read.dta13 <- function(file, convert.factors = TRUE, generate.factors=FALSE,
                       encoding = "UTF-8", fromEncoding=NULL,
                       convert.underscore = FALSE, missing.type = FALSE,
                       convert.dates = TRUE, replace.strl = TRUE,
                       add.rownames = FALSE, nonint.factors = FALSE,
                       select.rows = NULL, select.cols = NULL,
                       strlexport = FALSE, strlpath = ".", tz = "GMT") {

  # List to collect all warnings from factor conversion
  collected_warnings <- list(misslab = NULL, floatfact = NULL)

  # Check if path is a url
  if (length(grep("^(http|ftp|https)://", file))) {
    tmp <- tempfile()
    download.file(file, tmp, quiet = TRUE, mode = "wb")
    filepath <- tmp
    on.exit(unlink(filepath))
  } else {
    # construct filepath and read file
    filepath <- get.filepath(file)
  }
  if (!file.exists(filepath))
    stop("File not found.")



  # some select.row checks
  if (!is.null(select.rows)) {
    # check that it is a numeric
    if (!is.numeric(select.rows)){
      return(message("select.rows must be of type numeric"))
    } else {
      # guard against negative values
      if (any(select.rows < 0) )
        select.rows <- abs(select.rows)

      # check that length is not > 2
      if (length(select.rows) > 2)
        return(message("select.rows must be of length 1 or 2."))

      # if length 1 start at row 1
      if (length(select.rows) == 1)
        select.rows <- c(1, select.rows)
    }
    # reorder if 2 is bigger than 1
    if (select.rows[2] < select.rows[1])
      select.rows <- c(select.rows[2], select.rows[1])

    # make sure to start at index position 1 if select.rows[2] > 0
    if (select.rows[2] > 0 & select.rows[1] == 0)
      select.rows[1] <- 1
  } else {
    # set a value
    select.rows <- c(0,0)
  }

  select.cols_chr <- as.character(NA)
  select.cols_int <- as.integer(NA)

  # treat names and index differently
  if (!is.null(select.cols)) {

    if (is.character(select.cols))
      select.cols_chr <- select.cols

    # do we need factor too?
    if (is.numeric(select.cols) | is.integer(select.cols))
      select.cols_int <- select.cols
  }

  data <- stata_read(filepath, missing.type, select.rows,
                     select.cols_chr, select.cols_int,
                     strlexport, strlpath)

  version <- attr(data, "version")

  sstr     <- 2045
  sstrl    <- 32768
  salias   <- 65525
  sdouble  <- 65526
  sfloat   <- 65527
  slong    <- 65528
  sint     <- 65529
  sbyte    <- 65530

  if (version < 117) {
    sstr    <- 244
    sstrl   <- 255
    sdouble <- 255
    sfloat  <- 254
    slong   <- 253
    sint    <- 252
    sbyte   <- 251
  }

  if (convert.underscore)
    names(data) <- gsub("_", ".", names(data))

  types <- attr(data, "types")
  val.labels <- attr(data, "val.labels")
  label <- attr(data, "label.table")

  if (missing.type) {
    stata.na <- data.frame(type = sdouble:sbyte,
                           min = c(101, 32741, 2147483621, 2 ^ 127, 2 ^ 1023),
                           inc = c(1, 1, 1, 2 ^ 115, 2 ^ 1011)
    )

    if (version >= 113L & version < 117L) {
      missings <- vector("list", length(data))
      names(missings) <- names(data)
      for (v in which(types > 250L)) {
        this.type <- types[v] - 250L
        nas <- is.na(data[[v]]) | data[[v]] >= stata.na$min[this.type]
        natype <- (data[[v]][nas] - stata.na$min[this.type])/
          stata.na$inc[this.type]
        natype[is.na(natype)] <- 0L
        missings[[v]] <- rep(NA, NROW(data))
        missings[[v]][nas] <- natype
        data[[v]][nas] <- NA
      }
      attr(data, "missing") <- missings
    } else {
      if (version >= 117L) {
        missings <- vector("list", length(data))
        names(missings) <- names(data)
        for (v in which(types > 65525L)) {
          this.type <- 65531L - types[v]
          nas <- is.na(data[[v]]) |  data[[v]] >= stata.na$min[this.type]
          natype <- (data[[v]][nas] - stata.na$min[this.type]) /
            stata.na$inc[this.type]
          natype[is.na(natype)] <- 0L
          missings[[v]] <- rep(NA, NROW(data))
          missings[[v]][nas] <- natype
          data[[v]][nas] <- NA
        }
        attr(data, "missing") <- missings
      } else
        warning("'missing.type' only applicable to version >= 8 files")
    }
  }

  var.labels <- attr(data, "var.labels")
  datalabel <- attr(data, "data.label")

  ## Encoding
  if(!is.null(encoding)) {

    # set from encoding by dta version
    if(is.null(fromEncoding)) {
      fromEncoding <- "CP1252"
      if(attr(data, "version") >= 118L)
        fromEncoding <- "UTF-8"
    }
    
    attr(data, "data.label") <- read.encoding(datalabel, fromEncoding,
                                              encoding)

    # varnames
    names(data) <- read.encoding(names(data), fromEncoding, encoding)

    # var.labels
    attr(data, "var.labels") <- read.encoding(var.labels, fromEncoding,
                                              encoding)

    # val.labels
    names(val.labels) <- read.encoding(val.labels, fromEncoding, encoding)
    attr(data, "val.labels") <- val.labels

    # label
    names(label) <- read.encoding(names(label), fromEncoding, encoding)

    if (length(label) > 0) {
      for (i in 1:length(label))  {
        names(label[[i]]) <- read.encoding(names(label[[i]]), fromEncoding,
                                           encoding)
      }
      attr(data, "label.table") <- label
    }

    # recode character variables
    for (v in (1:ncol(data))[types <= sstr]) {
      data[, v] <- iconv(data[, v], from=fromEncoding, to=encoding, sub="byte")
    }

    # expansion.field
    efi <- attr(data, "expansion.fields")
    if (length(efi) > 0) {
      efiChar <- unlist(lapply(efi, is.character))
      for (i in (1:length(efi))[efiChar])  {
        efi[[i]] <- read.encoding(efi[[i]], fromEncoding, encoding)
      }
      attr(data, "expansion.fields") <- efi
    }

    if (version >= 117L) {
      #strl
      strl <- attr(data, "strl")
      if (length(strl) > 0) {
        for (i in 1:length(strl))  {
          strl[[i]] <- read.encoding(strl[[i]], fromEncoding, encoding)
        }
        attr(data, "strl") <- strl
      }
    }
  }

  var.labels <- attr(data, "var.labels")

  if (replace.strl & version >= 117L) {
    strl <- c("")
    names(strl) <- "00000000000000000000"
    strl <- c(strl, attr(data,"strl"))
    for (j in seq(ncol(data))[types == sstrl] ) {
      data[, j] <- strl[data[,j]]
    }
    # if strls are in data.frame remove attribute strl
    attr(data, "strl") <- NULL
  }


  if (convert.dates) {
    ff <- attr(data, "formats")
    ## dates <- grep("%-*d", ff)
    ## Stata 12 introduced 'business dates'
    ## 'Formats beginning with %t or %-t are Stata's date and time formats.'
    ## but it seems some are earlier.
    ## The dta_115 description suggests this is too inclusive:
    ## 'Stata has an old *%d* format notation and some datasets
    ##  still have them. Format *%d*... is equivalent to modern
    ##  format *%td*... and *%-d*... is equivalent to *%-td*...'

    dates <- grep("^%(-|)(d|td)", ff)
    ## avoid as.Date in case strptime is messed up
    base <- structure(-3653L, class = "Date") # Stata dates are integer vars
    for (v in dates) data[[v]] <- structure(base + data[[v]], class = "Date")

    for (v in grep("%tc", ff)) data[[v]] <- convert_dt_c(data[[v]], tz)
    for (v in grep("%tC", ff)) data[[v]] <- convert_dt_C(data[[v]], tz)
    for (v in grep("%tm", ff)) data[[v]] <- convert_dt_m(data[[v]])
    for (v in grep("%tq", ff)) data[[v]] <- convert_dt_q(data[[v]])
    for (v in grep("%ty", ff)) data[[v]] <- convert_dt_y(data[[v]])
  }

  if (convert.factors) {
    vnames <- names(data)
    for (i in seq_along(val.labels)) {
      labname <- val.labels[i]
      vartype <- types[i]
      labtable <- label[[labname]]
      #don't convert columns of type double or float to factor
      if (labname %in% names(label)) {
        if((vartype == sdouble | vartype == sfloat)) {
          if(!nonint.factors) {
            
            # collect variables which need a warning
            collected_warnings[["floatfact"]] <- c(collected_warnings[["floatfact"]], vnames[i])
            next
          }
        }
        # get unique values / omit NA
        varunique <- unique(as.character(na.omit(data[, i])))

        #check for duplicated labels
        labcount <- table(names(labtable))
        if(any(labcount > 1)) {
          
          # collect variables which need a warning
          collected_warnings[["dublifact"]] <- c(collected_warnings[["dublifact"]], vnames[i])

          labdups <- names(labtable) %in% names(labcount[labcount > 1])
          
          # generate unique labels from assigned label and code number
          names(labtable)[labdups] <- paste0(names(labtable)[labdups],
                                             "_(", labtable[labdups], ")")
        }

        # assign label if label set is complete
        if (all(varunique %in% labtable)) {
          data[, i] <- factor(data[, i], levels=labtable,
                              labels=names(labtable))
          # else generate labels from codes
        } else if (generate.factors) {

          names(varunique) <- varunique
          gen.lab  <- sort(c(varunique[!varunique %in% labtable], labtable))

          data[, i] <- factor(data[, i], levels=gen.lab,
                              labels=names(gen.lab))

          # add generated labels to label.table
          gen.lab.name <- paste0("gen_",vnames[i])
          attr(data, "label.table")[[gen.lab.name]] <- gen.lab
          attr(data, "val.labels")[i] <- gen.lab.name

        } else {
          # collect variables which need a warning
          collected_warnings[["misslab"]] <- c(collected_warnings[["mislab"]],
                                               vnames[i])
        }
      }
    }
  }

  if (add.rownames) {
    rownames(data) <- data[[1]]
    data[[1]] <- NULL
  }

  ## issue warnings
  #dublifact
  if(length(collected_warnings[["dublifact"]]) > 0) {
    dublifactvars <- paste(collected_warnings[["dublifact"]], collapse = ", ")
    
    warning(paste0("\n   Duplicated factor levels for variables\n\n",
                   paste(strwrap(dublifactvars, 
                                 width = 0.6 * getOption("width"), 
                                 prefix = "   "), 
                         collapse = "\n"),
                 "\n\n   Unique labels for these variables have been generated.\n"))
  }
  
  # floatfact
  if(length(collected_warnings[["floatfact"]]) > 0) {
    
    floatfactvars <- paste(collected_warnings[["floatfact"]], collapse = ", ")
    
    warning(paste0("\n   Factor codes of type double or float detected in variables\n\n",
              paste(strwrap(floatfactvars, 
                            width = 0.6 * getOption("width"), 
                            prefix = "   "), 
                    collapse = "\n"),
               "\n\n   No labels have been assigned.",
               "\n   Set option 'nonint.factors = TRUE' to assign labels anyway.\n"))
  }
  # misslab
  if(length(collected_warnings[["misslab"]]) > 0) {
    
    misslabvars <- paste(collected_warnings[["misslab"]], collapse = ", ")
    
    warning(paste0("\n   Missing factor labels for variables\n\n",
                   paste(strwrap(misslabvars, 
                                 width = 0.6 * getOption("width"), 
                                 prefix = "   "), 
                         collapse = "\n"),
                 "\n\n   No labels have been assigned.",
                 "\n   Set option 'generate.factors=TRUE' to generate labels."))
  }
  
  # return data.frame
  return(data)
}
