// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <Rcpp.h>

using namespace Rcpp;

// stata_pre13_save
int stata_pre13_save(const char * filePath, Rcpp::DataFrame dat);
RcppExport SEXP readstata13_stata_pre13_save(SEXP filePathSEXP, SEXP datSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const char * >::type filePath(filePathSEXP);
    Rcpp::traits::input_parameter< Rcpp::DataFrame >::type dat(datSEXP);
    rcpp_result_gen = Rcpp::wrap(stata_pre13_save(filePath, dat));
    return rcpp_result_gen;
END_RCPP
}
// stata_read
List stata_read(const char * filePath, const bool missing);
RcppExport SEXP readstata13_stata_read(SEXP filePathSEXP, SEXP missingSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const char * >::type filePath(filePathSEXP);
    Rcpp::traits::input_parameter< const bool >::type missing(missingSEXP);
    rcpp_result_gen = Rcpp::wrap(stata_read(filePath, missing));
    return rcpp_result_gen;
END_RCPP
}
// stata_save
int stata_save(const char * filePath, Rcpp::DataFrame dat);
RcppExport SEXP readstata13_stata_save(SEXP filePathSEXP, SEXP datSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const char * >::type filePath(filePathSEXP);
    Rcpp::traits::input_parameter< Rcpp::DataFrame >::type dat(datSEXP);
    rcpp_result_gen = Rcpp::wrap(stata_save(filePath, dat));
    return rcpp_result_gen;
END_RCPP
}
