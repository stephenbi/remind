*** |  (C) 2006-2019 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of REMIND and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  REMIND License Exception, version 1.0 (see LICENSE file).
*** |  Contact: remind@pik-potsdam.de
*** SOF ./modules/47_regipol/PPCAcoalExit/sets.gms

SETS
coalElTeNoCCS(all_enty,all_enty,all_te)  "Mapping for coal power technologies without carbon capture"
/
pecoal.seel.pc
pecoal.seel.coalchp
pecoal.seel.igcc
/

cov_coal "COVID coal sector recovery scenario"
/
BAU
Green
Brown
Norm
/

ppca_phase "Accession stage of the PPCA policy initiative (OECD = 2030, NonOECD = 2050)"
/
oecd
nonoecd
/
;


*** EOF ./modules/47_regipol/PPCAcoalExit/sets.gms