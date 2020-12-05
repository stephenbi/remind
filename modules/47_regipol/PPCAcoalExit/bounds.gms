*** |  (C) 2006-2019 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of REMIND and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  REMIND License Exception, version 1.0 (see LICENSE file).
*** |  Contact: remind@pik-potsdam.de
*** SOF ./modules/47_regipol/PPCAcoalExit/bounds.gms

Execute_Loadpoint 'input_ref' p47_prodCouple = pm_prodCouple;
Execute_Loadpoint 'input_ref' p47_prodSe = vm_prodSe.l;
Execute_Loadpoint 'input_ref' p47_prodFe = vm_prodFe.l;
Execute_Loadpoint 'input_ref' p47_co2CCS = vm_co2CCS.l;

$ifthen.policy %cm_PPCA_pol% == "demand"

* Fix sector shares to reference levels to prevent wild fluctuations due to coal phaseout
Execute_Loadpoint 'input_ref' p11_share_sector = p11_share_sector;


$endif.policy


** EOF ./modules/47_regipol/PPCAcoalExit/bounds.gms