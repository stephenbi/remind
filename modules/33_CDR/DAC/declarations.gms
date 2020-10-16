*** |  (C) 2006-2020 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of REMIND and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  REMIND License Exception, version 1.0 (see LICENSE file).
*** |  Contact: remind@pik-potsdam.de
*** SOF ./modules/33_CDR/DAC/declarations.gms
parameters
*JeS* GJ/tCO2 = EJ/Gt CO2 = 44/12 EJ/Gt C. Numbers from Report from Micah Broehm.
p33_dac_fedem(all_enty)           "specific heat and electricity demand for direct air capture [EJ per Gt of C captured]"
;

variables
vm_ccs_cdr(ttot,all_regi,all_enty,all_enty,all_te,rlf)  "CCS emissions from CDR [GtC / a]"
v33_emiDAC(ttot,all_regi)       "negative CO2 emission from DAC [GtC / a]"
v33_emiEW(ttot,all_regi)        "negative CO2 emission from EW [GtC / a] - fixed to 0, only defined for reporting reasons"
;

positive variables
v33_grindrock_onfield(ttot,all_regi,rlf,rlf)         "amount of ground rock spread on fields in each timestep [Gt]"
v33_grindrock_onfield_tot(ttot,all_regi,rlf,rlf)     "total amount of ground rock on fields [Gt]"
;

equations
q33_otherFEdemand(ttot,all_regi,all_enty)             "calculates final energy demand from no transformation technologies (e.g. enhanced weathering)"
q33_capconst_dac(ttot,all_regi)                     "calculates amount of carbon captured"
q33_ccsbal(ttot,all_regi,all_enty,all_enty,all_te)  "calculates CCS emissions from CDR technologies"
q33_H2bio_lim(ttot,all_regi,all_te)                 "limits H2 from bioenergy to FE - otherFEdemand, i.e. no H2 from bioenergy for DAC"
q33_emicdrregi(ttot,all_regi)                       "calculates the (negative) emissions due to CDR technologies"
;

*** EOF ./modules/33_CDR/DAC/declarations.gms
