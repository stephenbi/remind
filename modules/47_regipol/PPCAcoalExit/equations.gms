*** |  (C) 2006-2019 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of REMIND and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  REMIND License Exception, version 1.0 (see LICENSE file).
*** |  Contact: remind@pik-potsdam.de
*** SOF ./modules/47_regipol/PPCAcoalExit/equations.gms

$ifthen.cov_coal not %cm_COVID_coal_scen% == "none"
$ifthen.ref "%cm_PPCA_size%" == "none"
q47_CovidCoalCap(ttot,regi,cov_coal)$(sameas(cov_coal,"%cm_COVID_coal_scen%") AND ttot.val eq 2025)..
sum(te2rlf(te,rlf)$(sameas(te,"pc") OR sameas(te,"igcc") OR sameas(te,"coalchp")),
    vm_cap(ttot,regi,te,rlf))
    =e= 
    p47_coalCapCOVID(ttot,regi,cov_coal)
  ;
$endif.ref
$endif.cov_coal

$ifthen.PPCA_pol %cm_PPCA_pol% == "power"
$ifthen.PPCA_OECD %cm_PPCA_OECD% == "on"

q47_PPCA_OECD_power_phaseOut(regi,enty2)$(sameas(enty2,"seel") AND p47_max_coal_el_share_oecd(regi) gt 0)..
sum(ttot$(ttot.val ge 2030 AND ttot.val le 2100),
  sum(pe2se("pecoal",enty2,te)$(sameas(te,"pc") OR sameas(te,"coalchp") OR sameas(te,"igcc")),
    vm_prodSe(ttot,regi,"pecoal",enty2,te))
    + sum(pc2te("pecoal",entySE(enty3),te,enty2)$(sameas(te,"coalchp")),
		pm_prodCouple(regi,"pecoal",enty3,te,enty2) * vm_prodSe(ttot,regi,"pecoal",enty3,te))
)
    =l=
    ( 
      p47_max_coal_el_share_oecd(regi)              !! read-in coal share parameter
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
      + (1e-5 - p47_max_coal_el_share_oecd(regi))$(p47_max_coal_el_share_oecd(regi) le 1e-5)
;
$endif.PPCA_OECD

$ifthen.PPCA_nonOECD %cm_PPCA_nonOECD% == "on"
q47_PPCA_nonOECD_power_phaseOut(regi,enty2)$(sameas(enty2,"seel") AND p47_max_coal_el_share_nonoecd(regi) gt 0)..
sum(ttot$(ttot.val ge 2050 AND ttot.val le 2100),
  sum(pe2se("pecoal",enty2,te)$(sameas(te,"pc") OR sameas(te,"coalchp") OR sameas(te,"igcc")),
    vm_prodSe(ttot,regi,"pecoal",enty2,te))
    + sum(pc2te("pecoal",entySE(enty3),te,enty2)$(sameas(te,"coalchp")),
		pm_prodCouple(regi,"pecoal",enty3,te,enty2) * vm_prodSe(ttot,regi,"pecoal",enty3,te))
)
    =l=
    ( 
      p47_max_coal_el_share_nonoecd(regi)                                                                       !! read-in coal share parameter
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
      + (1e-5 - p47_max_coal_el_share_nonoecd(regi))$(p47_max_coal_el_share_nonoecd(regi) le 1e-5)
      ;   

q47_power_decline(ttot,regi,enty2)$((ttot.val gt 2050 AND sameas(enty2,"seel")AND p47_max_coal_el_share_nonoecd(regi) lt 1e-5 AND p47_max_coal_el_share_nonoecd(regi) gt 0 ) OR ttot.val gt 2100)..
sum(pe2se("pecoal",enty2,te)$(sameas(te,"pc") OR sameas(te,"coalchp") OR sameas(te,"igcc")),
    vm_prodSe(ttot,regi,"pecoal",enty2,te))
    + sum(pc2te("pecoal",entySE(enty3),te,enty2)$(sameas(te,"coalchp")),
		pm_prodCouple(regi,"pecoal",enty3,te,enty2) * vm_prodSe(ttot,regi,"pecoal",enty3,te))
    =l=
    sum(pe2se("pecoal",enty2,te)$(sameas(te,"pc") OR sameas(te,"coalchp") OR sameas(te,"igcc")),
    vm_prodSe(ttot-1,regi,"pecoal",enty2,te))
    + sum(pc2te("pecoal",entySE(enty3),te,enty2)$(sameas(te,"coalchp")),
		pm_prodCouple(regi,"pecoal",enty3,te,enty2) * vm_prodSe(ttot-1,regi,"pecoal",enty3,te))
;

$endif.PPCA_nonOECD


$elseif.PPCA_pol %cm_PPCA_pol% == "demand"
*** Limiting regional coal emissions (except solids) to aggregated national phase-out level
$ifthen.PPCA_2030 %cm_PPCA_OECD% == "on"
q47_PPCA_OECD_demand_exit(regi)$(p47_max_coal_dem_share_oecd(regi,"demand") gt 0)..
    sum(ttot$(ttot.val ge 2030 AND ttot.val le 2100),
      sum(emi2te("pecoal",entySe,te,"co2")$(not sameas(entySe,"sesofos") AND not sameas(te,"coaltr")),
      vm_emiTeDetail(ttot,regi,"pecoal",entySe,te,"co2"))
    )
    =l= 
    sum(ttot$(ttot.val ge 2030 AND ttot.val le 2100), 
    ( 
      p47_max_coal_dem_share_oecd(regi,"demand")              !! read-in coal share parameter
*          + (0.01 - p47_max_coal_dem_share_oecd(regi,"demand"))$(ttot.val le 2035 AND p47_max_coal_dem_share_oecd(regi,"demand") lt 0.01)
    )
    * vm_emiAll(ttot,regi,"co2")
     + (1e-5 - p47_max_coal_dem_share_oecd(regi,"demand"))$(p47_max_coal_dem_share_oecd(regi,"demand") le 1e-5) 
    )
    ;

** Phase out solids except in steel
q47_PPCA_OECD_solids_exit(regi)$(p47_max_coal_dem_share_oecd(regi,"solids") gt 0)..
    sum(ttot$(ttot.val ge 2030 AND ttot.val le 2100),
      vm_emiTeDetail(ttot,regi,"pecoal","sesofos","coaltr","co2")
    )
    =l=
    sum(ttot$(ttot.val ge 2030 AND ttot.val le 2100), 
    (
    p47_max_coal_dem_share_oecd(regi,"solids") 
*         + (0.01 - p47_max_coal_dem_share_oecd(regi,"solids"))$(ttot.val le 2035 AND p47_max_coal_dem_share_oecd(regi,"solids") lt 0.01)
    )
        * vm_emiAll(ttot,regi,"co2")
      + (1e-5 - p47_max_coal_dem_share_oecd(regi,"solids"))$(p47_max_coal_dem_share_oecd(regi,"solids") le 1e-5)
    )
    ;

q47_PPCA_OECD_steel_exit(regi)$(p47_max_coal_dem_share_oecd(regi,"steel") gt 0)..
    !! net fesos emissions from steel subsector
    sum(ttot$(ttot.val ge 2040 AND ttot.val le 2100),
    (( vm_macBaseInd(ttot,regi,"fesos","steel")
    - vm_emiIndCCS(ttot,regi,"co2steel")
    )
    !! share of sesofos in fesos production
  * ( vm_prodFE(ttot,regi,"sesofos","fesos","tdfossos")
    / sum(se2fe(entySE,entyFe,te)$(sameas(entyFe,"fesos")),
        vm_prodFE(ttot,regi,entySE,entyFe,te) ) ) )
    )
    =l=
    sum(ttot$(ttot.val ge 2040 AND ttot.val le 2100), 
    (
    p47_max_coal_dem_share_oecd(regi,"steel")
*         + (0.01 - p47_max_coal_dem_share_oecd(regi,"steel"))$(ttot.val le 2045 AND p47_max_coal_dem_share_oecd(regi,"steel") lt 0.01)
    )
        * vm_emiAll(ttot,regi,"co2")
        + (1e-5 - p47_max_coal_dem_share_oecd(regi,"steel"))$(p47_max_coal_dem_share_oecd(regi,"steel") le 1e-5 AND ttot.val le 2045)
    )
      ;

$endif.PPCA_2030


$ifthen.PPCA_2050 %cm_PPCA_nonOECD% == "on"

q47_PPCA_nonOECD_demand_exit(regi)$(p47_max_coal_dem_share_nonoecd(regi,"demand") gt 0)..
    sum(ttot$(ttot.val ge 2050 AND ttot.val le 2100),
    sum(emi2te("pecoal",entySe,te,"co2")$(not sameas(entySe,"sesofos") AND not sameas(te,"coaltr")),
      vm_emiTeDetail(ttot,regi,"pecoal",entySe,te,"co2"))
    )
    =l= 
    sum(ttot$(ttot.val ge 2050 AND ttot.val le 2100), 
    ( p47_max_coal_dem_share_nonoecd(regi,"demand")              !! read-in coal share parameter
*    + (0.01 - p47_max_coal_dem_share_nonoecd(regi,"demand"))$(ttot.val le 2060 AND p47_max_coal_dem_share_nonoecd(regi,"demand") lt 0.01 AND p47_max_coal_dem_share_oecd(regi,"demand") ge 0.01)
    )
    * vm_emiAll(ttot,regi,"co2")
    + (1e-5 - p47_max_coal_dem_share_nonoecd(regi,"demand"))$(p47_max_coal_dem_share_nonoecd(regi,"demand") le 1e-5)
    )
      ;

q47_PPCA_nonOECD_solids_exit(regi)$(p47_max_coal_dem_share_nonoecd(regi,"solids") gt 0)..
    sum(ttot$(ttot.val ge 2050 AND ttot.val le 2100),
      vm_emiTeDetail(ttot,regi,"pecoal","sesofos","coaltr","co2")
    )
    =l=
    sum(ttot$(ttot.val ge 2050 AND ttot.val le 2100), 
    ( p47_max_coal_dem_share_nonoecd(regi,"solids") 
*        + (0.01 - p47_max_coal_dem_share_nonoecd(regi,"solids"))$(ttot.val le 2060 AND p47_max_coal_dem_share_nonoecd(regi,"solids") lt 0.01 AND p47_max_coal_dem_share_oecd(regi,"solids") ge 0.01)
    )
      * vm_emiAll(ttot,regi,"co2")
    + (1e-5 - p47_max_coal_dem_share_nonoecd(regi,"solids"))$(p47_max_coal_dem_share_nonoecd(regi,"solids") le 1e-5)
    )
    ;

q47_PPCA_nonOECD_steel_exit(regi)$(p47_max_coal_dem_share_nonoecd(regi,"steel") gt 0)..
    sum(ttot$(ttot.val ge 2060 AND ttot.val le 2100),
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
    sum(ttot$(ttot.val ge 2060 AND ttot.val le 2100), 
    ( p47_max_coal_dem_share_nonoecd(regi,"steel")
*        + (0.01 - p47_max_coal_dem_share_nonoecd(regi,"steel"))$(ttot.val le 2070 AND p47_max_coal_dem_share_nonoecd(regi,"steel") lt 0.01  AND p47_max_coal_dem_share_oecd(regi,"steel") ge 0.01)
    )
      * vm_emiAll(ttot,regi,"co2")
    + (1e-5 - p47_max_coal_dem_share_nonoecd(regi,"steel"))$(p47_max_coal_dem_share_nonoecd(regi,"steel") le 1e-5 AND ttot.val le 2070)
    )
      ;

q47_demand_decline(ttot,regi,enty2)$((ttot.val gt 2050 AND sameas(enty2,"seel") AND p47_max_coal_dem_share_nonoecd(regi,"demand") gt 0 AND p47_max_coal_dem_share_nonoecd(regi,"demand") lt 1e-5) OR ttot.val gt 2100)..
sum(emi2te("pecoal",entySe,te,"co2"),
      vm_emiTeDetail(ttot,regi,"pecoal",entySe,te,"co2"))
      =l=
      sum(emi2te("pecoal",entySe,te,"co2"),
      vm_emiTeDetail(ttot-1,regi,"pecoal",entySe,te,"co2"))
;

$endif.PPCA_2050
$endif.PPCA_pol


*** EOF ./modules/47_regipol/PPCAcoalExit/equations.gms