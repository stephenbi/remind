*** |  (C) 2006-2019 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of REMIND and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  REMIND License Exception, version 1.0 (see LICENSE file).
*** |  Contact: remind@pik-potsdam.de
*** SOF ./modules/47_regipol/PPCAcoalExit/declarations.gms

equations
$ifthen.OECD %cm_PPCA_OECD% == "on"
q47_PPCA_OECD_power_phaseOut(ttot,all_regi,all_enty,all_enty)    "The PPCA coal power exit is represented as a maximum coal share in electricity by region, which OECD member nations achieve by 2030"
$endif.OECD
$ifthen.nonOECD %cm_PPCA_nonOECD% == "on"
q47_PPCA_nonOECD_power_phaseOut(ttot,all_regi,all_enty,all_enty)           "Non-OECD members of the PPCA must phase out coal by 2050, so regions are bounded by a new maximum coal share in electricity afterward"
$endif.nonOECD

$ifthen not %cm_COVID_coal_scen% == "none"
q47_CovidCoalCap(ttot,all_regi,COV_coal)                                  "2025 post-COVID Coal capacity scenarios"
$endif
;


*** EOF ./modules/47_regipol/PPCAcoalExit/declarations.gms