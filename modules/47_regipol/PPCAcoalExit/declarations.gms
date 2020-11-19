*** |  (C) 2006-2019 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of REMIND and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  REMIND License Exception, version 1.0 (see LICENSE file).
*** |  Contact: remind@pik-potsdam.de
*** SOF ./modules/47_regipol/PPCAcoalExit/declarations.gms

$ifthen.dem %cm_PPCA_pol% == "demand"
parameters
p47_co2steel_ref(ttot,all_regi)                                     "CO2 emissions from steel in reference scenario"
;

variables
v47_emiTeDetail(ttot,all_regi,all_enty,all_enty,all_te,all_enty)     "CO2 emissions from energy technologies in reference scenario"
;

equations
* q47_emi_co2steel(ttot,all_regi)                             "CO2 emissions from steel production"
* q47_ref_emi_steel(ttot,all_regi)                            "Limit CO2 emissions from steel production to reference scenario"
$ifthen.OECD %cm_PPCA_OECD% == "on"
q47_PPCA_OECD_demand_exit(ttot,all_regi)                    "OECD PPCA coal demand exit, represented as a maximum regional share of coal in total emissions after 2030"
* q47_PPCA_OECD_coaltr_lim(ttot,all_regi)                         "Metallurgical coal demand still permitted in OECD PPCA members until 2050"
$endif.OECD
$ifthen.nonOECD %cm_PPCA_nonOECD% == "on"
q47_PPCA_nonOECD_demand_exit(ttot,all_regi)                 "Non-OECD PPCA coal demand exit, represented as a maximum regional share of coal in total emissions after 2050"
* q47_PPCA_nonOECD_coaltr_lim(ttot,all_regi)                         "Metallurgical coal demand still permitted in non-OECD PPCA members until 2070"
$endif.nonOECD
;

$endif.dem


equations
$ifthen.power %cm_PPCA_pol% == "power"
$ifthen.OECDon %cm_PPCA_OECD% == "on"
q47_PPCA_OECD_power_phaseOut(ttot,all_regi)                "OECD PPCA coal power exit, represented as a maximum regional coal share in electricity after 2030"
$endif.OECDon
$ifthen.nonOECDon %cm_PPCA_nonOECD% == "on"
q47_PPCA_nonOECD_power_phaseOut(ttot,all_regi)            "Non-OECD PPCA coal power exit, represented as a maximum regional coal share in electricity after 2050"
$endif.nonOECDon
$endif.power

$ifthen.cov not %cm_COVID_coal_scen% == "none"
q47_CovidCoalCap(ttot,all_regi,cov_coal)                                  "2025 post-COVID Coal capacity scenarios upper limit"
q47_CovidCoalFloor(ttot,all_regi,cov_coal)                                "2025 post-COVID Coal capacity scenarios lower limit"
$endif.cov
;

*** EOF ./modules/47_regipol/PPCAcoalExit/declarations.gms