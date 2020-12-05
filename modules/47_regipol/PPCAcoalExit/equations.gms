*** |  (C) 2006-2019 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of REMIND and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  REMIND License Exception, version 1.0 (see LICENSE file).
*** |  Contact: remind@pik-potsdam.de
*** SOF ./modules/47_regipol/PPCAcoalExit/equations.gms

q47_CovidCoalCap(ttot,regi,cov_coal)$(sameas(cov_coal,"%cm_COVID_coal_scen%") AND ttot.val eq 2025)..
sum(te$(sameas(te,"pc") OR sameas(te,"igcc") OR sameas(te,"coalchp")),
    sum(te2rlf(te,rlf),
      vm_cap(ttot,regi,te,rlf)))
    =l= 
    1.025*p47_coalCapCOVID(ttot,regi,cov_coal)
  ;

q47_CovidCoalFloor(ttot,regi,cov_coal)$(sameas(cov_coal,"%cm_COVID_coal_scen%") AND ttot.val eq 2025)..
sum(te$(sameas(te,"pc") OR sameas(te,"igcc") OR sameas(te,"coalchp")),
    sum(te2rlf(te,rlf),
      vm_cap(ttot,regi,te,rlf)))
    =g= 
    p47_coalCapCOVID(ttot,regi,cov_coal)
    * (0.975
    )
  ;

$ifthen not %cm_PPCA_pol% == "demand"
q47_seel_cap(ttot,regi,enty2)$(sameas(enty2,"seel"))..
sum(pe2se(enty,enty2,te), vm_prodSe(ttot,regi,enty,enty2,te) )
      + sum(se2se(enty,enty2,te), vm_prodSe(ttot,regi,enty,enty2,te) )
      + sum(pc2te(enty,entySE(enty3),te,enty2), 
        pm_prodCouple(regi,enty,enty3,te,enty2) * vm_prodSe(ttot,regi,enty,enty3,te) )
      + sum(pc2te(enty4,entyFE(enty5),te,enty2), 
        pm_prodCouple(regi,enty4,enty5,te,enty2) * vm_prodFe(ttot,regi,enty4,enty5,te) )
      + sum(pc2te(enty,enty3,te,enty2),
        sum(teCCS2rlf(te,rlf),
          pm_prodCouple(regi,enty,enty3,te,enty2) * vm_co2CCS(ttot,regi,enty,enty3,te,rlf) ) )
    =l=
    1.5 *
    sum(pe2se(enty,enty2,te), p47_prodSe(ttot,regi,enty,enty2,te) )
      + sum(se2se(enty,enty2,te), p47_prodSe(ttot,regi,enty,enty2,te) )
      + sum(pc2te(enty,entySE(enty3),te,enty2), 
        p47_prodCouple(regi,enty,enty3,te,enty2) * p47_prodSe(ttot,regi,enty,enty3,te) )
      + sum(pc2te(enty4,entyFE(enty5),te,enty2), 
        p47_prodCouple(regi,enty4,enty5,te,enty2) * p47_prodFe(ttot,regi,enty4,enty5,te) )
      + sum(pc2te(enty,enty3,te,enty2),
        sum(teCCS2rlf(te,rlf),
          p47_prodCouple(regi,enty,enty3,te,enty2) * p47_co2CCS(ttot,regi,enty,enty3,te,rlf) ) )
;
$endif

$ifthen.PPCA_pol %cm_PPCA_pol% == "power"
$ifthen.PPCA_OECD %cm_PPCA_OECD% == "on"

q47_PPCA_OECD_power_phaseOut(t,regi,enty2)$(sameas(enty2,"seel"))..
sum(ttot$(ttot.val ge 2030 AND ttot.val le 2100),
  sum(pe2se("pecoal",enty2,te)$(sameas(te,"pc") OR sameas(te,"coalchp") OR sameas(te,"igcc")),
    vm_prodSe(ttot,regi,"pecoal",enty2,te))
    + sum(pc2te("pecoal",entySE(enty3),te,enty2)$(sameas(te,"coalchp")),
		pm_prodCouple(regi,"pecoal",enty3,te,enty2) * vm_prodSe(ttot,regi,"pecoal",enty3,te))
)
    =l=
    ( 
      p47_max_coal_el_share_oecd(regi)              !! read-in coal share parameter
* + ((2030 - pm_ttot_val(ttot)) / (2030 - 2020) * (1 - p47_max_coal_el_share_oecd(regi)))$(ttot.val le 2030)   !! force linear phase-out in time-steps from model start to policy enforcement
      )
    * (sum(ttot$(ttot.val ge 2030 AND ttot.val le 2100),
        sum(pe2se(enty,enty2,te), vm_prodSe(ttot,regi,enty,enty2,te) )
      + sum(se2se(enty,enty2,te), vm_prodSe(ttot,regi,enty,enty2,te) )
      + sum(pc2te(enty,entySE(enty3),te,enty2), 
        pm_prodCouple(regi,enty,enty3,te,enty2) * vm_prodSe(ttot,regi,enty,enty3,te) )
      + sum(pc2te(enty4,entyFE(enty5),te,enty2), 
        pm_prodCouple(regi,enty4,enty5,te,enty2) * vm_prodFe(ttot,regi,enty4,enty5,te) )
      + sum(pc2te(enty,enty3,te,enty2),
        sum(teCCS2rlf(te,rlf),
          pm_prodCouple(regi,enty,enty3,te,enty2) * vm_co2CCS(ttot,regi,enty,enty3,te,rlf) ) )
        )
    )
      + (0.6 * p47_max_coal_el_share_oecd(regi))$(p47_max_coal_el_share_oecd(regi) le 6e-6)
      + (0.4 * p47_max_coal_el_share_oecd(regi))$(p47_max_coal_el_share_oecd(regi) eq 6e-6 AND t.val le 2035)
;

$endif.PPCA_OECD

$ifthen.PPCA_nonOECD %cm_PPCA_nonOECD% == "on"
* q47_PPCA_nonOECD_power_phaseOut(t,regi)$(ttot.val ge 2050 AND ttot.val le 2100)..
q47_PPCA_nonOECD_power_phaseOut(t,regi,enty2)$(sameas(enty2,"seel"))..
sum(ttot$(ttot.val ge 2050 AND ttot.val le 2100),
  sum(pe2se("pecoal",enty2,te)$(sameas(te,"pc") OR sameas(te,"coalchp") OR sameas(te,"igcc")),
    vm_prodSe(ttot,regi,"pecoal",enty2,te))
    + sum(pc2te("pecoal",entySE(enty3),te,enty2)$(sameas(te,"coalchp")),
		pm_prodCouple(regi,"pecoal",enty3,te,enty2) * vm_prodSe(ttot,regi,"pecoal",enty3,te))
)
    =l=
    ( 
      p47_max_coal_el_share_nonoecd(regi)                                                                       !! read-in coal share parameter
* + ((2050 - pm_ttot_val(ttot)) / (2050 - 2030) * (1 - p47_max_coal_el_share_nonoecd(regi)))$(ttot.val le 2050)   !! force linear phase-out in time-steps from model start to policy enforcement
      )
    * (sum(ttot$(ttot.val ge 2050 AND ttot.val le 2100),
        sum(pe2se(enty,enty2,te), vm_prodSe(ttot,regi,enty,enty2,te) )
      + sum(se2se(enty,enty2,te), vm_prodSe(ttot,regi,enty,enty2,te) )
      + sum(pc2te(enty,entySE(enty3),te,enty2), 
        pm_prodCouple(regi,enty,enty3,te,enty2) * vm_prodSe(ttot,regi,enty,enty3,te) )
      + sum(pc2te(enty4,entyFE(enty5),te,enty2), 
        pm_prodCouple(regi,enty4,enty5,te,enty2) * vm_prodFe(ttot,regi,enty4,enty5,te) )
      + sum(pc2te(enty,enty3,te,enty2),
        sum(teCCS2rlf(te,rlf),
          pm_prodCouple(regi,enty,enty3,te,enty2) * vm_co2CCS(ttot,regi,enty,enty3,te,rlf) ) )         
        )
    )
      + (0.6 * p47_max_coal_el_share_nonoecd(regi))$(p47_max_coal_el_share_nonoecd(regi) le 6e-6)
      ;
    
$endif.PPCA_nonOECD

$elseif.PPCA_pol %cm_PPCA_pol% == "demand"

q47_se_cap(ttot,regi)$(ttot.val le 2030)..
sum(pe2se(enty,enty2,te), vm_prodSe(ttot,regi,enty,enty2,te) )
      + sum(se2se(enty,enty2,te), vm_prodSe(ttot,regi,enty,enty2,te) )
      + sum(pc2te(enty,entySE(enty3),te,enty2), 
        pm_prodCouple(regi,enty,enty3,te,enty2) * vm_prodSe(ttot,regi,enty,enty3,te) )
      + sum(pc2te(enty4,entyFE(enty5),te,enty2), 
        pm_prodCouple(regi,enty4,enty5,te,enty2) * vm_prodFe(ttot,regi,enty4,enty5,te) )
      + sum(pc2te(enty,enty3,te,enty2),
        sum(teCCS2rlf(te,rlf),
          pm_prodCouple(regi,enty,enty3,te,enty2) * vm_co2CCS(ttot,regi,enty,enty3,te,rlf) ) )
    =l=
    1.05 *
    sum(pe2se(enty,enty2,te), p47_prodSe(ttot,regi,enty,enty2,te) )
      + sum(se2se(enty,enty2,te), p47_prodSe(ttot,regi,enty,enty2,te) )
      + sum(pc2te(enty,entySE(enty3),te,enty2), 
        p47_prodCouple(regi,enty,enty3,te,enty2) * p47_prodSe(ttot,regi,enty,enty3,te) )
      + sum(pc2te(enty4,entyFE(enty5),te,enty2), 
        p47_prodCouple(regi,enty4,enty5,te,enty2) * p47_prodFe(ttot,regi,enty4,enty5,te) )
      + sum(pc2te(enty,enty3,te,enty2),
        sum(teCCS2rlf(te,rlf),
          p47_prodCouple(regi,enty,enty3,te,enty2) * p47_co2CCS(ttot,regi,enty,enty3,te,rlf) ) )
;

q47_se_floor(ttot,regi)$(ttot.val le 2030)..
sum(pe2se(enty,enty2,te), vm_prodSe(ttot,regi,enty,enty2,te) )
      + sum(se2se(enty,enty2,te), vm_prodSe(ttot,regi,enty,enty2,te) )
      + sum(pc2te(enty,entySE(enty3),te,enty2), 
        pm_prodCouple(regi,enty,enty3,te,enty2) * vm_prodSe(ttot,regi,enty,enty3,te) )
      + sum(pc2te(enty4,entyFE(enty5),te,enty2), 
        pm_prodCouple(regi,enty4,enty5,te,enty2) * vm_prodFe(ttot,regi,enty4,enty5,te) )
      + sum(pc2te(enty,enty3,te,enty2),
        sum(teCCS2rlf(te,rlf),
          pm_prodCouple(regi,enty,enty3,te,enty2) * vm_co2CCS(ttot,regi,enty,enty3,te,rlf) ) )
    =g=
    0.95 *
    sum(pe2se(enty,enty2,te), p47_prodSe(ttot,regi,enty,enty2,te) )
      + sum(se2se(enty,enty2,te), p47_prodSe(ttot,regi,enty,enty2,te) )
      + sum(pc2te(enty,entySE(enty3),te,enty2), 
        p47_prodCouple(regi,enty,enty3,te,enty2) * p47_prodSe(ttot,regi,enty,enty3,te) )
      + sum(pc2te(enty4,entyFE(enty5),te,enty2), 
        p47_prodCouple(regi,enty4,enty5,te,enty2) * p47_prodFe(ttot,regi,enty4,enty5,te) )
      + sum(pc2te(enty,enty3,te,enty2),
        sum(teCCS2rlf(te,rlf),
          p47_prodCouple(regi,enty,enty3,te,enty2) * p47_co2CCS(ttot,regi,enty,enty3,te,rlf) ) )
;

***################ NEW APPROACH (TODO): SET UPPER BOUND ON COAL DEMAND IN ALL TIME STEPS WITHIN MRREMIND ###################
* Primary energy banding to prevent corner solutions
* q47_PE_ceiling(ttot,regi)$(ttot.val le 2030)..
*   sum(pe2se(enty,enty2,te), vm_demPe(ttot,regi,enty,enty2,te))
*   =l=
*   1.025 * sum(pe2se(enty,enty2,te), p47_demPe(ttot,regi,enty,enty2,te))
* ;

* q47_PE_floor(ttot,regi)$(ttot.val le 2030)..
*   sum(pe2se(enty,enty2,te), vm_demPe(ttot,regi,enty,enty2,te))
*   =g=
*   0.975 * sum(pe2se(enty,enty2,te), p47_demPe(ttot,regi,enty,enty2,te))
* ;

* Final energy banding to prevent corner solutions
q47_FE_ceiling(ttot,regi)$(ttot.val le 2030)..
    sum(se2fe(enty,entyFe,te), vm_prodFe(ttot,regi,enty,entyFe,te) )
    =l=
    1.05
    * sum(se2fe(enty,entyFe,te), p47_prodFe(ttot,regi,enty,entyFe,te) )
    ;

* Final energy banding to prevent corner solutions
q47_FE_floor(ttot,regi)$(ttot.val le 2030)..
    sum(se2fe(enty,entyFe,te), vm_prodFe(ttot,regi,enty,entyFe,te) )
    =g=
    0.95
    * sum(se2fe(enty,entyFe,te), p47_prodFe(ttot,regi,enty,entyFe,te) )

    ;


*** Limiting regional coal emissions (except solids) to aggregated national phase-out level
$ifthen.PPCA_2030 %cm_PPCA_OECD% == "on"
* q47_PPCA_OECD_demand_exit(t,regi)$(ttot.val ge cm_startyear AND (ttot.val lt 2050)$(sameas("%cm_PPCA_nonOECD%","on")))..
q47_PPCA_OECD_demand_exit(t,regi)..
    sum(ttot$(ttot.val ge 2030 AND ttot.val le 2100),
      sum(emi2te("pecoal",entySe,te,"co2")$(not sameas(entySe,"sesofos") AND not sameas(te,"coaltr")),
      vm_emiTeDetail(ttot,regi,"pecoal",entySe,te,"co2"))
    )
    =l= 
    ( 
      p47_max_coal_dem_share_oecd(regi,"demand")              !! read-in coal share parameter
          + (0.03 - p47_max_coal_dem_share_oecd(regi,"demand"))$(t.val le 2035 AND p47_max_coal_dem_share_oecd(regi,"demand") lt 0.03)
    )
    * sum(ttot$(ttot.val ge 2030 AND ttot.val le 2100), vm_emiAll(ttot,regi,"co2"))
     + (1e-3 - p47_max_coal_dem_share_oecd(regi,"demand"))$(p47_max_coal_dem_share_oecd(regi,"demand") le 1e-3) 
    ;

** Phase out solids except in steel
q47_PPCA_OECD_solids_exit(t,regi)..
    sum(ttot$(ttot.val ge 2030 AND ttot.val le 2100),
      vm_emiTeDetail(ttot,regi,"pecoal","sesofos","coaltr","co2")
    )
    =l=
    (
    p47_max_coal_dem_share_oecd(regi,"solids") 
         + (0.03 - p47_max_coal_dem_share_oecd(regi,"solids"))$(t.val le 2035 AND p47_max_coal_dem_share_oecd(regi,"solids") lt 0.03)
    )
        * sum(ttot$(ttot.val ge 2030 AND ttot.val le 2100), vm_emiAll(ttot,regi,"co2"))
* * sum(emi2te("pecoal",enty,te,"co2"),
*       vm_emiTeDetail(ttot,regi,"pecoal",enty,te,"co2"))
* + p47_max_coal_dem_share_oecd(regi,"solids")$(p47_max_coal_dem_share_oecd(regi,"solids") le 0.01)
      + (1e-4 - p47_max_coal_dem_share_oecd(regi,"solids"))$(p47_max_coal_dem_share_oecd(regi,"solids") le 1e-4)
    ;

q47_PPCA_OECD_steel_exit(t,regi)..
    !! net fesos emissions from steel subsector
    sum(ttot$(ttot.val ge 2050 AND ttot.val le 2100),
    (( vm_macBaseInd(ttot,regi,"fesos","steel")
    - vm_emiIndCCS(ttot,regi,"co2steel")
    )
    !! share of sesofos in fesos production
  * ( vm_prodFE(ttot,regi,"sesofos","fesos","tdfossos")
    / sum(se2fe(entySE,entyFe,te)$(sameas(entyFe,"fesos")),
        vm_prodFE(ttot,regi,entySE,entyFe,te) ) ) )
    )
    =l=
    (
    p47_max_coal_dem_share_oecd(regi,"steel")
         + (0.01 - p47_max_coal_dem_share_oecd(regi,"steel"))$(t.val le 2060 AND p47_max_coal_dem_share_oecd(regi,"steel") lt 0.01)
    )
        * sum(ttot$(ttot.val ge 2050 AND ttot.val le 2100), vm_emiAll(ttot,regi,"co2"))
* * sum(emi2te("pecoal",enty,te,"co2"),
*         vm_emiTeDetail(ttot,regi,"pecoal",enty,te,"co2"))
        + (1e-3 - p47_max_coal_dem_share_oecd(regi,"steel"))$(p47_max_coal_dem_share_oecd(regi,"steel") le 1e-3 AND t.val le 2060)
      ;

$endif.PPCA_2030


$ifthen.PPCA_2050 %cm_PPCA_nonOECD% == "on"

q47_PPCA_nonOECD_demand_exit(t,regi)..
* sum(emi2te(entyPe,entySe,te,enty)$(sameas(entyPe,"pecoal") AND not sameas(te,"coaltr") AND sameas(enty,"co2")),
*   vm_emiTeDetail(ttot,regi,entyPe,entySe,te,enty))
    sum(ttot$(ttot.val ge 2050 AND ttot.val le 2100),
    sum(emi2te("pecoal",entySe,te,"co2")$(not sameas(entySe,"sesofos") AND not sameas(te,"coaltr")),
      vm_emiTeDetail(ttot,regi,"pecoal",entySe,te,"co2"))
    )
    =l= 
    ( p47_max_coal_dem_share_nonoecd(regi,"demand")              !! read-in coal share parameter
    + (0.03 - p47_max_coal_dem_share_nonoecd(regi,"demand"))$(t.val le 2060 AND p47_max_coal_dem_share_nonoecd(regi,"demand") lt 0.03 AND p47_max_coal_dem_share_oecd(regi,"demand") ge 0.03)
    )
    * sum(ttot$(ttot.val ge 2050 AND ttot.val le 2100), vm_emiAll(ttot,regi,"co2"))
* * sum(emi2te(peFos(enty),entySe,te,"co2"),
* vm_emiTeDetail(ttot,regi,enty,entySe,te,"co2"))
    + (1e-3 - p47_max_coal_dem_share_nonoecd(regi,"demand"))$(p47_max_coal_dem_share_nonoecd(regi,"demand") le 1e-3)
      ;

q47_PPCA_nonOECD_solids_exit(t,regi)..
    sum(ttot$(ttot.val ge 2050 AND ttot.val le 2100),
      vm_emiTeDetail(ttot,regi,"pecoal","sesofos","coaltr","co2")
    )
    =l=
    ( p47_max_coal_dem_share_nonoecd(regi,"solids") 
        + (0.03 - p47_max_coal_dem_share_nonoecd(regi,"solids"))$(t.val le 2060 AND p47_max_coal_dem_share_nonoecd(regi,"solids") lt 0.03 AND p47_max_coal_dem_share_oecd(regi,"solids") ge 0.03)
    )
      * sum(ttot$(ttot.val ge 2050 AND ttot.val le 2100), vm_emiAll(ttot,regi,"co2"))
* * sum(emi2te("pecoal",enty,te,"co2"),
*     vm_emiTeDetail(ttot,regi,"pecoal",enty,te,"co2"))
    + (1e-3 - p47_max_coal_dem_share_nonoecd(regi,"solids"))$(p47_max_coal_dem_share_nonoecd(regi,"solids") le 1e-3)
    ;

q47_PPCA_nonOECD_steel_exit(t,regi)..
    sum(ttot$(ttot.val ge 2070 AND ttot.val le 2100),
    !! net fesos emissions from steel subsector
    (( vm_macBaseInd(ttot,regi,"fesos","steel")
    - vm_emiIndCCS(ttot,regi,"co2steel")
    )
    !! share of sesofos in fesos production
  * ( vm_prodFE(ttot,regi,"sesofos","fesos","tdfossos")
    / sum(se2fe(entySE,entyFe,te)$(sameas(entyFe,"fesos")),
        vm_prodFE(ttot,regi,entySE,entyFe,te) ) ) )
    )
    =l=
    ( p47_max_coal_dem_share_nonoecd(regi,"steel")
        + (0.01 - p47_max_coal_dem_share_nonoecd(regi,"steel"))$(t.val le 2080 AND p47_max_coal_dem_share_nonoecd(regi,"steel") lt 0.01  AND p47_max_coal_dem_share_oecd(regi,"steel") ge 0.01)
    )
      * sum(ttot$(ttot.val ge 2070 AND ttot.val le 2100), vm_emiAll(ttot,regi,"co2"))
* * sum(emi2te("pecoal",enty,te,"co2"),
*         vm_emiTeDetail(ttot,regi,"pecoal",enty,te,"co2"))
    + (1e-3 - p47_max_coal_dem_share_nonoecd(regi,"steel"))$(p47_max_coal_dem_share_nonoecd(regi,"steel") le 1e-3)
      ;

$endif.PPCA_2050
$endif.PPCA_pol


*** EOF ./modules/47_regipol/PPCAcoalExit/equations.gms