*** |  (C) 2006-2019 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of REMIND and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  REMIND License Exception, version 1.0 (see LICENSE file).
*** |  Contact: remind@pik-potsdam.de
*** SOF ./modules/47_regipol/PPCAcoalExit/datainput.gms

parameter p47_regiMaxCoalShare(tall,all_regi) "Maximum regional coal share in 2030 and 2050 as a result of PPCA countries phasing out coal"
/
$ondelim
$ifthen.coalition %cm_PPCA_size% == "current"
$include "./modules/47_regipol/PPCAcoalExit/input/PPCA_power_current.cs4r"
$endif.coalition
$offdelim
/
;

parameter p47_coalCapCOVID(tall,all_regi,COV_coal) "2025 coal capacity scenarios based on COVID recovery scenarios"
/
$ondelim
$include "./modules/47_regipol/PPCAcoalExit/input/p47_coalCapCOVID.cs4r"
$offdelim
/
;

*** EOF ./modules/47_regipol/PPCAcoalExit/datainput.gms
