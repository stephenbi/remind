*** |  (C) 2006-2020 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of REMIND and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  REMIND License Exception, version 1.0 (see LICENSE file).
*** |  Contact: remind@pik-potsdam.de
*** SOF ./modules/32_power/IntC/presolve.gms


*** FS: calculate electricity price of last iteration in trUSD2005/TWa
pm_priceSeel(t,regi)=q32_balSe.m(t,regi,"seel")/(qm_budget.m(t,regi)+sm_eps);

Display "electricity price", pm_priceSeel;

*** EOF ./modules/32_power/IntC/presolve.gms
