*** |  (C) 2006-2019 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of REMIND and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  REMIND License Exception, version 1.0 (see LICENSE file).
*** |  Contact: remind@pik-potsdam.de
*** SOF ./modules/47_regipol/PPCAcoalExit/equations.gms

q47_CovidCoalCap(t,regi,cov_coal)$(sameas(cov_coal,"%cm_COVID_coal_scen%") AND t.val eq 2025)..
sum(te$(sameas(te,"pc") OR sameas(te,"igcc") OR sameas(te,"coalchp")),
    sum(te2rlf(te,rlf),
      vm_cap(t,regi,te,rlf)))
    =l= 
    1.01 * p47_coalCapCOVID(t,regi,cov_coal)
  ;

q47_CovidCoalFloor(t,regi,cov_coal)$(sameas(cov_coal,"%cm_COVID_coal_scen%") AND t.val eq 2025)..
sum(te$(sameas(te,"pc") OR sameas(te,"igcc") OR sameas(te,"coalchp")),
    sum(te2rlf(te,rlf),
      vm_cap(t,regi,te,rlf)))
    =g= 
    0.99 * p47_coalCapCOVID(t,regi,cov_coal)
    ;

$ifthen.PPCA_pol %cm_PPCA_pol% == "power"
$ifthen.PPCA_OECD %cm_PPCA_OECD% == "on"
q47_PPCA_OECD_power_phaseOut(t,regi)$(t.val ge 2030 AND (t.val lt 2050)$(sameas("%cm_PPCA_nonOECD%","on")))..
sum(pe2se(entyPe,entySe,te)$(sameas(entyPe,"pecoal") AND sameas(entySe,"seel") AND (sameas(te,"pc") OR sameas(te,"coalchp") OR sameas(te,"igcc"))),
    vm_prodSe(t,regi,entyPe,entySe,te))
    + sum(pc2te(entyPe,entySe,te,enty2)$(sameas(entyPe,"pecoal") AND sameas(entySe,"seel") AND (sameas(te,"pc") OR sameas(te,"coalchp") OR sameas(te,"igcc"))),
		pm_prodCouple(regi,entyPe,entySe,te,enty2) * vm_prodSe(t,regi,entyPe,entySe,te))
    =l=
    p47_regiMaxCoalShare2030(regi)  !! read-in coal share parameter
      * (sum(pe2se(entyPe,entySe,te)$sameas(entySe,"seel"),
        vm_prodSe(t,regi,entyPe,entySe,te) )
      + sum(se2se(entyPe,entySe,te)$sameas(entySe,"seel"),
        vm_prodSe(t,regi,entyPe,entySe,te) )
      + sum(pc2te(entyPe,entySe,te,enty2)$sameas(entySe,"seel"),
        pm_prodCouple(regi,entyPe,entySe,te,enty2) * vm_prodSe(t,regi,entyPe,entySe,te)) )
    ;

$endif.PPCA_OECD

$ifthen.PPCA_nonOECD %cm_PPCA_nonOECD% == "on"
q47_PPCA_nonOECD_power_phaseOut(t,regi)$(t.val ge 2050)..
sum(pe2se(entyPe,entySe,te)$(sameas(entyPe,"pecoal") AND sameas(entySe,"seel") AND (sameas(te,"pc") OR sameas(te,"coalchp") OR sameas(te,"igcc"))),
    vm_prodSe(t,regi,entyPe,entySe,te))
    + sum(pc2te(entyPe,entySe,te,enty2)$(sameas(entyPe,"pecoal") AND sameas(entySe,"seel") AND (sameas(te,"pc") OR sameas(te,"coalchp") OR sameas(te,"igcc"))),
		pm_prodCouple(regi,entyPe,entySe,te,enty2) * vm_prodSe(t,regi,entyPe,entySe,te))
    =l=
    p47_regiMaxCoalShare2050(regi)  !! read-in coal share parameter
      * (sum(pe2se(entyPe,entySe,te)$sameas(entySe,"seel"),
        vm_prodSe(t,regi,entyPe,entySe,te) )
      + sum(se2se(entyPe,entySe,te)$sameas(entySe,"seel"),
        vm_prodSe(t,regi,entyPe,entySe,te) )
      + sum(pc2te(entyPe,entySe,te,enty2)$sameas(entySe,"seel"),
        pm_prodCouple(regi,entyPe,entySe,te,enty2) * vm_prodSe(t,regi,entyPe,entySe,te)) )
    ;
    
* q47_PPCA_nonOECD_power_phaseOut(t,regi,entyPe,"seel",te)$(t.val ge 2050)..
* sum(pe2se("pecoal","seel",te),
*     vm_demPe(t,regi,"pecoal","seel",te)$(t.val ge 2050 AND (sameas(te,"pc") OR sameas(te,"coalchp") OR sameas(te,"igcc")))) 
*     =l=
*         p47_regiMaxCoalShare(regi)
*         * sum(pe2se(enty,"seel",te),
*         vm_demPe(t,regi,entyPe,"seel",te)$(t.val ge 2050));

* q47_PPCA_nonOECD_power_phaseOut(t,regi,entyPe,entySe)$(sameas(entyPe,"pecoal") AND sameas(entySe,"seel") AND t.val ge 2050)..
* sum(pe2se("pecoal","seel",te)$((sameas(te,"pc") OR sameas(te,"coalchp") OR sameas(te,"igcc"))),
*     vm_demSe(t,regi,"pecoal","seel",te)$(sameas(entyPe,"pecoal") AND sameas(entySe,"seel") AND t.val ge 2050)) 
*     =l=
*         p47_regiMaxCoalShare(regi) 
*         * sum(pe2se(entyPe,"seel",te),
*         vm_demSe(t,regi,entyPe,"seel",te) AND t.val ge 2050));

$endif.PPCA_nonOECD


$elseif.PPCA_pol %cm_PPCA_pol% == "demand"
*** Specifying CO2 emissions from steel production
* q47_emi_co2steel(t,regi)$(t.val ge 2030)..
*     vm_emiTeDetail(t,regi,"pecoal","sesofos","coaltr","co2")
*     =l=
*       !! net fesos emissions from steel subsector
*       ( vm_macBaseInd(t,regi,"fesos","steel")
*       - vm_emiIndCCS(t,regi,"co2steel")
*       )
*       !! share of sesofos in fesos production
*     * ( vm_prodFE(t,regi,"sesofos","fesos","tdfossos")
*       / sum(se2fe(entySE,entyFe,te)$(sameas(entyFe,"fesos")),
*           vm_prodFE(t,regi,entySE,entyFe,te)
*         )
*       );

*** Equation below moved to bounds
*** Limit CO2 emissions in demand exit policy scenario to reference case (allows PPCA members to use coal for steel production until 2070)
* q47_ref_emi_steel(t,regi)$(t.val ge 2030 AND t.val le 2070)..
* vm_emiTeDetail(t,regi,"pecoal","sesofos","coaltr","co2") 
*   =l= 
*   p47_co2steel_ref(t,regi)
*   ;

*** Limiting regional coal emissions (except from steel) to aggregated national phase-out level
$ifthen.PPCA_2030 %cm_PPCA_OECD% == "on"

*Preliminary equation which phases out all coal demand, including met coal
* q47_PPCA_OECD_demand_exit(t,regi)$(t.val ge 2030 AND (t.val lt 2050)$(sameas("%cm_PPCA_nonOECD%","on")))..
*     sum(emi2te("pecoal",entySe,te,"co2"),
*       vm_emiTeDetail(t,regi,"pecoal",entySe,te,"co2"))
*     =l= 
*     p47_regiMaxCoalShare2030(regi)  !! read-in coal share parameter
*     * vm_emiAll(t,regi,"co2");

* Final version of equation(s) which continue allowing met coal demand for 20 years
q47_PPCA_OECD_demand_exit(t,regi)$(t.val ge 2030 AND (t.val lt 2050)$(sameas("%cm_PPCA_nonOECD%","on")))..
    sum(emi2te("pecoal",entySe,te,"co2")$(not sameas(entySe,"sesofos") AND not sameas(te,"coaltr")),
      vm_emiTeDetail(t,regi,"pecoal",entySe,te,"co2"))
    =l= 
    p47_regiMaxCoalShare2030(regi)  !! read-in coal share parameter
    * vm_emiAll(t,regi,"co2")
    ;

q47_PPCA_OECD_coaltr_lim(t,regi)$(t.val ge 2030 AND (t.val lt 2050)$(sameas("%cm_PPCA_nonOECD%","on")))..
    vm_emiTeDetail(t,regi,"pecoal","sesofos","coaltr","co2")
    =l= 
    sum(emi2te("pecoal",entySe,te,"co2"),
      v47_emiTeDetail(t,regi,"pecoal",entySe,te,"co2")$(t.val eq 2030))       !! coal_emi_ref[2030] -
    - p47_regiMaxCoalShare2030(regi)                             !! ((coal_emi_ref[2030] - steel_emi_ref[2030]) / total_emi_ref[2030]
    * vm_emiAll(t,regi,"co2")                                                 !! * total_emi_ref[2030] )
    ;

* q47_PPCA_OECD_coaltr_exit(t,regi)$(t.val ge 2050)..
*     vm_emiTeDetail(t,regi,"pecoal","sesofos","coaltr","co2")
*     =l=


$endif.PPCA_2030


$ifthen.PPCA_2050 %cm_PPCA_nonOECD% == "on"

*Preliminary equation which phases out all coal demand, including met coal
* q47_PPCA_nonOECD_demand_exit(t,regi)$(t.val ge 2050)..
*     sum(emi2te("pecoal",entySe,te,"co2"),
*       vm_emiTeDetail(t,regi,"pecoal",entySe,te,"co2"))
*     =l= 
*     p47_regiMaxCoalShare2050(regi)  !! read-in coal share parameter
*     * vm_emiAll(t,regi,"co2");

*Final version of equation (set) which continues allowing met coal demand
q47_PPCA_nonOECD_demand_exit(t,regi)$(t.val ge 2050)..
* sum(emi2te(entyPe,entySe,te,enty)$(sameas(entyPe,"pecoal") AND not sameas(te,"coaltr") AND sameas(enty,"co2")),
*   vm_emiTeDetail(t,regi,entyPe,entySe,te,enty))
    sum(emi2te("pecoal",entySe,te,"co2")$(not sameas(entySe,"sesofos") AND not sameas(te,"coaltr")),
      vm_emiTeDetail(t,regi,"pecoal",entySe,te,"co2"))
    =l= 
    p47_regiMaxCoalShare2050(regi)  !! read-in coal share parameter
*    * sum(enty$sameas(enty,"co2"),vm_emiAll(t,regi,enty));
        * vm_emiAll(t,regi,"co2");

q47_PPCA_nonOECD_coaltr_lim(t,regi)$(t.val ge 2050)..
    vm_emiTeDetail(t,regi,"pecoal","sesofos","coaltr","co2")
    =l= 
     sum(emi2te("pecoal",entySe,te,"co2"),
      v47_emiTeDetail(t,regi,"pecoal",entySe,te,"co2")$(t.val eq 2050))       !! coal_emi_ref[2050] -
    - p47_regiMaxCoalShare2050(regi)                             !! ((coal_emi_ref[2050] - steel_emi_ref[2050]) / total_emi_ref[2050]
    * vm_emiAll(t,regi,"co2")                                                 !! * total_emi_ref[2050] )
    ;

$endif.PPCA_2050
$endif.PPCA_pol


*** EOF ./modules/47_regipol/PPCAcoalExit/equations.gms