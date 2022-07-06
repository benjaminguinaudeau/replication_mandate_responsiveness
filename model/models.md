Models estimated in R
================

This repo contains the r-code to replicate the models estimated in R.
For the models, estimated in Stata please consult the do-file.

## Package

``` r
# devtools::install_github("benjaminguinaudeau/margins.pglm")
pacman::p_load(tidyverse, pglm, margins.pglm, pscl)
```

## Data

``` r
df <- readr::read_csv("../data/monthly.csv")
```

    ## 
    ## ── Column specification ────────────────────────────────────────────────────────
    ## cols(
    ##   n_laws = col_double(),
    ##   month = col_date(format = ""),
    ##   topic = col_double(),
    ##   salience_seat = col_double(),
    ##   clp = col_double(),
    ##   time = col_double(),
    ##   ideo_gov = col_double(),
    ##   gov_pop_l1 = col_double(),
    ##   mip_share_l1 = col_double(),
    ##   bundesratmaj = col_double(),
    ##   elec_cycle_12 = col_double(),
    ##   rile_diff = col_double(),
    ##   salience_diff = col_double(),
    ##   europe = col_double(),
    ##   account_balance_perc_l1 = col_double(),
    ##   salience_chanc = col_double(),
    ##   salience_partner = col_double(),
    ##   salience_gov = col_double(),
    ##   salience_perc = col_double()
    ## )

## Models

``` r
formula_3 <- n_laws ~ salience_seat + clp + time + elec_cycle_12 + gov_pop_l1 + 
    # mip_share_l1 + 
  bundesratmaj + rile_diff + salience_diff + 
    europe + account_balance_perc_l1

formula_fe <- n_laws ~ salience_seat + clp + time + elec_cycle_12 + gov_pop_l1 + #mip_share_l1 + 
  europe + account_balance_perc_l1 +
  bundesratmaj + 
  rile_diff +
  salience_diff +
  topic

# 11: Poisson wiithout FE
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
