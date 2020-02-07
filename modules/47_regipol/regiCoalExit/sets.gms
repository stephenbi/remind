*** |  (C) 2006-2019 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of REMIND and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  REMIND License Exception, version 1.0 (see LICENSE file).
*** |  Contact: remind@pik-potsdam.de
*** SOF ./modules/47_regipol/regiCoalExit/sets.gms

SETS
	coal_sup_regi(all_regi) "coalition willing to phase out coal extraction" / EUR, JPN, LAM, MEA, NEU, USA /
	coal_dem_regi(all_regi) "coalition willing to phase out coal consumption" / CAZ, EUR, LAM, MEA, NEU, USA / !!swing regions - USA, CAZ, SSA 
	coal_PPCA_regi(all_regi) "coalition willing to phase out coal power generation" / CAZ, EUR, LAM, MEA /  
	coal_exp_regi(all_regi) "coalition willing to phase out coal exports" / CHA, EUR, IND, JPN, MEA, NEU, OAS /
	coal_imp_regi(all_regi) "coalition willing to phase out coal imports" / CAZ, EUR, IND, LAM, MEA, NEU, REF, SSA, USA /

	coal_sup_regiPLUS(all_regi) "coalition willing to phase out coal extraction" / CAZ, EUR, JPN, LAM, MEA, NEU, USA /  !! supply plus CAZ
	coal_dem_regiPLUS(all_regi) "coalition willing to phase out coal consumption" / CAZ, EUR, JPN, LAM, MEA, NEU, USA /  !! demand plus JPN
	coal_PPCA_regiPLUS(all_regi) "coalition willing to phase out coal power generation" / CAZ, EUR, LAM, MEA /  !! no change
	coal_exp_regiPLUS(all_regi) "coalition willing to phase out coal exports" / CAZ, CHA, EUR, IND, JPN, MEA, NEU, OAS, USA /  !! export plus CAZ & USA
	coal_imp_regiPLUS(all_regi) "coalition willing to phase out coal imports" / CAZ, EUR, IND, JPN, LAM, MEA, NEU, REF, SSA, USA /  !! import plus JPN
;

*** EOF ./modules/47_regipol/regiCoalExit/sets.gms
