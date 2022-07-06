
<!-- README.md is generated from README.Rmd. Please edit that file -->

This repo contains the replication material for the journal article
‘(When) do Electoral Mandates Set the Agenda? Government Capacity and
Mandate Responsiveness in Germany’ published in the European Journal of
Political Research

## Structure of the repo

The repo consists in three different folders:

-   [data]() : data required to replicate our findings
-   [models]() : do-file and r-script to replicate the models
-   [figures]() : R-Code to replicate the figures

Because Panel-Poisson Regression with FE is not properly implemented in
R, we estimated some of the models in Stata. For this reason, the
replication code mixes do-files and R-Script.

## Packages

``` r
library(tidyverse, quietly = T)
#> ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.0 ──
#> ✓ ggplot2 3.3.5     ✓ purrr   0.3.4
#> ✓ tibble  3.1.6     ✓ dplyr   1.0.7
#> ✓ tidyr   1.1.3     ✓ stringr 1.4.0
#> ✓ readr   1.4.0     ✓ forcats 0.5.0
#> ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
#> x dplyr::filter() masks stats::filter()
#> x dplyr::lag()    masks stats::lag()
```

## Data

The main arguments of our paper is tested at the month level. It hence
includes data for the most important variables at the month X topic
level. It is provided as a csv-file, named ‘monthly.csv’.

It contains following columns:

-   n\_laws: Number of laws adopted in a given month in a given topic
-   month: Concerned Month
-   topic: Concerned CAP Topic
-   salience\_seat: Average salience of the topic in the manifestos of
    the coalition partners (weighted by number of seats)
-   clp: Cumulative Law Production
-   time: Cumulative number of months since beginning of the dataset
-   ideo\_gov: Ideological orientation of a coalition (‘Scharz-Gelb’,
    ‘Rot-Grün’, ‘Big coalition’)
-   gov\_pop\_l1: Average government popularity in the last six months
-   mip\_share\_l1: Proportion of ‘Most-Important Problem’ in a given
    topics in the last six months
-   bundesratmaj: 1 if the governing coalition enjoyed majority in the
    Bundesrat
-   elec\_cycle\_12: Elecotral cycle (First 12 months/Routine/Last 12
    months)
-   rile\_diff: Absolute difference between the left-right position of
    coalition partners
-   salience\_diff: Absolute difference between the salience of a given
    topic in the manifestos of the coalition partners
-   europe: Percentage of laws within a topic within a given period
    influenced by the EU
-   account\_balance\_perc\_l1: Budget account balance in the last six
    months
-   salience\_chanc: Salience of the topic in the manifesto of the
    chancellor party
-   salience\_partner: Salience of the topic in the manifesto of the
    junior partner
-   salience\_gov: Average salience of the topic in the manifestos of
    the coalition partners (no weights)
-   salience\_perc: Average salience of the topic in the manifestos of
    the coalition partners (weighted by each party’s vote percentage)

``` r
readr::read_csv("data/monthly.csv") %>% glimpse
#> 
#> ── Column specification ────────────────────────────────────────────────────────
#> cols(
#>   n_laws = col_double(),
#>   month = col_date(format = ""),
#>   topic = col_double(),
#>   salience_seat = col_double(),
#>   clp = col_double(),
#>   time = col_double(),
#>   ideo_gov = col_double(),
#>   gov_pop_l1 = col_double(),
#>   mip_share_l1 = col_double(),
#>   bundesratmaj = col_double(),
#>   elec_cycle_12 = col_double(),
#>   rile_diff = col_double(),
#>   salience_diff = col_double(),
#>   europe = col_double(),
#>   account_balance_perc_l1 = col_double(),
#>   salience_chanc = col_double(),
#>   salience_partner = col_double(),
#>   salience_gov = col_double(),
#>   salience_perc = col_double()
#> )
#> Rows: 7,106
#> Columns: 19
#> $ n_laws                  <dbl> 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0…
#> $ month                   <date> 1983-09-01, 1983-09-01, 1983-09-01, 1983-09-0…
#> $ topic                   <dbl> 12, 2420, 1, 15, 19, 4, 13, 14, 16, 8, 10, 2, …
#> $ salience_seat           <dbl> 3.1779792, 4.1083406, 17.6766180, 3.7491338, 1…
#> $ clp                     <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0…
#> $ time                    <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…
#> $ ideo_gov                <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…
#> $ gov_pop_l1              <dbl> 0.6764418, 0.6764418, 0.6764418, 0.6764418, 0.…
#> $ mip_share_l1            <dbl> 3.50379, 0.75758, 34.65910, 0.00000, 10.70076,…
#> $ bundesratmaj            <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…
#> $ elec_cycle_12           <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…
#> $ rile_diff               <dbl> 25.927, 25.927, 25.927, 25.927, 25.927, 25.927…
#> $ salience_diff           <dbl> 0.0067050311, 0.0068333013, 0.1241538542, 0.02…
#> $ europe                  <dbl> 0.11428571, 0.03125000, 0.10000000, 0.36363636…
#> $ account_balance_perc_l1 <dbl> 0.712464, 0.712464, 0.712464, 0.712464, 0.7124…
#> $ salience_chanc          <dbl> 3.0959752, 4.0247678, 19.1950464, 3.4055728, 1…
#> $ salience_partner        <dbl> 3.7664783, 4.7080979, 6.7796610, 6.2146893, 11…
#> $ salience_gov            <dbl> 3.4312268, 4.3664329, 12.9873537, 4.8101310, 1…
#> $ salience_perc           <dbl> 3.1795911, 4.1099833, 17.6467707, 3.7558871, 1…
```

We also provide a file aggregated at the level of the term to replicate
some of the results presented in the appendix. It contains following
variables:

-   n\_laws: Number of laws adopted in a given term in a given topic
-   topic: Concerned CAP Topic
-   salience\_seat: Average salience of the topic in the manifestos of
    the coalition partners (weighted by number of seats)
-   time: Number of terms since the beginning of the dataset
-   europe: Proportion of laws within a given topic and a given term
    influenced by the European Union
-   mip\_share: Proportion of ‘Most-Important Problem’ in a given topics
    in a given term
-   account\_balance\_perc: Average Budget account balance
-   rile\_diff: Absolute difference between the left-right position of
    coalition partners
-   salience\_diff: Absolute difference between the salience of a given
    topic in the manifestos of the coalition partners

``` r
readr::read_csv("data/term_level.csv") %>%
  glimpse
#> 
#> ── Column specification ────────────────────────────────────────────────────────
#> cols(
#>   n_laws = col_double(),
#>   topic = col_double(),
#>   salience_seat = col_double(),
#>   time = col_double(),
#>   europe = col_double(),
#>   mip_share = col_double(),
#>   account_balance_perc = col_double(),
#>   rile_diff = col_double(),
#>   salience_diff = col_double()
#> )
#> Rows: 171
#> Columns: 9
#> $ n_laws               <dbl> 65, 40, 84, 22, 5, 61, 16, 9, 9, 36, 25, 58, 0, 2…
#> $ topic                <dbl> 1, 10, 12, 13, 14, 15, 16, 17, 18, 19, 2, 2420, 2…
#> $ salience_seat        <dbl> 10.1658546, 3.3332858, 9.0178376, 6.4178301, 3.43…
#> $ time                 <dbl> 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8…
#> $ europe               <dbl> 0.3247694, 0.5689024, 0.3392430, 0.2530785, 0.278…
#> $ mip_share            <dbl> 2.682776e+01, 4.942032e-01, 3.374553e+00, 5.24879…
#> $ account_balance_perc <dbl> 6.389846, 6.389846, 6.389846, 6.389846, 6.389846,…
#> $ rile_diff            <dbl> 4.452, 4.452, 4.452, 4.452, 4.452, 4.452, 4.452, …
#> $ salience_diff        <dbl> 0.032144306, 0.012690077, 0.038148504, 0.03364001…
```
