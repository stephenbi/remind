*** |  (C) 2006-2019 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of REMIND and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  REMIND License Exception, version 1.0 (see LICENSE file).
*** |  Contact: remind@pik-potsdam.de
*** SOF ./modules/47_regipol/PPCAcoalExit/postsolve.gms

display vm_cap.l, vm_prodSe.l, vm_emiTeDetail.l, vm_deltaCap.l, vm_emiAll.l;
display p47_coalCapCOVID, q47_CovidCoalCap.l;
$if %cm_PPCA_OECD% == "on" display p47_regiMaxCoalShare2030;

$if %cm_PPCA_nonOECD% == "on" display p47_regiMaxCoalShare2050;


$ifthen.policy %cm_PPCA_pol% == "power"
$if %cm_PPCA_OECD% == "on" display q47_PPCA_OECD_power_phaseOut.l, q47_PPCA_OECD_power_phaseOut.m;
$if %cm_PPCA_nonOECD% == "on" display q47_PPCA_nonOECD_power_phaseOut.l, q47_PPCA_nonOECD_power_phaseOut.m;
$elseif.policy %cm_PPCA_pol% == "demand"
display p47_co2steel_ref, v47_emiTeDetail.l;
display vm_macBaseInd.l, vm_emiIndCCS.l, vm_prodFE.l, vm_emiAll.l;
$if %cm_PPCA_OECD% == "on" display q47_PPCA_OECD_demand_exit.l, q47_PPCA_OECD_demand_exit.m;
$if %cm_PPCA_nonOECD% == "on" display q47_PPCA_nonOECD_demand_exit.l, q47_PPCA_nonOECD_demand_exit.m;
* display q47_PPCA_OECD_demand_exit;
$endif.policy

*** EOF ./modules/47_regipol/PPCAcoalExit/postsolve.gms