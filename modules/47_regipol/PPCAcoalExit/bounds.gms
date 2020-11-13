*** |  (C) 2006-2019 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of REMIND and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  REMIND License Exception, version 1.0 (see LICENSE file).
*** |  Contact: remind@pik-potsdam.de
*** SOF ./modules/47_regipol/PPCAcoalExit/bounds.gms

$ifthen.policy %cm_PPCA_pol% == "demand"
*** Read in CO2 emissions from steel production in reference scenario 
Execute_Loadpoint 'input_ref' v47_emiTeDetail.l = vm_emiTeDetail.l;
p47_co2steel_ref(t,regi) = v47_emiTeDetail.l(t,regi,"pecoal","sesofos","coaltr","co2");


*** Limit CO2 emissions in demand exit policy scenario to reference case (allows PPCA members to use coal for steel production until 2070)
vm_emiTeDetail.up(t,regi,"pecoal","sesofos","coaltr","co2")$(sameas("%cm_PPCA_OECD%","on") AND t.val ge 2030) 
    = 
    p47_co2steel_ref(t,regi)
;

* vm_emiTeDetail.up(t,regi,"pecoal","sesofos","coaltr","co2")$(sameas("%cm_PPCA_OECD%","on") AND t.val ge 2050 AND not sameas("%cm_PPCA_nonOECD%","on")) 
*     = 
*     p47_co2steel_ref(t,regi)
*     * p47_regiMaxCokeShare2050(regi)

* vm_emiTeDetail.up(t,regi,"pecoal","sesofos","coaltr","co2")$(sameas("%cm_PPCA_nonOECD%","on") AND t.val gt 2070) 
*     = 
*     p47_co2steel_ref(t,regi) 
*     * p47_regiMaxCokeShare2070(regi)
* ;

$endif.policy


** EOF ./modules/47_regipol/PPCAcoalExit/bounds.gms