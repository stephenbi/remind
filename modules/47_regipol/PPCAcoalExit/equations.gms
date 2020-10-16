*** |  (C) 2006-2019 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of REMIND and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  REMIND License Exception, version 1.0 (see LICENSE file).
*** |  Contact: remind@pik-potsdam.de
*** SOF ./modules/47_regipol/PPCAcoalExit/equations.gms

$ifthen.PPCA_pol %cm_PPCA_pol% == "power"
$ifthen.PPCA_OECD %cm_PPCA_OECD% == "on"
q47_PPCA_OECD_power_phaseOut(t,regi,entyPe,entySe)$(sameas(entyPe,"pecoal") AND sameas(entySe,"seel") AND t.val ge 2030 AND t.val lt 2050)..
sum(pe2se(enty,enty2,te)$(sameas(enty,"pecoal") AND sameas(enty2,"seel") AND (sameas(te,"pc") OR sameas(te,"coalchp") OR sameas(te,"igcc"))),
    vm_demSe(t,regi,entyPe,entySe,te)$(sameas(entyPe,"pecoal") AND sameas(entySe,"seel") AND t.val ge 2030 AND t.val lt 2050)) =l=
        p47_regiMaxCoalShare(t,regi)$(t.val eq 2030) * 
    sum(pe2se(enty,enty2,te)$(sameas(enty2,"seel")),
        vm_demSe(t,regi,entyPe,entySe,te)$(sameas(entySe,"seel") AND t.val ge 2030 AND t.val lt 2050));
$endif.PPCA_OECD

$ifthen.PPCA_nonOECD %cm_PPCA_nonOECD% == "on"
q47_PPCA_nonOECD_power_phaseOut(t,regi,entyPe,entySe)$(sameas(entyPe,"pecoal") AND sameas(entySe,"seel") AND t.val ge 2050)..
sum(pe2se(enty,enty2,te)$(sameas(enty,"pecoal") AND sameas(enty2,"seel") AND (sameas(te,"pc") OR sameas(te,"coalchp") OR sameas(te,"igcc"))),
    vm_demSe(t,regi,entyPe,entySe,te)$(sameas(entyPe,"pecoal") AND sameas(entySe,"seel") AND t.val ge 2050)) =l=
        p47_regiMaxCoalShare(t,regi)$(t.val eq 2050) * 
    sum(pe2se(enty,enty2,te)$(sameas(enty2,"seel")),
        vm_demSe(t,regi,entyPe,entySe,te)$(sameas(entySe,"seel") AND t.val ge 2050));
$endif.PPCA_nonOECD

$elseif.PPCA_pol %cm_PPCA_pol% == "demand"

$elseif.PPCA_pol %cm_PPCA_pol% == "demand_export"

$endif.PPCA_pol


q47_CovidCoalCap(t,regi,COV_coal)$(sameas(COV_coal,"%cm_COVID_coal_scen%") AND t.val eq 2025)..
sum(te$(sameas(te,"pc") OR sameas(te,"igcc") OR sameas(te,"coalchp")),
    sum(te2rlf(te,rlf),vm_cap(t,regi,te,rlf))) =l= 
    p47_coalCapCOVID(t,regi,COV_coal);

*** EOF ./modules/47_regipol/PPCAcoalExit/equations.gms