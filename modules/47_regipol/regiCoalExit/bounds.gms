*** |  (C) 2006-2019 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of REMIND and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  REMIND License Exception, version 1.0 (see LICENSE file).
*** |  Contact: remind@pik-potsdam.de
*** SOF ./modules/47_regipol/regiCoalExit/bounds.gms

*** Supply side coal phase out (Mining moratorium)
$ifthen.coalRegiPol %cm_coalExitRegi% == "supply"
    vm_fuExtr.fx(t,regi,enty,rlf)$(coal_sup_regi(regi) AND sameas(enty,"pecoal")) = 
        p47_coalExtr600(t,regi,enty,rlf)$(coal_sup_regi(regi) AND sameas(enty,"pecoal"));

$elseif.coalRegiPol %cm_coalExitRegi% == "demand"
    vm_demPe.fx(t,regi,entyPe,entySe,te)$(coal_dem_regi(regi) AND sameas(entyPe,"pecoal") ) = 
        p47_coalDem600(t,regi,entyPe,entySe,te)$(coal_dem_regi(regi) AND sameas(entyPe,"pecoal"));
*vm_cap.fx(t,regi,"igcc",rlf)$(coal_dem_regi(regi) AND t.val ge 2035) = 1E-6;
*vm_cap.fx(t,regi,"pc",rlf)$(coal_dem_regi(regi) AND t.val ge 2035) = 1E-6;
*vm_cap.fx(t,regi,"coalchp",rlf)$(coal_dem_regi(regi) AND t.val ge 2035) = 1E-6;
*vm_cap.fx(t,regi,"coalftrec",rlf)$(coal_dem_regi(regi) AND t.val ge 2035) = 1E-6;
*vm_cap.fx(t,regi,"coalh2",rlf)$(coal_dem_regi(regi) AND t.val ge 2035) = 1E-6;
*vm_cap.fx(t,regi,"coalgas",rlf)$(coal_dem_regi(regi) AND t.val ge 2035) = 1E-6;
*vm_cap.fx(t,regi,"coalhp",rlf)$(coal_dem_regi(regi) AND t.val ge 2035) = 1E-6;

$elseif.coalRegiPol %cm_coalExitRegi% == "PPCA"
    vm_demPe.fx(t,regi,entyPe,entySe,te)$(coal_PPCA_regi(regi) AND sameas(entyPe,"pecoal") AND sameas(entySe,"seel")) = 
        p47_coalPow600(t,regi,entyPe,entySe,te)$(coal_PPCA_regi(regi) AND sameas(entyPe,"pecoal") AND sameas(entySe,"seel"));

$elseif.coalRegiPol %cm_coalExitRegi% == "export"
    vm_Xport.fx(t,regi,enty)$(coal_exp_regi(regi) AND sameas(enty,"pecoal")) = 
        p47_coalExp600(t,regi,enty)$(coal_exp_regi(regi) AND sameas(enty,"pecoal"));

$elseif.coalRegiPol %cm_coalExitRegi% == "import"
    vm_Mport.fx(t,regi,enty)$(coal_imp_regi(regi) AND sameas(enty,"pecoal")) = 
        p47_coalImp600(t,regi,enty)$(coal_imp_regi(regi) AND sameas(enty,"pecoal"));

$elseif.coalRegiPol %cm_coalExitRegi% == "supplyPLUS"
    vm_fuExtr.fx(t,regi,enty,rlf)$(coal_sup_regiPLUS(regi) AND sameas(enty,"pecoal")) = 
        p47_coalExtr600(t,regi,enty,rlf)$(coal_sup_regiPLUS(regi) AND sameas(enty,"pecoal"));

$elseif.coalRegiPol %cm_coalExitRegi% == "demandPLUS"
    vm_demPe.fx(t,regi,entyPe,entySe,te)$(coal_dem_regiPLUS(regi) AND sameas(entyPe,"pecoal")) = 
        p47_coalDem600(t,regi,entyPe,entySe,te)$(coal_dem_regiPLUS(regi) AND sameas(entyPe,"pecoal"));

$elseif.coalRegiPol %cm_coalExitRegi% == "PPCA_PLUS"
    vm_demPe.fx(t,regi,entyPe,entySe,te)$(coal_dem_regiPLUS(regi) AND sameas(entyPe,"pecoal") AND sameas(entySe,"seel")) = 
        p47_coalPow600(t,regi,entyPe,entySe,te)$(coal_dem_regiPLUS(regi) AND sameas(entyPe,"pecoal") AND sameas(entySe,"seel"));

$elseif.coalRegiPol %cm_coalExitRegi% == "exportPLUS"
    vm_Xport.fx(t,regi,entyPe)$(coal_exp_regiPLUS(regi) AND sameas(entyPe,"pecoal")) = 
        p47_coalExp600(t,regi,entyPe)$(coal_exp_regiPLUS(regi) AND sameas(entyPe,"pecoal"));

$elseif.coalRegiPol %cm_coalExitRegi% == "importPLUS"
    vm_Mport.fx(t,regi,entyPe)$(coal_imp_regiPLUS(regi) AND sameas(entyPe,"pecoal")) = 
        p47_coalImp600(t,regi,entyPe)$(coal_imp_regiPLUS(regi) AND sameas(entyPe,"pecoal"));


$elseif.coalRegiPol %cm_coalExitRegi% == "supplyANDPPCA"
    vm_fuExtr.fx(t,regi,enty,rlf)$(coal_sup_regi(regi) AND sameas(enty,"pecoal")) = 
        p47_coalExtr600(t,regi,enty,rlf)$(coal_sup_regi(regi) AND sameas(enty,"pecoal"));
    vm_demPe.fx(t,regi,entyPe,entySe,te)$(coal_PPCA_regi(regi) AND sameas(entyPe,"pecoal") AND sameas(entySe,"seel")) = 
        p47_coalPow600(t,regi,entyPe,entySe,te)$(coal_PPCA_regi(regi) AND sameas(entyPe,"pecoal") AND sameas(entySe,"seel"));

$elseif.coalRegiPol %cm_coalExitRegi% == "importANDPPCA"
    vm_Mport.fx(t,regi,enty)$(coal_imp_regi(regi) AND sameas(enty,"pecoal")) = 
        p47_coalImp600(t,regi,enty)$(coal_imp_regi(regi) AND sameas(enty,"pecoal"));
    vm_demPe.fx(t,regi,entyPe,entySe,te)$(coal_PPCA_regi(regi) AND sameas(entyPe,"pecoal") AND sameas(entySe,"seel")) = 
        p47_coalPow600(t,regi,entyPe,entySe,te)$(coal_PPCA_regi(regi) AND sameas(entyPe,"pecoal") AND sameas(entySe,"seel"));

$elseif.coalRegiPol %cm_coalExitRegi% == "exportANDPPCA"
    vm_Xport.fx(t,regi,enty)$(coal_exp_regi(regi) AND sameas(enty,"pecoal")) = 
        p47_coalExp600(t,regi,enty)$(coal_exp_regi(regi) AND sameas(enty,"pecoal"));
    vm_demPe.fx(t,regi,entyPe,entySe,te)$(coal_PPCA_regi(regi) AND sameas(entyPe,"pecoal") AND sameas(entySe,"seel")) = 
        p47_coalPow600(t,regi,entyPe,entySe,te)$(coal_PPCA_regi(regi) AND sameas(entyPe,"pecoal") AND sameas(entySe,"seel"));

$elseif.coalRegiPol %cm_coalExitRegi% == "importANDextract"
    vm_Mport.fx(t,regi,enty)$(coal_imp_regi(regi) AND sameas(enty,"pecoal")) = 
        p47_coalImp600(t,regi,enty)$(coal_imp_regi(regi) AND sameas(enty,"pecoal"));
    vm_demPe.fx(t,regi,entyPe,entySe,te)$(coal_dem_regi(regi) AND sameas(entyPe,"pecoal")) = 
        p47_coalDem600(t,regi,entyPe,entySe,te)$(coal_dem_regi(regi) AND sameas(entyPe,"pecoal"));
    
$endif.coalRegiPol

*** EOF ./modules/47_regipol/regiCoalExit/bounds.gms
