if (require("testthat") && require("effectsize")) {
  test_that("interpret", {
    rules_grid <- rules(c(0.01, 0.05), c("very significant", "significant", "not significant"))
    testthat::expect_equal(interpret(0.001, rules_grid)[1], "very significant")
    testthat::expect_equal(interpret(0.021, rules_grid)[1], "significant")
    testthat::expect_equal(interpret(0.08, rules_grid)[1], "not significant")
    testthat::expect_equal(interpret(c(0.01, 0.005, 0.08), rules_grid)[1:3], c("very significant", "very significant", "not significant"))
    testthat::expect_error(interpret_r(0.6, rules(c(0.5), c("A", "B", "C"))))
    testthat::expect_error(interpret_r(0.6, rules(c(0.5, 0.2, 0.7), c("A", "B", "C", "D"))))


    r1 <- rules(c(0, 1), labels = c("some", "few", "many"))
    r2 <- rules(c(0, 1), labels = c("some", "few", "many"), right = FALSE)

    testthat::expect_equal(interpret(c(0, 1), r1)[], c("some", "few"), ignore_attr = TRUE)
    testthat::expect_equal(interpret(c(0, 1), r2)[], c("few", "many"), ignore_attr = TRUE)
  })


  test_that("interpret_r", {
    testthat::expect_equal(interpret_r(0.21)[1], "medium")
    testthat::expect_equal(interpret_r(0.21, "cohen1988")[1], "small")
    testthat::expect_equal(interpret_r(0.7, "evans1996")[1], "strong")
    testthat::expect_equal(interpret_r(c(0.5, -0.08), "cohen1988")[1:2], c("large", "very small"))
    testthat::expect_equal(interpret_r(0.6, rules(c(0.5), c("A", "B")))[1], "B")
    testthat::expect_error(interpret_r(0.6, "DUPA"))
  })



  test_that("interpret_p", {
    testthat::expect_equal(interpret_p(0.021)[1], "significant")
    testthat::expect_equal(interpret_p(0.08)[1], "not significant")
    testthat::expect_equal(interpret_p(c(0.01, 0.08))[1:2], c("significant", "not significant"))
    testthat::expect_equal(interpret_p(0.6, rules(c(0.5), c("A", "B")))[1], "B")
    testthat::expect_error(interpret_p(0.6, "DUPA"))
  })


  test_that("interpret_direction", {
    testthat::expect_equal(interpret_direction(c(0.01, -0.08))[1:2], c("positive", "negative"))
  })


  test_that("interpret_d", {
    testthat::expect_equal(interpret_d(0.021)[1], "very small")
    testthat::expect_equal(interpret_d(1.3, "sawilowsky2009")[1], "very large")
    testthat::expect_equal(interpret_d(c(0.45, 0.85), "cohen1988")[1:2], c("small", "large"))
    testthat::expect_equal(interpret_d(0.6, rules(c(0.5), c("A", "B")))[1], "B")
    testthat::expect_error(interpret_d(0.6, "DUPA"))
  })



  test_that("interpret_rope", {
    testthat::expect_equal(interpret_rope(0, ci = 0.9)[1], "significant")
    testthat::expect_equal(interpret_rope(c(0.50, 1), ci = 0.9)[1:2], c("undecided", "negligible"))
    testthat::expect_equal(interpret_rope(c(0.98, 0.991), ci = 1)[1:2], c("probably negligible", "negligible"))
    testthat::expect_equal(interpret_rope(0.6, , rules(c(0.5), c("A", "B")))[1], "B")
    testthat::expect_error(interpret_rope(0.6, , "DUPA"))
  })


  test_that("interpret_oddsratio", {
    testthat::expect_equal(interpret_oddsratio(2)[1], "small")
    testthat::expect_equal(interpret_oddsratio(c(1, 3))[1:2], c("very small", "small"))
    testthat::expect_equal(interpret_oddsratio(c(1, 3), "cohen1988")[1:2], c("very small", "medium"))
    testthat::expect_equal(interpret_oddsratio(0.6, rules(c(0.5), c("A", "B")))[1], "B")
    testthat::expect_error(interpret_oddsratio(0.6, "DUPA"))
  })


  test_that("interpret_r2", {
    testthat::expect_equal(interpret_r2(0.4)[1], "substantial")
    testthat::expect_equal(interpret_r2(c(0, 0.4), "falk1992")[1:2], c("negligible", "adequate"))
    testthat::expect_equal(interpret_r2(c(0.1, 0.4), "chin1998")[1:2], c("very weak", "moderate"))
    testthat::expect_equal(interpret_r2(c(0.1, 0.4), "hair2011")[1:2], c("very weak", "weak"))
    testthat::expect_equal(interpret_r2(0.6, rules(c(0.5), c("A", "B")))[1], "B")
    testthat::expect_error(interpret_r2(0.6, "DUPA"))
  })


  test_that("interpret_bf", {
    testthat::expect_warning(interpret_bf(-2))
    testthat::expect_equal(interpret_bf(1)[1], "no evidence against or in favour of")
    testthat::expect_equal(interpret_bf(c(0.8, 3.5), "jeffreys1961")[1:2], c("anecdotal evidence against", "moderate evidence in favour of"))
    testthat::expect_equal(interpret_bf(c(0.8, 3.5), "raftery1995")[1:2], c("weak evidence against", "positive evidence in favour of"))
    testthat::expect_equal(interpret_bf(2, rules(c(0.5), c("A", "B")))[1], "B evidence in favour of")
    testthat::expect_error(interpret_bf(2, "DUPA"))

    testthat::skip_on_cran() # just in case there are changes in insight
    bf <- c(10^seq(-4,4), NA)
    testthat::expect_equal(interpret_bf(bf, include_value = TRUE, protect_ratio = TRUE, exact = TRUE),
                           c("extreme evidence (BF = 1/1.00e+04) against", "extreme evidence (BF = 1/1000.00) against",
                             "very strong evidence (BF = 1/100.00) against", "moderate evidence (BF = 1/10.00) against",
                             "no evidence (BF = 1.00) against or in favour of", "strong evidence (BF = 10.00) in favour of",
                             "extreme evidence (BF = 100.00) in favour of", "extreme evidence (BF = 1000.00) in favour of",
                             "extreme evidence (BF = 1.00e+04) in favour of", ""),
                           ignore_attr = TRUE)
  })



  test_that("interpret_omega_squared", {
    testthat::expect_equal(interpret_omega_squared(0.1)[1], "medium")
    testthat::expect_equal(interpret_omega_squared(c(0.1, 0.25))[1:2], c("medium", "large"))
    testthat::expect_equal(interpret_omega_squared(0.6, rules(c(0.5), c("A", "B")))[1], "B")
    testthat::expect_error(interpret_omega_squared(0.6, "DUPA"))
  })



  test_that("interpret_rhat", {
    testthat::expect_equal(interpret_rhat(1)[1], "converged")
    testthat::expect_equal(interpret_rhat(c(1, 1.02))[1:2], c("converged", "failed"))
    testthat::expect_equal(interpret_rhat(c(1, 1.02), "gelman1992")[1:2], c("converged", "converged"))
    testthat::expect_equal(interpret_rhat(0.6, rules(c(0.5), c("A", "B")))[1], "B")
    testthat::expect_error(interpret_rhat(0.6, "DUPA"))
  })


  test_that("interpret_ess", {
    testthat::expect_equal(interpret_ess(1000)[1], "sufficient")
    testthat::expect_equal(interpret_ess(c(1000, 800))[1:2], c("sufficient", "insufficient"))
    testthat::expect_equal(interpret_ess(0.6, rules(c(0.5), c("A", "B")))[1], "B")
    testthat::expect_error(interpret_ess(0.6, "DUPA"))
  })
}
