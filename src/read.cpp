/*
 * Copyright (C) 2014-2025 Jan Marvin Garbuszus and Sebastian Jeworutzki
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation; either version 2 of the License, or (at your
 * option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#include <readstata.h>

using namespace Rcpp;

// Reads the binary Stata file
//
// @param filePath The full systempath to the dta file you want to import.
// @param missing logical if missings should be converted outside of Rcpp.
// @import Rcpp
// @export
// [[Rcpp::export]]
List stata_read(const char * filePath, const bool missing,
                const IntegerVector selectrows,
                const CharacterVector selectcols_chr,
                const IntegerVector selectcols_int,
                const bool strlexport, const CharacterVector strlpath)
{
  FILE *file = NULL;    // File pointer

  /*
   * Open the file in binary mode using the "rb" format string
   * This also checks if the file exists and/or can be opened for reading
   * correctly
   */

  if ((file = fopen(filePath, "rb")) == NULL)
    throw std::range_error("Could not open specified file.");

  /*
   * check the first byte.
   */

  std::string fbit(1, '\0');
  readstring(fbit, file, fbit.size());

  std::string expfbit = "<";

  // create df
  List df(0);

  if (fbit.compare(expfbit) == 0)
    df = read_dta(file, missing, selectrows,
                  selectcols_chr, selectcols_int,
                  strlexport, strlpath);
  else
    df = read_pre13_dta(file, missing, selectrows,
                        selectcols_chr, selectcols_int);

  fclose(file);

  return df;
}
