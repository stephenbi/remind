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

$elseif.coalRegiPol %cm_coalExitRegi% == "PPCA"
    vm_cap.fx(t,coal_PPCA_regi,"igcc",rlf)$((OECD_regi(coal_PPCA_regi) AND t.val ge 2030) OR 
        (nonOECD_regi(coal_PPCA_regi) AND t.val ge 2050)) = 1E-6;
    vm_cap.fx(t,coal_PPCA_regi,"pc",rlf)$((OECD_regi(coal_PPCA_regi) AND t.val ge 2030) OR 
        (nonOECD_regi(coal_PPCA_regi) AND t.val ge 2050)) = 1E-6;
    vm_cap.fx(t,coal_PPCA_regi,"coalchp",rlf)$((OECD_regi(coal_PPCA_regi) AND t.val ge 2030) OR 
        (nonOECD_regi(coal_PPCA_regi) AND t.val ge 2050)) = 1E-6;
    vm_cap.fx(t,coal_PPCA_regi,"coalftrec",rlf)$((OECD_regi(coal_PPCA_regi) AND t.val ge 2030) OR 
        (nonOECD_regi(coal_PPCA_regi) AND t.val ge 2050)) = 1E-6;
    vm_cap.fx(t,coal_PPCA_regi,"coalh2",rlf)$((OECD_regi(coal_PPCA_regi) AND t.val ge 2030) OR 
        (nonOECD_regi(coal_PPCA_regi) AND t.val ge 2050)) = 1E-6;
    vm_cap.fx(t,coal_PPCA_regi,"coalgas",rlf)$((OECD_regi(coal_PPCA_regi) AND t.val ge 2030) OR 
        (nonOECD_regi(coal_PPCA_regi) AND t.val ge 2050)) = 1E-6;
    vm_cap.fx(t,coal_PPCA_regi,"coalhp",rlf)$((OECD_regi(coal_PPCA_regi) AND t.val ge 2030) OR 
        (nonOECD_regi(coal_PPCA_regi) AND t.val ge 2050)) = 1E-6;
*vm_demPe.fx(t,regi,entyPe,entySe,te)$(coal_PPCA_regi(regi) AND t.val ge 2035 AND sameas(entyPe,"pecoal") AND sameas(entySe,"seel")) = 
*       1e-6; !!p47_coalPow600(t,regi,entyPe,entySe,te)$(coal_PPCA_regi(regi) AND sameas(entyPe,"pecoal") AND sameas(entySe,"seel"));

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
    vm_cap.fx(t,OECD_regi,"igcc",rlf)$(t.val ge 2030) = 1E-6;
    vm_cap.fx(t,OECD_regi,"pc",rlf)$(t.val ge 2030) = 1E-6;
    vm_cap.fx(t,OECD_regi,"coalchp",rlf)$(t.val ge 2030) = 1E-6;
    vm_cap.fx(t,OECD_regi,"coalftrec",rlf)$(t.val ge 2030) = 1E-6;
    vm_cap.fx(t,OECD_regi,"coalh2",rlf)$(t.val ge 2030) = 1E-6;
    vm_cap.fx(t,OECD_regi,"coalgas",rlf)$(t.val ge 2030) = 1E-6;
    vm_cap.fx(t,OECD_regi,"coalhp",rlf)$(t.val ge 2030) = 1E-6;
    vm_cap.fx(t,nonOECD_regi,"igcc",rlf)$(t.val ge 2050) = 1E-6;
    vm_cap.fx(t,nonOECD_regi,"pc",rlf)$(t.val ge 2050) = 1E-6;
    vm_cap.fx(t,nonOECD_regi,"coalchp",rlf)$(t.val ge 2050) = 1E-6;
    vm_cap.fx(t,nonOECD_regi,"coalftrec",rlf)$(t.val ge 2050) = 1E-6;
    vm_cap.fx(t,nonOECD_regi,"coalh2",rlf)$(t.val ge 2050) = 1E-6;
    vm_cap.fx(t,nonOECD_regi,"coalgas",rlf)$(t.val ge 2050) = 1E-6;
    vm_cap.fx(t,nonOECD_regi,"coalhp",rlf)$(t.val ge 2050) = 1E-6;

$elseif.coalRegiPol %cm_coalExitRegi% == "exportPLUS"
    vm_Xport.fx(t,regi,entyPe)$(coal_exp_regiPLUS(regi) AND sameas(entyPe,"pecoal")) = 
        p47_coalExp600(t,regi,entyPe)$(coal_exp_regiPLUS(regi) AND sameas(entyPe,"pecoal"));

$elseif.coalRegiPol %cm_coalExitRegi% == "importPLUS"
    vm_Mport.fx(t,regi,entyPe)$(coal_imp_regiPLUS(regi) AND sameas(entyPe,"pecoal")) = 
        p47_coalImp600(t,regi,entyPe)$(coal_imp_regiPLUS(regi) AND sameas(entyPe,"pecoal"));


$elseif.coalRegiPol %cm_coalExitRegi% == "supplyANDPPCA"
    vm_fuExtr.fx(t,regi,enty,rlf)$(coal_sup_regi(regi) AND sameas(enty,"pecoal")) = 
        p47_coalExtr600(t,regi,enty,rlf)$(coal_sup_regi(regi) AND sameas(enty,"pecoal"));
    vm_cap.fx(t,coal_PPCA_regi,"igcc",rlf)$(t.val ge 2035) = 1E-6;
    vm_cap.fx(t,coal_PPCA_regi,"pc",rlf)$(t.val ge 2035) = 1E-6;
    vm_cap.fx(t,coal_PPCA_regi,"coalchp",rlf)$(t.val ge 2035) = 1E-6;
    vm_cap.fx(t,coal_PPCA_regi,"coalftrec",rlf)$(t.val ge 2035) = 1E-6;
    vm_cap.fx(t,coal_PPCA_regi,"coalh2",rlf)$(t.val ge 2035) = 1E-6;
    vm_cap.fx(t,coal_PPCA_regi,"coalgas",rlf)$(t.val ge 2035) = 1E-6;
    vm_cap.fx(t,coal_PPCA_regi,"coalhp",rlf)$(t.val ge 2035) = 1E-6;

$elseif.coalRegiPol %cm_coalExitRegi% == "importANDPPCA"
    vm_Mport.fx(t,regi,enty)$(coal_imp_regi(regi) AND sameas(enty,"pecoal")) = 
        p47_coalImp600(t,regi,enty)$(coal_imp_regi(regi) AND sameas(enty,"pecoal"));
    vm_cap.fx(t,coal_PPCA_regi,"igcc",rlf)$((OECD_regi(coal_PPCA_regi) AND t.val ge 2030) OR 
        (nonOECD_regi(coal_PPCA_regi) AND t.val ge 2050)) = 1E-6;
    vm_cap.fx(t,coal_PPCA_regi,"pc",rlf)$((OECD_regi(coal_PPCA_regi) AND t.val ge 2030) OR 
        (nonOECD_regi(coal_PPCA_regi) AND t.val ge 2050)) = 1E-6;
    vm_cap.fx(t,coal_PPCA_regi,"coalchp",rlf)$((OECD_regi(coal_PPCA_regi) AND t.val ge 2030) OR 
        (nonOECD_regi(coal_PPCA_regi) AND t.val ge 2050)) = 1E-6;
    vm_cap.fx(t,coal_PPCA_regi,"coalftrec",rlf)$((OECD_regi(coal_PPCA_regi) AND t.val ge 2030) OR 
        (nonOECD_regi(coal_PPCA_regi) AND t.val ge 2050)) = 1E-6;
    vm_cap.fx(t,coal_PPCA_regi,"coalh2",rlf)$((OECD_regi(coal_PPCA_regi) AND t.val ge 2030) OR 
        (nonOECD_regi(coal_PPCA_regi) AND t.val ge 2050)) = 1E-6;
    vm_cap.fx(t,coal_PPCA_regi,"coalgas",rlf)$((OECD_regi(coal_PPCA_regi) AND t.val ge 2030) OR 
        (nonOECD_regi(coal_PPCA_regi) AND t.val ge 2050)) = 1E-6;
    vm_cap.fx(t,coal_PPCA_regi,"coalhp",rlf)$((OECD_regi(coal_PPCA_regi) AND t.val ge 2030) OR 
        (nonOECD_regi(coal_PPCA_regi) AND t.val ge 2050)) = 1E-6;

$elseif.coalRegiPol %cm_coalExitRegi% == "exportANDPPCA"
    vm_Xport.fx(t,regi,enty)$(coal_exp_regi(regi) AND sameas(enty,"pecoal")) = 
        p47_coalExp600(t,regi,enty)$(coal_exp_regi(regi) AND sameas(enty,"pecoal"));
    vm_cap.fx(t,coal_PPCA_regi,"igcc",rlf)$((OECD_regi(coal_PPCA_regi) AND t.val ge 2030) OR 
        (nonOECD_regi(coal_PPCA_regi) AND t.val ge 2050)) = 1E-6;
    vm_cap.fx(t,coal_PPCA_regi,"pc",rlf)$((OECD_regi(coal_PPCA_regi) AND t.val ge 2030) OR 
        (nonOECD_regi(coal_PPCA_regi) AND t.val ge 2050)) = 1E-6;
    vm_cap.fx(t,coal_PPCA_regi,"coalchp",rlf)$((OECD_regi(coal_PPCA_regi) AND t.val ge 2030) OR 
        (nonOECD_regi(coal_PPCA_regi) AND t.val ge 2050)) = 1E-6;
    vm_cap.fx(t,coal_PPCA_regi,"coalftrec",rlf)$((OECD_regi(coal_PPCA_regi) AND t.val ge 2030) OR 
        (nonOECD_regi(coal_PPCA_regi) AND t.val ge 2050)) = 1E-6;
    vm_cap.fx(t,coal_PPCA_regi,"coalh2",rlf)$((OECD_regi(coal_PPCA_regi) AND t.val ge 2030) OR 
        (nonOECD_regi(coal_PPCA_regi) AND t.val ge 2050)) = 1E-6;
    vm_cap.fx(t,coal_PPCA_regi,"coalgas",rlf)$((OECD_regi(coal_PPCA_regi) AND t.val ge 2030) OR 
        (nonOECD_regi(coal_PPCA_regi) AND t.val ge 2050)) = 1E-6;
    vm_cap.fx(t,coal_PPCA_regi,"coalhp",rlf)$((OECD_regi(coal_PPCA_regi) AND t.val ge 2030) OR 
        (nonOECD_regi(coal_PPCA_regi) AND t.val ge 2050)) = 1E-6;

$elseif.coalRegiPol %cm_coalExitRegi% == "importANDextract"
    vm_Mport.fx(t,regi,enty)$(coal_imp_regi(regi) AND sameas(enty,"pecoal")) = 
        p47_coalImp600(t,regi,enty)$(coal_imp_regi(regi) AND sameas(enty,"pecoal"));
    vm_demPe.fx(t,regi,entyPe,entySe,te)$(coal_dem_regi(regi) AND sameas(entyPe,"pecoal")) = 
        p47_coalDem600(t,regi,entyPe,entySe,te)$(coal_dem_regi(regi) AND sameas(entyPe,"pecoal"));

$elseif.coalRegiPol %cm_coalExitRegi% == "supplyANDPPCAplus"
    vm_fuExtr.fx(t,regi,enty,rlf)$(coal_sup_regiPLUS(regi) AND sameas(enty,"pecoal")) = 
        p47_coalExtr600(t,regi,enty,rlf)$(coal_sup_regiPLUS(regi) AND sameas(enty,"pecoal"));
    vm_cap.fx(t,OECD_regi,"igcc",rlf)$(t.val ge 2030) = 1E-6;
    vm_cap.fx(t,OECD_regi,"pc",rlf)$(t.val ge 2030) = 1E-6;
    vm_cap.fx(t,OECD_regi,"coalchp",rlf)$(t.val ge 2030) = 1E-6;
    vm_cap.fx(t,OECD_regi,"coalftrec",rlf)$(t.val ge 2030) = 1E-6;
    vm_cap.fx(t,OECD_regi,"coalh2",rlf)$(t.val ge 2030) = 1E-6;
    vm_cap.fx(t,OECD_regi,"coalgas",rlf)$(t.val ge 2030) = 1E-6;
    vm_cap.fx(t,OECD_regi,"coalhp",rlf)$(t.val ge 2030) = 1E-6;
    vm_cap.fx(t,nonOECD_regi,"igcc",rlf)$(t.val ge 2050) = 1E-6;
    vm_cap.fx(t,nonOECD_regi,"pc",rlf)$(t.val ge 2050) = 1E-6;
    vm_cap.fx(t,nonOECD_regi,"coalchp",rlf)$(t.val ge 2050) = 1E-6;
    vm_cap.fx(t,nonOECD_regi,"coalftrec",rlf)$(t.val ge 2050) = 1E-6;
    vm_cap.fx(t,nonOECD_regi,"coalh2",rlf)$(t.val ge 2050) = 1E-6;
    vm_cap.fx(t,nonOECD_regi,"coalgas",rlf)$(t.val ge 2050) = 1E-6;
    vm_cap.fx(t,nonOECD_regi,"coalhp",rlf)$(t.val ge 2050) = 1E-6;

$elseif.coalRegiPol %cm_coalExitRegi% == "importANDPPCAplus"
    vm_Mport.fx(t,regi,enty)$(coal_imp_regiPLUS(regi) AND sameas(enty,"pecoal")) = 
        p47_coalImp600(t,regi,enty)$(coal_imp_regiPLUS(regi) AND sameas(enty,"pecoal"));
    vm_cap.fx(t,OECD_regi,"igcc",rlf)$(t.val ge 2030) = 1E-6;
    vm_cap.fx(t,OECD_regi,"pc",rlf)$(t.val ge 2030) = 1E-6;
    vm_cap.fx(t,OECD_regi,"coalchp",rlf)$(t.val ge 2030) = 1E-6;
    vm_cap.fx(t,OECD_regi,"coalftrec",rlf)$(t.val ge 2030) = 1E-6;
    vm_cap.fx(t,OECD_regi,"coalh2",rlf)$(t.val ge 2030) = 1E-6;
    vm_cap.fx(t,OECD_regi,"coalgas",rlf)$(t.val ge 2030) = 1E-6;
    vm_cap.fx(t,OECD_regi,"coalhp",rlf)$(t.val ge 2030) = 1E-6;
    vm_cap.fx(t,nonOECD_regi,"igcc",rlf)$(t.val ge 2050) = 1E-6;
    vm_cap.fx(t,nonOECD_regi,"pc",rlf)$(t.val ge 2050) = 1E-6;
    vm_cap.fx(t,nonOECD_regi,"coalchp",rlf)$(t.val ge 2050) = 1E-6;
    vm_cap.fx(t,nonOECD_regi,"coalftrec",rlf)$(t.val ge 2050) = 1E-6;
    vm_cap.fx(t,nonOECD_regi,"coalh2",rlf)$(t.val ge 2050) = 1E-6;
    vm_cap.fx(t,nonOECD_regi,"coalgas",rlf)$(t.val ge 2050) = 1E-6;
    vm_cap.fx(t,nonOECD_regi,"coalhp",rlf)$(t.val ge 2050) = 1E-6;

$elseif.coalRegiPol %cm_coalExitRegi% == "exportANDPPCAplus"
    vm_Xport.fx(t,regi,enty)$(coal_exp_regiPLUS(regi) AND sameas(enty,"pecoal")) = 
        p47_coalExp600(t,regi,enty)$(coal_exp_regiPLUS(regi) AND sameas(enty,"pecoal"));
    vm_cap.fx(t,OECD_regi,"igcc",rlf)$(t.val ge 2030) = 1E-6;
    vm_cap.fx(t,OECD_regi,"pc",rlf)$(t.val ge 2030) = 1E-6;
    vm_cap.fx(t,OECD_regi,"coalchp",rlf)$(t.val ge 2030) = 1E-6;
    vm_cap.fx(t,OECD_regi,"coalftrec",rlf)$(t.val ge 2030) = 1E-6;
    vm_cap.fx(t,OECD_regi,"coalh2",rlf)$(t.val ge 2030) = 1E-6;
    vm_cap.fx(t,OECD_regi,"coalgas",rlf)$(t.val ge 2030) = 1E-6;
    vm_cap.fx(t,OECD_regi,"coalhp",rlf)$(t.val ge 2030) = 1E-6;
    vm_cap.fx(t,nonOECD_regi,"igcc",rlf)$(t.val ge 2050) = 1E-6;
    vm_cap.fx(t,nonOECD_regi,"pc",rlf)$(t.val ge 2050) = 1E-6;
    vm_cap.fx(t,nonOECD_regi,"coalchp",rlf)$(t.val ge 2050) = 1E-6;
    vm_cap.fx(t,nonOECD_regi,"coalftrec",rlf)$(t.val ge 2050) = 1E-6;
    vm_cap.fx(t,nonOECD_regi,"coalh2",rlf)$(t.val ge 2050) = 1E-6;
    vm_cap.fx(t,nonOECD_regi,"coalgas",rlf)$(t.val ge 2050) = 1E-6;
    vm_cap.fx(t,nonOECD_regi,"coalhp",rlf)$(t.val ge 2050) = 1E-6;

$elseif.coalRegiPol %cm_coalExitRegi% == "supplyANDdemand"
    vm_fuExtr.fx(t,regi,enty,rlf)$(coal_sup_regi(regi) AND sameas(enty,"pecoal")) = 
        p47_coalExtr600(t,regi,enty,rlf)$(coal_sup_regi(regi) AND sameas(enty,"pecoal"));
    vm_demPe.fx(t,regi,entyPe,entySe,te)$(coal_dem_regi(regi) AND sameas(entyPe,"pecoal") ) = 
        p47_coalDem600(t,regi,entyPe,entySe,te)$(coal_dem_regi(regi) AND sameas(entyPe,"pecoal"));

$elseif.coalRegiPol %cm_coalExitRegi% == "importANDexport"
    vm_Mport.fx(t,regi,enty)$(coal_imp_regi(regi) AND sameas(enty,"pecoal")) = 
        p47_coalImp600(t,regi,enty)$(coal_imp_regi(regi) AND sameas(enty,"pecoal"));
    vm_Xport.fx(t,regi,enty)$(coal_exp_regi(regi) AND sameas(enty,"pecoal")) = 
        p47_coalExp600(t,regi,enty)$(coal_exp_regi(regi) AND sameas(enty,"pecoal"));

$elseif.coalRegiPol %cm_coalExitRegi% == "importANDextract"
    vm_Mport.fx(t,regi,enty)$(coal_imp_regiPLUS(regi) AND sameas(enty,"pecoal")) = 
        p47_coalImp600(t,regi,enty)$(coal_imp_regiPLUS(regi) AND sameas(enty,"pecoal"));
    vm_demPe.fx(t,regi,entyPe,entySe,te)$(coal_dem_regiPLUS(regi) AND sameas(entyPe,"pecoal")) = 
        p47_coalDem600(t,regi,entyPe,entySe,te)$(coal_dem_regiPLUS(regi) AND sameas(entyPe,"pecoal"));

$elseif.coalRegiPol %cm_coalExitRegi% == "supplyANDdemandplus"
    vm_fuExtr.fx(t,regi,enty,rlf)$(coal_sup_regiPLUS(regi) AND sameas(enty,"pecoal")) = 
        p47_coalExtr600(t,regi,enty,rlf)$(coal_sup_regiPLUS(regi) AND sameas(enty,"pecoal"));
    vm_demPe.fx(t,regi,entyPe,entySe,te)$(coal_dem_regiPLUS(regi) AND sameas(entyPe,"pecoal") ) = 
        p47_coalDem600(t,regi,entyPe,entySe,te)$(coal_dem_regiPLUS(regi) AND sameas(entyPe,"pecoal"));

$elseif.coalRegiPol %cm_coalExitRegi% == "importANDexportplus"
    vm_Mport.fx(t,regi,enty)$(coal_imp_regiPLUS(regi) AND sameas(enty,"pecoal")) = 
        p47_coalImp600(t,regi,enty)$(coal_imp_regiPLUS(regi) AND sameas(enty,"pecoal"));
    vm_Xport.fx(t,regi,enty)$(coal_exp_regiPLUS(regi) AND sameas(enty,"pecoal")) = 
        p47_coalExp600(t,regi,enty)$(coal_exp_regiPLUS(regi) AND sameas(enty,"pecoal"));

$endif.coalRegiPol

*** EOF ./modules/47_regipol/regiCoalExit/bounds.gms
