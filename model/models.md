Models estimated in R
================

This markdown contains the code to replicate the models estimated in R.
For the models estimated in Stata, please consult the do-file.

## Package

``` r
pacman::p_load(tidyverse, pglm, pscl, MASS)
```

## Data

``` r
df <- readr::read_csv("../data/monthly.csv", show_col_types = FALSE)
df_term <- readr::read_csv("../data/term_level.csv", show_col_types = FALSE)
df_no_eu <- readr::read_csv("../data/no_eu.csv", show_col_types = FALSE)
df_perc <- readr::read_csv("../data/salience_percentage.csv", show_col_types = FALSE)
```

## Models

### Alternative model specifications

``` r
formula_3 <- n_laws ~ salience_seat + clp + time + elec_cycle_12 + gov_pop_l1 + 
  europe + account_balance_perc_l1 +
  bundesratmaj + rile_diff + salience_diff 

formula_fe <- n_laws ~ salience_seat + clp + time + elec_cycle_12 + gov_pop_l1 +
  europe + account_balance_perc_l1 +
  bundesratmaj +  rile_diff + salience_diff +
  topic

# 11: Poisson without FE
fit_po <- glm(formula_3, data = df, family = "poisson")

# 12: Poisson with FE
fit_po_fe <- glm(formula_fe, data = df, family = "poisson")

# 13: Negative binomial without FE
fit_nb <- MASS::glm.nb(formula_3, data = df)

# 14: Negative binomial with FE
fit_nb_fe <- MASS::glm.nb(formula_fe, data = df)

# 15: Zero-Inflated Negative binomial without FE
fit_zi <- zeroinfl(formula_3, data = df, dist = "negbin")

# 16: Zero-Inflated Negative binomial with FE
fit_zi_fe <- zeroinfl(formula_fe, data = df, dist = "negbin")
```

### Term-level models

``` r
formula_gov <- n_laws ~ salience_seat + time + 
  europe + account_balance_perc + rile_diff + salience_diff 

formula_gov_fe <- n_laws ~ salience_seat + time + 
  europe + account_balance_perc + rile_diff + salience_diff + topic

# 18: Term_level NegBin without FE
fit_nb <- MASS::glm.nb(formula_gov, data = df_term)

# 19: Term_level NegBin with FE
fit_nb_fe <- MASS::glm.nb(formula_gov_fe, data = df_term)
```

### Alternative operationalization of the dependent variable

``` r
formula_gov <- law_prop ~ salience_seat + time + 
  europe + account_balance_perc + rile_diff + salience_diff 

formula_gov_fe <- law_prop ~ salience_seat + time + 
  europe + account_balance_perc + rile_diff + salience_diff +
  topic

# 20: OLS without FE
fit_gov_perc <- lm(formula = formula_gov, data = df_perc)

# 21: OLS with FE
fit_gov_perc_fe <- lm(formula = formula_gov_fe, data = df_perc)
```

### Exclusion of laws influenced by the EU

``` r
# 29: Poisson without FE
fit_noeu_po <- glm(formula_3, data = df_no_eu, family = "poisson")

# 30: Poisson with FE
fit_noeu_po_fe <- glm(formula_fe, data = df_no_eu, family = "poisson")

# 31: Negative binomial without FE
fit_noeu_nb <- MASS::glm.nb(formula_3, data = df_no_eu)

# 32: Negative binomial with FE
fit_noeu_nb_fe <- MASS::glm.nb(formula_fe, data = df_no_eu)

# 33: Zero-Inflated Negative binomial without FE
fit_noeu_zi <- pscl::zeroinfl(formula_3, data = df_no_eu, dist = "negbin")

# 34: Zero-Inflated Negative binomial with FE
fit_noeu_zi_fe <- pscl::zeroinfl(formula_fe, data = df_no_eu, dist = "negbin")
```
