*** |  (C) 2006-2019 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of REMIND and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  REMIND License Exception, version 1.0 (see LICENSE file).
*** |  Contact: remind@pik-potsdam.de
*** SOF ./modules/47_regipol/PPCAcoalExit/datainput.gms

parameter p47_coalCapCOVID(tall,all_regi,COV_coal) "2025 coal capacity scenarios based on COVID recovery scenarios"
/
$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/p47_coalCapCOVID_mar10.cs4r"
* $include "./modules/47_regipol/PPCAcoalExit/input/p47_coalCapCOVID.cs4r"
$offdelim
/
;

* *** PPCA coal exit scenario cascade should all have the same C price but includes runs with different startyears
* $ifthen.ppca %cm_PPCA_nonOECD% == "on"
* Execute_Loadpoint "input_opt" pm_taxCO2eq = pm_taxCO2eq;
* $endif.ppca


$ifthen.phase1 %cm_PPCA_OECD% == "on"

$ifthen.polscen %cm_PPCA_pol% == "power"
*** 2030 OECD PPCA phase-out
parameter p47_max_coal_el_share_oecd(all_regi)    "Maximum share of met coal emissions from total coal emissions after the OECD phases out steel sector coal demand"
/
$ifthen.recovery1 %cm_COVID_coal_scen% == "none"
$ifthen.coalition %cm_PPCA_size% == "current"
$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_OECD_noCOV_power_current.cs4r"
$offdelim

$elseif.coalition %cm_PPCA_size% == "1p"
$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_OECD_noCOV_power_1p.cs4r"
$offdelim

$elseif.coalition %cm_PPCA_size% == "2p"
$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_OECD_noCOV_power_2p.cs4r"
$offdelim

$elseif.coalition %cm_PPCA_size% == "3p"
$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_OECD_noCOV_power_3p.cs4r"
$offdelim

$endif.coalition
$endif.recovery1

$ifthen.recovery %cm_COVID_coal_scen% == "BAU"
$ifthen.coalition1 %cm_PPCA_size% == "current"
$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_OECD_BAU_power_current.cs4r"
$offdelim

$elseif.coalition1 %cm_PPCA_size% == "1p"
$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_OECD_BAU_power_1p.cs4r"
$offdelim

$elseif.coalition1 %cm_PPCA_size% == "2p"
$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_OECD_BAU_power_2p.cs4r"
$offdelim

$elseif.coalition1 %cm_PPCA_size% == "3p"
$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_OECD_BAU_power_3p.cs4r"
$offdelim

$endif.coalition1
$endif.recovery

$ifthen.recovery2 %cm_COVID_coal_scen% == "Brown"

$ifthen.coalition2 %cm_PPCA_size% == "current"
$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_OECD_Brown_power_current.cs4r"
$offdelim

$elseif.coalition2 %cm_PPCA_size% == "1p"
$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_OECD_Brown_power_1p.cs4r"
$offdelim

$elseif.coalition2 %cm_PPCA_size% == "2p"
$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_OECD_Brown_power_2p.cs4r"
$offdelim

$elseif.coalition2 %cm_PPCA_size% == "3p"
$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_OECD_Brown_power_3p.cs4r"
$offdelim

$endif.coalition2
$endif.recovery2

$ifthen.recovery3 %cm_COVID_coal_scen% == "Green"

$ifthen.coalition3 %cm_PPCA_size% == "current"
$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_OECD_Green_power_current.cs4r"
$offdelim

$elseif.coalition3 %cm_PPCA_size% == "1p"
$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_OECD_Green_power_1p.cs4r"
$offdelim

$elseif.coalition3 %cm_PPCA_size% == "2p"
$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_OECD_Green_power_2p.cs4r"
$offdelim

$elseif.coalition3 %cm_PPCA_size% == "3p"
$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_OECD_Green_power_3p.cs4r"
$offdelim

$endif.coalition3
$endif.recovery3
/
;

$elseif.polscen %cm_PPCA_pol% == "demand"
*** Demand Exit policy scenarios
*** 2030 OECD PPCA phase-out
parameter p47_max_coal_dem_share_oecd(all_regi,dem_sector)    "Maximum share of met coal emissions from total coal emissions after the OECD phases out steel sector coal demand"
/
$ifthen.recovery7 %cm_COVID_coal_scen% == "BAU"
$ifthen.coalition7 %cm_PPCA_size% == "current"
$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_OECD_BAU_demand_current.cs4r"
$offdelim

$elseif.coalition7 %cm_PPCA_size% == "1p"

$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_OECD_BAU_demand_1p.cs4r"
$offdelim


$elseif.coalition7 %cm_PPCA_size% == "2p"

$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_OECD_BAU_demand_2p.cs4r"
$offdelim


$elseif.coalition7 %cm_PPCA_size% == "3p"

$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_OECD_BAU_demand_3p.cs4r"
$offdelim

$endif.coalition7
$endif.recovery7

$ifthen.recovery8 %cm_COVID_coal_scen% == "Brown"

$ifthen.coalition8 %cm_PPCA_size% == "current"

$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_OECD_Brown_demand_current.cs4r"
$offdelim


$elseif.coalition8 %cm_PPCA_size% == "1p"

$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_OECD_Brown_demand_1p.cs4r"
$offdelim

$elseif.coalition8 %cm_PPCA_size% == "2p"

$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_OECD_Brown_demand_2p.cs4r"
$offdelim


$elseif.coalition8 %cm_PPCA_size% == "3p"

$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_OECD_Brown_demand_3p.cs4r"
$offdelim


$endif.coalition8
$endif.recovery8

$ifthen.recovery9 %cm_COVID_coal_scen% == "Green"

$ifthen.coalition9 %cm_PPCA_size% == "current"

$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_OECD_Green_demand_current.cs4r"
$offdelim


$elseif.coalition9 %cm_PPCA_size% == "1p"

$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_OECD_Green_demand_1p.cs4r"
$offdelim


$elseif.coalition9 %cm_PPCA_size% == "2p"

$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_OECD_Green_demand_2p.cs4r"
$offdelim


$elseif.coalition9 %cm_PPCA_size% == "3p"

$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_OECD_Green_demand_3p.cs4r"
$offdelim


$endif.coalition9
$endif.recovery9
/
;
$endif.polscen
$endif.phase1


$ifthen.phase2 %cm_PPCA_nonOECD% == "on"
*** Non-OECD 2050 coal phase-out ***
$ifthen.polscen2 %cm_PPCA_pol% == "power"
parameter p47_max_coal_el_share_nonoecd(all_regi)     "Maximum regional coal share from 2050 on as a result of non-OECD PPCA countries phasing out coal"
/
$ifthen.recovery1 %cm_COVID_coal_scen% == "none"
$ifthen.coalition %cm_PPCA_size% == "current"
$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_nonOECD_noCOV_power_current.cs4r"
$offdelim

$elseif.coalition %cm_PPCA_size% == "1p"
$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_nonOECD_noCOV_power_1p.cs4r"
$offdelim

$elseif.coalition %cm_PPCA_size% == "2p"
$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_nonOECD_noCOV_power_2p.cs4r"
$offdelim

$elseif.coalition %cm_PPCA_size% == "3p"
$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_nonOECD_noCOV_power_3p.cs4r"
$offdelim

$endif.coalition
$endif.recovery1

$ifthen.recovery4 %cm_COVID_coal_scen% == "BAU"
$ifthen.coalition4 %cm_PPCA_size% == "current"
$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_nonOECD_BAU_power_current.cs4r"
$offdelim

$elseif.coalition4 %cm_PPCA_size% == "1p"
$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_nonOECD_BAU_power_1p.cs4r"
$offdelim

$elseif.coalition4 %cm_PPCA_size% == "2p"
$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_nonOECD_BAU_power_2p.cs4r"
$offdelim

$elseif.coalition4 %cm_PPCA_size% == "3p"
$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_nonOECD_BAU_power_3p.cs4r"
$offdelim
$endif.coalition4
$endif.recovery4

$ifthen.recovery5 %cm_COVID_coal_scen% == "Brown"
$ifthen.coalition5 %cm_PPCA_size% == "current"
$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_nonOECD_Brown_power_current.cs4r"
$offdelim

$elseif.coalition5 %cm_PPCA_size% == "1p"
$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_nonOECD_Brown_power_1p.cs4r"
$offdelim

$elseif.coalition5 %cm_PPCA_size% == "2p"
$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_nonOECD_Brown_power_2p.cs4r"
$offdelim

$elseif.coalition5 %cm_PPCA_size% == "3p"
$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_nonOECD_Brown_power_3p.cs4r"
$offdelim

$endif.coalition5
$endif.recovery5

$ifthen.recovery6 %cm_COVID_coal_scen% == "Green"

$ifthen.coalition6 %cm_PPCA_size% == "current"
$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_nonOECD_Green_power_current.cs4r"
$offdelim

$elseif.coalition6 %cm_PPCA_size% == "1p"
$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_nonOECD_Green_power_1p.cs4r"
$offdelim

$elseif.coalition6 %cm_PPCA_size% == "2p"
$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_nonOECD_Green_power_2p.cs4r"
$offdelim

$elseif.coalition6 %cm_PPCA_size% == "3p"
$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_nonOECD_Green_power_3p.cs4r"
$offdelim

$endif.coalition6
$endif.recovery6
/
;


*** Non-OECD 2045 coal phase-out ***

$elseif.polscen2 %cm_PPCA_pol% == "demand"
*** Non-OECD 2050 coal demand phase-out ***
parameter p47_max_coal_dem_share_nonoecd(all_regi,dem_sector)     "Maximum regional coal share from 2050 on as a result of non-OECD PPCA countries phasing out coal"
/
$ifthen.recovery10 %cm_COVID_coal_scen% == "BAU"
$ifthen.coalition10 %cm_PPCA_size% == "current"
$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_nonOECD_BAU_demand_current.cs4r"
$offdelim


$elseif.coalition10 %cm_PPCA_size% == "1p"

$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_nonOECD_BAU_demand_1p.cs4r"
$offdelim


$elseif.coalition10 %cm_PPCA_size% == "2p"

$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_nonOECD_BAU_demand_2p.cs4r"
$offdelim


$elseif.coalition10 %cm_PPCA_size% == "3p"

$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_nonOECD_BAU_demand_3p.cs4r"
$offdelim


$endif.coalition10
$endif.recovery10

$ifthen.recovery11 %cm_COVID_coal_scen% == "Brown"

$ifthen.coalition11 %cm_PPCA_size% == "current"

$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_nonOECD_Brown_demand_current.cs4r"
$offdelim


$elseif.coalition11 %cm_PPCA_size% == "1p"

$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_nonOECD_Brown_demand_1p.cs4r"
$offdelim


$elseif.coalition11 %cm_PPCA_size% == "2p"

$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_nonOECD_Brown_demand_2p.cs4r"
$offdelim


$elseif.coalition11 %cm_PPCA_size% == "3p"

$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_nonOECD_Brown_demand_3p.cs4r"
$offdelim


$endif.coalition11
$endif.recovery11

$ifthen.recovery12 %cm_COVID_coal_scen% == "Green"

$ifthen.coalition12 %cm_PPCA_size% == "current"

$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_nonOECD_Green_demand_current.cs4r"
$offdelim


$elseif.coalition12 %cm_PPCA_size% == "1p"

$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_nonOECD_Green_demand_1p.cs4r"
$offdelim


$elseif.coalition12 %cm_PPCA_size% == "2p"

$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_nonOECD_Green_demand_2p.cs4r"
$offdelim


$elseif.coalition12 %cm_PPCA_size% == "3p"

$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/f47_nonOECD_Green_demand_3p.cs4r"
$offdelim


$endif.coalition12
$endif.recovery12
/
;

$endif.polscen2
$endif.phase2


*** EOF ./modules/47_regipol/PPCAcoalExit/datainput.gms
