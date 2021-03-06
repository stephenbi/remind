*** |  (C) 2006-2019 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of REMIND and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  REMIND License Exception, version 1.0 (see LICENSE file).
*** |  Contact: remind@pik-potsdam.de
*** SOF ./modules/39_CCU/on.gms

*####################### R SECTION START (PHASES) ##############################
$Ifi "%phase%" == "sets" $include "./modules/39_CCU/on/sets.gms"
$Ifi "%phase%" == "declarations" $include "./modules/39_CCU/on/declarations.gms"
$Ifi "%phase%" == "datainput" $include "./modules/39_CCU/on/datainput.gms"
$Ifi "%phase%" == "equations" $include "./modules/39_CCU/on/equations.gms"
$Ifi "%phase%" == "bounds" $include "./modules/39_CCU/on/bounds.gms"
*######################## R SECTION END (PHASES) ###############################

*** EOF ./modules/39_CCU/on.gms
