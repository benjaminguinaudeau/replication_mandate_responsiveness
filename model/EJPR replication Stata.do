
************** ANALYSES AT THE LEVEL OF MONTHS (USE MAIN.CSV) *************

** Prelimary work on variables **

* Compute Europeanization variable expressed in % *

generate europe_percent=europe*100

* Compute variable on coalition divergence of priorities expressed in % *

generate salience_diff_percent=salience_diff*100

* Define labels of the variable on the ideological composition of government *

label define ideo_govnom3 0 "SPD-Green" 2 "Grand coalition" 1 "CDU-FDP"
label values ideo_gov ideo_govnom3
tab year ideo_gov

* Define labels of the different variables on electoral cycles *

* Cycle distinguishing the six first and six last months of the term *
label define cyclenom 0 "Routine" 1 "Beginning" 2 "End"
label values elec_cycle_6 cyclenom

* Cycle distinguishing the six first and six last months of the term *
label values elec_cycle_9 cyclenom

* Cycle distinguishing the six first and six last months of the term *
label values elec_cycle_12 cyclenom

** MAIN MODELS **

xtset topic yearmonth

** Analyses in Table 1 **

* Model 1 *

xtpoisson n_laws c.salience_seat clp time i.ideo_gov i.elec_cycle_12, fe vce(robust)

* Model 2 *

xtpoisson n_laws c.salience_seat clp time i.elec_cycle_12 bundesratmaj rile_diff salience_diff_percent europe_percent, fe vce(robust)

* Model 3 *

xtpoisson n_laws c.salience_seat clp time i.elec_cycle_12 bundesratmaj rile_diff salience_diff_percent europe_percent account_balance_perc_l1, fe vce(robust)

* Model 4 *

xtpoisson n_laws c.salience_seat clp time i.elec_cycle_12 bundesratmaj rile_diff salience_diff_percent europe_percent account_balance_perc_l1 gov_pop_l1, fe vce(robust)


** Analyses in Table 2 **

* Model 5 *

xtpoisson n_laws c.salience_seat##c.europe_percent clp time i.elec_cycle_12 bundesratmaj rile_diff salience_diff_percent account_balance_perc_l1 gov_pop_l1, fe vce(robust)
margins, dydx(c.salience_seat) at(europe_percent=(0(10)80))
marginsplot

* Model 6 *

xtpoisson n_laws c.salience_seat##c.account_balance_perc_l1 clp time i.elec_cycle_12 bundesratmaj rile_diff salience_diff_percent europe_percent gov_pop_l1, fe vce(robust)
margins, dydx(c.salience_seat) at(account_balance_perc_l1=(-2(1)8))
marginsplot

* Model 7 *

xtpoisson n_laws c.salience_seat##i.bundesratmaj clp time i.elec_cycle_12 rile_diff salience_diff_percent europe_percent account_balance_perc_l1 gov_pop_l1, fe vce(robust)
margins i.bundesrat, dydx(salience_seat)
marginsplot

* Model 8 *

xtpoisson n_laws c.salience_seat##c.rile_diff clp time i.elec_cycle_12 bundesratmaj salience_diff_percent europe_percent account_balance_perc_l1 gov_pop_l1, fe vce(robust)
margins, dydx(c.salience_seat) at(rile_diff=(2(2)28))
marginsplot

* Model 9 *

xtpoisson n_laws c.salience_seat##c.salience_diff_percent clp time i.elec_cycle_12 bundesratmaj rile_diff europe_percent account_balance_perc_l1 gov_pop_l1, fe vce(robust)
margins, dydx(c.salience_seat) at(salience_diff=(0(1)15))
marginsplot

* Model 10 *

summarize gov_pop_l1
xtpoisson n_laws c.salience_seat##c.gov_pop_l1 clp time i.elec_cycle_12 bundesratmaj rile_diff salience_diff_percent europe_percent account_balance_perc_l1, fe vce(robust)
margins, dydx(c.salience_seat) at(gov_pop_l1=(-1.5(0.5)1.5))
marginsplot


** MODELS APPENDIX (ALTERNATIVE SPECIFICATIONS) **

* Model 22 *

xtpoisson n_laws c.salience_gov clp time i.elec_cycle_12 gov_pop_l1 bundesratmaj rile_diff salience_diff_percent europe_percent account_balance_perc_l1, fe vce(robust)

* Model 23 *

xtpoisson n_laws c.salience_perc clp time i.elec_cycle_12 gov_pop_l1 bundesratmaj rile_diff salience_diff_percent europe_percent account_balance_perc_l1, fe vce(robust)

* Model 24 *

xtpoisson n_laws c.salience_chanc clp time i.elec_cycle_12 gov_pop_l1 bundesratmaj rile_diff salience_diff_percent europe_percent account_balance_perc_l1, fe vce(robust)

* Model 25 *

xtpoisson n_laws c.salience_partner clp time i.elec_cycle_12 gov_pop_l1 bundesratmaj rile_diff salience_diff_percent europe_percent account_balance_perc_l1, fe vce(robust)

* Model 26 *

xtpoisson n_laws c.salience_seat clp time i.elec_cycle_12 gov_pop_delta bundesratmaj rile_diff salience_diff_percent europe_percent account_balance_perc_l1, fe vce(robust)

* Model 27 *
summarize gov_pop_delta
xtpoisson n_laws c.salience_seat##c.gov_pop_delta clp time i.elec_cycle_12 bundesratmaj rile_diff salience_diff_percent europe_percent account_balance_perc_l1, fe vce(robust)
margins, dydx(c.salience_seat) at(gov_pop_delta=(-0.8(0.2)0.8))
marginsplot

********** EXCLUDING EU-INFLUENCED LAWS FOR APPENDIX (USE NOEU.CSV) ************

* Model 28 *

xtpoisson n_laws c.salience_seat clp time i.elec_cycle_12 gov_pop_l1 bundesratmaj rile_diff salience_diff_percent europe_percent account_balance_perc_l1, fe vce(robust)


************** TERM LEVEL ANALYSES FOR APPENDIX (USE TERM_LEVEL.CSV) ***********

** Compute Europeanization variable expressed in % **

generate europe_percent=europe*100
summarize europe_percent


** Compute variable on coalition divergence of priorities expressed in % **

generate salience_diff_percent=salience_diff*100
summarize salience_diff_percent

** Model 17 (Replication Model 3) **s
xtset topic election
xtpoisson n_laws c.salience_seat time europe_percent account_balance_perc rile_diff salience_diff_percent, fe vce(robust)


