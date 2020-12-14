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
    1.01*p47_coalCapCOVID(t,regi,cov_coal)
  ;

q47_CovidCoalFloor(t,regi,cov_coal)$(sameas(cov_coal,"%cm_COVID_coal_scen%") AND t.val eq 2025)..
sum(te$(sameas(te,"pc") OR sameas(te,"igcc") OR sameas(te,"coalchp")),
    sum(te2rlf(te,rlf),
      vm_cap(t,regi,te,rlf)))
    =g= 
    p47_coalCapCOVID(t,regi,cov_coal)
    * (0.99
    )
  ;

$ifthen.PPCA_pol %cm_PPCA_pol% == "power"
$ifthen.PPCA_OECD %cm_PPCA_OECD% == "on"

q47_seel_cap(t,regi,enty2)$(sameas(enty2,"seel"))..
sum(pe2se(enty,enty2,te), vm_prodSe(t,regi,enty,enty2,te) )
      + sum(se2se(enty,enty2,te), vm_prodSe(t,regi,enty,enty2,te) )
      + sum(pc2te(enty,entySE(enty3),te,enty2), 
        pm_prodCouple(regi,enty,enty3,te,enty2) * vm_prodSe(t,regi,enty,enty3,te) )
      + sum(pc2te(enty4,entyFE(enty5),te,enty2), 
        pm_prodCouple(regi,enty4,enty5,te,enty2) * vm_prodFe(t,regi,enty4,enty5,te) )
      + sum(pc2te(enty,enty3,te,enty2),
        sum(teCCS2rlf(te,rlf),
          pm_prodCouple(regi,enty,enty3,te,enty2) * vm_co2CCS(t,regi,enty,enty3,te,rlf) ) )
    =l=
    1.5 *
    sum(pe2se(enty,enty2,te), p47_prodSe(t,regi,enty,enty2,te) )
      + sum(se2se(enty,enty2,te), p47_prodSe(t,regi,enty,enty2,te) )
      + sum(pc2te(enty,entySE(enty3),te,enty2), 
        p47_prodCouple(regi,enty,enty3,te,enty2) * p47_prodSe(t,regi,enty,enty3,te) )
      + sum(pc2te(enty4,entyFE(enty5),te,enty2), 
        p47_prodCouple(regi,enty4,enty5,te,enty2) * p47_prodFe(t,regi,enty4,enty5,te) )
      + sum(pc2te(enty,enty3,te,enty2),
        sum(teCCS2rlf(te,rlf),
          p47_prodCouple(regi,enty,enty3,te,enty2) * p47_co2CCS(t,regi,enty,enty3,te,rlf) ) )
;

q47_PPCA_OECD_power_phaseOut(regi,enty2)$(sameas(enty2,"seel"))..
sum(t$(t.val ge 2030 AND t.val le 2100),
  sum(pe2se("pecoal",enty2,te)$(sameas(te,"pc") OR sameas(te,"coalchp") OR sameas(te,"igcc")),
    vm_prodSe(t,regi,"pecoal",enty2,te))
    + sum(pc2te("pecoal",entySE(enty3),te,enty2)$(sameas(te,"coalchp")),
		pm_prodCouple(regi,"pecoal",enty3,te,enty2) * vm_prodSe(t,regi,"pecoal",enty3,te))
)
    =l=
    ( 
      p47_max_coal_el_share_oecd(regi)              !! read-in coal share parameter
* + ((2030 - pm_t_val(t)) / (2030 - 2020) * (1 - p47_max_coal_el_share_oecd(regi)))$(t.val le 2030)   !! force linear phase-out in time-steps from model start to policy enforcement
      )
    * (sum(t$(t.val ge 2030 AND t.val le 2100),
        sum(pe2se(enty,enty2,te), vm_prodSe(t,regi,enty,enty2,te) )
      + sum(se2se(enty,enty2,te), vm_prodSe(t,regi,enty,enty2,te) )
      + sum(pc2te(enty,entySE(enty3),te,enty2), 
        pm_prodCouple(regi,enty,enty3,te,enty2) * vm_prodSe(t,regi,enty,enty3,te) )
      + sum(pc2te(enty4,entyFE(enty5),te,enty2), 
        pm_prodCouple(regi,enty4,enty5,te,enty2) * vm_prodFe(t,regi,enty4,enty5,te) )
      + sum(pc2te(enty,enty3,te,enty2),
        sum(teCCS2rlf(te,rlf),
          pm_prodCouple(regi,enty,enty3,te,enty2) * vm_co2CCS(t,regi,enty,enty3,te,rlf) ) )
        )
    )
      + (1e-4 - p47_max_coal_el_share_oecd(regi))$(p47_max_coal_el_share_oecd(regi) le 1e-4)
* + (0.4 * p47_max_coal_el_share_oecd(regi))$(p47_max_coal_el_share_oecd(regi) eq 6e-6 AND t.val le 2035)
;

$endif.PPCA_OECD

$ifthen.PPCA_nonOECD %cm_PPCA_nonOECD% == "on"
* q47_PPCA_nonOECD_power_phaseOut(regi)$(t.val ge 2050 AND t.val le 2100)..
q47_PPCA_nonOECD_power_phaseOut(regi,enty2)$(sameas(enty2,"seel"))..
sum(t$(t.val ge 2050 AND t.val le 2100),
  sum(pe2se("pecoal",enty2,te)$(sameas(te,"pc") OR sameas(te,"coalchp") OR sameas(te,"igcc")),
    vm_prodSe(t,regi,"pecoal",enty2,te))
    + sum(pc2te("pecoal",entySE(enty3),te,enty2)$(sameas(te,"coalchp")),
		pm_prodCouple(regi,"pecoal",enty3,te,enty2) * vm_prodSe(t,regi,"pecoal",enty3,te))
)
    =l=
    ( 
      p47_max_coal_el_share_nonoecd(regi)                                                                       !! read-in coal share parameter
* + ((2050 - pm_t_val(t)) / (2050 - 2030) * (1 - p47_max_coal_el_share_nonoecd(regi)))$(t.val le 2050)   !! force linear phase-out in time-steps from model start to policy enforcement
      )
    * (sum(t$(t.val ge 2050 AND t.val le 2100),
        sum(pe2se(enty,enty2,te), vm_prodSe(t,regi,enty,enty2,te) )
      + sum(se2se(enty,enty2,te), vm_prodSe(t,regi,enty,enty2,te) )
      + sum(pc2te(enty,entySE(enty3),te,enty2), 
        pm_prodCouple(regi,enty,enty3,te,enty2) * vm_prodSe(t,regi,enty,enty3,te) )
      + sum(pc2te(enty4,entyFE(enty5),te,enty2), 
        pm_prodCouple(regi,enty4,enty5,te,enty2) * vm_prodFe(t,regi,enty4,enty5,te) )
      + sum(pc2te(enty,enty3,te,enty2),
        sum(teCCS2rlf(te,rlf),
          pm_prodCouple(regi,enty,enty3,te,enty2) * vm_co2CCS(t,regi,enty,enty3,te,rlf) ) )         
        )
    )
      + (1e-4 - p47_max_coal_el_share_nonoecd(regi))$(p47_max_coal_el_share_nonoecd(regi) le 1e-4)
      ;
    
$endif.PPCA_nonOECD

$elseif.PPCA_pol %cm_PPCA_pol% == "demand"

q47_se_cap(t,regi)..
sum(pe2se(enty,enty2,te), vm_prodSe(t,regi,enty,enty2,te) )
      + sum(se2se(enty,enty2,te), vm_prodSe(t,regi,enty,enty2,te) )
* + sum(pc2te(enty,entySE(enty3),te,enty2), 
*   pm_prodCouple(regi,enty,enty3,te,enty2) * vm_prodSe(t,regi,enty,enty3,te) )
* + sum(pc2te(enty4,entyFE(enty5),te,enty2), 
*   pm_prodCouple(regi,enty4,enty5,te,enty2) * vm_prodFe(t,regi,enty4,enty5,te) )
* + sum(pc2te(enty,enty3,te,enty2),
*   sum(teCCS2rlf(te,rlf),
*     pm_prodCouple(regi,enty,enty3,te,enty2) * vm_co2CCS(t,regi,enty,enty3,te,rlf) ) )
    =l=
    sum(pe2se(enty,enty2,te), p47_prodSe(t,regi,enty,enty2,te) )
      + sum(se2se(enty,enty2,te), p47_prodSe(t,regi,enty,enty2,te) )
      * 1.25$(t.val ne 2030)
      * 1.05$(t.val eq 2030)
* + sum(pc2te(enty,entySE(enty3),te,enty2), 
*   p47_prodCouple(regi,enty,enty3,te,enty2) * p47_prodSe(t,regi,enty,enty3,te) )
* + sum(pc2te(enty4,entyFE(enty5),te,enty2), 
*   p47_prodCouple(regi,enty4,enty5,te,enty2) * p47_prodFe(t,regi,enty4,enty5,te) )
* + sum(pc2te(enty,enty3,te,enty2),
*   sum(teCCS2rlf(te,rlf),
*     p47_prodCouple(regi,enty,enty3,te,enty2) * p47_co2CCS(t,regi,enty,enty3,te,rlf) ) )
;

q47_se_floor(t,regi)..
sum(pe2se(enty,enty2,te), vm_prodSe(t,regi,enty,enty2,te) )
      + sum(se2se(enty,enty2,te), vm_prodSe(t,regi,enty,enty2,te) )
* + sum(pc2te(enty,entySE(enty3),te,enty2), 
*   pm_prodCouple(regi,enty,enty3,te,enty2) * vm_prodSe(t,regi,enty,enty3,te) )
* + sum(pc2te(enty4,entyFE(enty5),te,enty2), 
*   pm_prodCouple(regi,enty4,enty5,te,enty2) * vm_prodFe(t,regi,enty4,enty5,te) )
* + sum(pc2te(enty,enty3,te,enty2),
*   sum(teCCS2rlf(te,rlf),
*     pm_prodCouple(regi,enty,enty3,te,enty2) * vm_co2CCS(t,regi,enty,enty3,te,rlf) ) )
    =g=
    sum(pe2se(enty,enty2,te), p47_prodSe(t,regi,enty,enty2,te) )
      + sum(se2se(enty,enty2,te), p47_prodSe(t,regi,enty,enty2,te) )
      * 0.75$(t.val ne 2030)
      * 0.95$(t.val eq 2030)
* + sum(pc2te(enty,entySE(enty3),te,enty2), 
*   p47_prodCouple(regi,enty,enty3,te,enty2) * p47_prodSe(t,regi,enty,enty3,te) )
* + sum(pc2te(enty4,entyFE(enty5),te,enty2), 
*   p47_prodCouple(regi,enty4,enty5,te,enty2) * p47_prodFe(t,regi,enty4,enty5,te) )
* + sum(pc2te(enty,enty3,te,enty2),
*   sum(teCCS2rlf(te,rlf),
*     p47_prodCouple(regi,enty,enty3,te,enty2) * p47_co2CCS(t,regi,enty,enty3,te,rlf) ) )
;

***################ NEW APPROACH (TODO): SET UPPER BOUND ON COAL DEMAND IN ALL TIME STEPS WITHIN MRREMIND ###################
*** Primary energy banding to prevent corner solutions
* q47_PE_ceiling(t,regi)$(t.val le 2035)..
*   sum(pe2se(enty,enty2,te), vm_demPe(t,regi,enty,enty2,te))
*   =l=
*   1.05 * sum(pe2se(enty,enty2,te), p47_demPe(t,regi,enty,enty2,te))
* ;

* q47_PE_floor(t,regi)$(t.val le 2035)..
*   sum(pe2se(enty,enty2,te), vm_demPe(t,regi,enty,enty2,te))
*   =g=
*   0.95 * sum(pe2se(enty,enty2,te), p47_demPe(t,regi,enty,enty2,te))
* ;

* Final energy banding to prevent corner solutions
q47_FE_ceiling(t,regi)$(t.val le 2030)..
    sum(se2fe(enty,entyFe,te), vm_prodFe(t,regi,enty,entyFe,te) )
    =l=
    1.05
    * sum(se2fe(enty,entyFe,te), p47_prodFe(t,regi,enty,entyFe,te) )
    ;

* Final energy banding to prevent corner solutions
q47_FE_floor(t,regi)$(t.val le 2030)..
    sum(se2fe(enty,entyFe,te), vm_prodFe(t,regi,enty,entyFe,te) )
    =g=
    0.95
    * sum(se2fe(enty,entyFe,te), p47_prodFe(t,regi,enty,entyFe,te) )
    ;


*** Limiting regional coal emissions (except solids) to aggregated national phase-out level
$ifthen.PPCA_2030 %cm_PPCA_OECD% == "on"
* q47_PPCA_OECD_demand_exit(regi)$(t.val ge cm_startyear AND (t.val lt 2050)$(sameas("%cm_PPCA_nonOECD%","on")))..
q47_PPCA_OECD_demand_exit(regi)..
    sum(t$(t.val ge 2030 AND t.val le 2100),
      sum(emi2te("pecoal",entySe,te,"co2")$(not sameas(entySe,"sesofos") AND not sameas(te,"coaltr")),
      vm_emiTeDetail(t,regi,"pecoal",entySe,te,"co2"))
    )
    =l= 
    sum(t$(t.val ge 2030 AND t.val le 2100), 
    ( 
      p47_max_coal_dem_share_oecd(regi,"demand")              !! read-in coal share parameter
          + (0.05 - p47_max_coal_dem_share_oecd(regi,"demand"))$(t.val le 2035 AND p47_max_coal_dem_share_oecd(regi,"demand") lt 0.05)
    )
    * vm_emiAll(t,regi,"co2")
     + (1e-3 - p47_max_coal_dem_share_oecd(regi,"demand"))$(p47_max_coal_dem_share_oecd(regi,"demand") le 1e-3) 
    )
    ;

** Phase out solids except in steel
q47_PPCA_OECD_solids_exit(regi)..
    sum(t$(t.val ge 2030 AND t.val le 2100),
      vm_emiTeDetail(t,regi,"pecoal","sesofos","coaltr","co2")
    )
    =l=
    sum(t$(t.val ge 2030 AND t.val le 2100), 
    (
    p47_max_coal_dem_share_oecd(regi,"solids") 
         + (0.05 - p47_max_coal_dem_share_oecd(regi,"solids"))$(t.val le 2035 AND p47_max_coal_dem_share_oecd(regi,"solids") lt 0.05)
    )
        * vm_emiAll(t,regi,"co2")
* * sum(emi2te("pecoal",enty,te,"co2"),
*       vm_emiTeDetail(t,regi,"pecoal",enty,te,"co2"))
* + p47_max_coal_dem_share_oecd(regi,"solids")$(p47_max_coal_dem_share_oecd(regi,"solids") le 0.01)
      + (1e-3 - p47_max_coal_dem_share_oecd(regi,"solids"))$(p47_max_coal_dem_share_oecd(regi,"solids") le 1e-3)
    )
    ;

q47_PPCA_OECD_steel_exit(regi)..
    !! net fesos emissions from steel subsector
    sum(t$(t.val ge 2050 AND t.val le 2100),
    (( vm_macBaseInd(t,regi,"fesos","steel")
    - vm_emiIndCCS(t,regi,"co2steel")
    )
    !! share of sesofos in fesos production
  * ( vm_prodFE(t,regi,"sesofos","fesos","tdfossos")
    / sum(se2fe(entySE,entyFe,te)$(sameas(entyFe,"fesos")),
        vm_prodFE(t,regi,entySE,entyFe,te) ) ) )
    )
    =l=
    sum(t$(t.val ge 2050 AND t.val le 2100), 
    (
    p47_max_coal_dem_share_oecd(regi,"steel")
         + (0.01 - p47_max_coal_dem_share_oecd(regi,"steel"))$(t.val le 2060 AND p47_max_coal_dem_share_oecd(regi,"steel") lt 0.01)
    )
        * vm_emiAll(t,regi,"co2")
* * sum(emi2te("pecoal",enty,te,"co2"),
*         vm_emiTeDetail(t,regi,"pecoal",enty,te,"co2"))
        + (1e-3 - p47_max_coal_dem_share_oecd(regi,"steel"))$(p47_max_coal_dem_share_oecd(regi,"steel") le 1e-3 AND t.val le 2060)
    )
      ;

$endif.PPCA_2030


$ifthen.PPCA_2050 %cm_PPCA_nonOECD% == "on"

q47_PPCA_nonOECD_demand_exit(regi)..
* sum(emi2te(entyPe,entySe,te,enty)$(sameas(entyPe,"pecoal") AND not sameas(te,"coaltr") AND sameas(enty,"co2")),
*   vm_emiTeDetail(t,regi,entyPe,entySe,te,enty))
    sum(t$(t.val ge 2050 AND t.val le 2100),
    sum(emi2te("pecoal",entySe,te,"co2")$(not sameas(entySe,"sesofos") AND not sameas(te,"coaltr")),
      vm_emiTeDetail(t,regi,"pecoal",entySe,te,"co2"))
    )
    =l= 
    sum(t$(t.val ge 2050 AND t.val le 2100), 
    ( p47_max_coal_dem_share_nonoecd(regi,"demand")              !! read-in coal share parameter
    + (0.01 - p47_max_coal_dem_share_nonoecd(regi,"demand"))$(t.val le 2060 AND p47_max_coal_dem_share_nonoecd(regi,"demand") lt 0.01 AND p47_max_coal_dem_share_oecd(regi,"demand") ge 0.01)
    )
    * vm_emiAll(t,regi,"co2")
* * sum(emi2te(peFos(enty),entySe,te,"co2"),
* vm_emiTeDetail(t,regi,enty,entySe,te,"co2"))
    + (1e-3 - p47_max_coal_dem_share_nonoecd(regi,"demand"))$(p47_max_coal_dem_share_nonoecd(regi,"demand") le 1e-3)
    )
      ;

q47_PPCA_nonOECD_solids_exit(regi)..
    sum(t$(t.val ge 2050 AND t.val le 2100),
      vm_emiTeDetail(t,regi,"pecoal","sesofos","coaltr","co2")
    )
    =l=
    sum(t$(t.val ge 2050 AND t.val le 2100), 
    ( p47_max_coal_dem_share_nonoecd(regi,"solids") 
        + (0.01 - p47_max_coal_dem_share_nonoecd(regi,"solids"))$(t.val le 2060 AND p47_max_coal_dem_share_nonoecd(regi,"solids") lt 0.01 AND p47_max_coal_dem_share_oecd(regi,"solids") ge 0.01)
    )
      * vm_emiAll(t,regi,"co2")
* * sum(emi2te("pecoal",enty,te,"co2"),
*     vm_emiTeDetail(t,regi,"pecoal",enty,te,"co2"))
    + (1e-3 - p47_max_coal_dem_share_nonoecd(regi,"solids"))$(p47_max_coal_dem_share_nonoecd(regi,"solids") le 1e-3)
    )
    ;

q47_PPCA_nonOECD_steel_exit(regi)..
    sum(t$(t.val ge 2070 AND t.val le 2100),
    !! net fesos emissions from steel subsector
    (( vm_macBaseInd(t,regi,"fesos","steel")
    - vm_emiIndCCS(t,regi,"co2steel")
    )
    !! share of sesofos in fesos production
  * ( vm_prodFE(t,regi,"sesofos","fesos","tdfossos")
    / sum(se2fe(entySE,entyFe,te)$(sameas(entyFe,"fesos")),
        vm_prodFE(t,regi,entySE,entyFe,te) ) ) )
    )
    =l=
    sum(t$(t.val ge 2070 AND t.val le 2100), 
    ( p47_max_coal_dem_share_nonoecd(regi,"steel")
        + (0.01 - p47_max_coal_dem_share_nonoecd(regi,"steel"))$(t.val le 2080 AND p47_max_coal_dem_share_nonoecd(regi,"steel") lt 0.01  AND p47_max_coal_dem_share_oecd(regi,"steel") ge 0.01)
    )
      * vm_emiAll(t,regi,"co2")
* * sum(emi2te("pecoal",enty,te,"co2"),
*         vm_emiTeDetail(t,regi,"pecoal",enty,te,"co2"))
    + (1e-3 - p47_max_coal_dem_share_nonoecd(regi,"steel"))$(p47_max_coal_dem_share_nonoecd(regi,"steel") le 1e-3)
    )
      ;

$endif.PPCA_2050
$endif.PPCA_pol


*** EOF ./modules/47_regipol/PPCAcoalExit/equations.gms