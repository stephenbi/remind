*** |  (C) 2006-2020 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of REMIND and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  REMIND License Exception, version 1.0 (see LICENSE file).
*** |  Contact: remind@pik-potsdam.de
*** SOF ./modules/21_tax/on/declarations.gms
Parameters
p21_tau_so2_tax(tall,all_regi)               "so2 tax path"

p21_tau_pe2se_tax(tall,all_regi,all_te)      "tax path for primary energy technologies"
p21_tau_pe2se_inconv(tall,all_regi,all_te)   "inconvenience cost path for primary energy technologies"

p21_tau_fe_tax_transport(tall,all_regi,all_enty) "tax path for transport final energy"
p21_tau_fe_sub_transport(tall,all_regi,all_enty) "subsidy path for transport final energy"
p21_tau_fe_tax_bit_st(tall,all_regi,all_in)      "tax path for stationary/buildings_industry final energy"
p21_tau_fe_sub_bit_st(tall,all_regi,all_in)      "subsidy path for stationary/buildings_industry final energy"
pm_tau_fe_tax_ES_st(tall,all_regi,all_esty)     "tax path for pathways III FE to CES via ES"
pm_tau_fe_sub_ES_st(tall,all_regi,all_esty)     "subsidy path for pathways III FE to CES via ES"
p21_tau_pe2se_sub(tall,all_regi,all_te)        "subsidy path for primary energy technologies"
p21_max_fe_sub(tall,all_regi,all_in)           "maximum final energy subsidy levels (in $/Gj) from REMIND version prior to rev. 5429"
p21_max_fe_subEs(tall,all_regi,all_esty)       "maximum final energy subsidy levels (in $/Gj) from REMIND version prior to rev. 5429"
p21_prop_fe_sub(tall,all_regi,all_in)          "subsidy proportional cap to avoid liquids increasing dramatically"
p21_prop_fe_subEs(tall,all_regi,all_esty)      "subsidy proportional cap to avoid liquids increasing dramatically"

p21_tau_fuEx_sub(tall,all_regi,all_enty)      "subsidy path for fuel extraction"

p21_tau_bioenergy_tax(ttot)                  "linearly over time increasing tax on bioenergy emulator price"

p21_taxrevGHG0(ttot,all_regi)                "reference level value of GHG emission tax"
p21_taxrevCO2luc0(ttot,all_regi)             "reference level value of co2luc emission tax"
p21_taxrevCCS0(ttot,all_regi)                "reference level value of CCS tax"
p21_taxrevNetNegEmi0(ttot,all_regi)          "reference level value of net-negative emissions tax"
p21_emiALLco2neg0(ttot,all_regi)             "reference level value of negative CO2 emissions for taxes"
p21_taxrevFEtrans0(ttot,all_regi)            "reference level value of final energy transport tax"
p21_taxrevFEBuildInd0(ttot,all_regi)         "reference level value of final energy buildings and industry tax"
p21_taxrevFE_Es0(ttot,all_regi)              "reference level value of final energy( Pathway III through ES layer) tax revenue"
p21_taxrevResEx0(ttot,all_regi)              "reference level value of resource extraction tax"
p21_taxrevPE2SE0(ttot,all_regi)              "reference level value of pe2se technologies tax"
p21_taxrevXport0(ttot,all_regi)              "reference level value of exports tax"
p21_taxrevSO20(ttot,all_regi)                "reference level value of SO2 tax"
p21_taxrevBio0(ttot,all_regi)                "reference level value of bioenergy tax"
p21_implicitDiscRate0(ttot,all_regi)           "reference level value of implicit tax on energy efficient capital"
p21_taxrevFlex0(ttot,all_regi)                  "reference level value of flexibility tax"


p21_taxrevGHG_iter(iteration,ttot,all_regi)                "reference level value of GHG emission tax revenue"
p21_taxrevCCS_iter(iteration,ttot,all_regi)                "reference level value of CCS tax revenue"
p21_taxrevNetNegEmi_iter(iteration,ttot,all_regi)          "reference level value of net-negative emissions tax revenue"
p21_taxrevFEtrans_iter(iteration,ttot,all_regi)            "reference level value of final energy transport tax revenue"
p21_taxrevFEBuildInd_iter(iteration,ttot,all_regi)         "reference level value of final energy buildings and industry tax revenue"
p21_taxrevFE_Es_iter(iteration,ttot,all_regi)              "reference level value of final energy (Pathway III through ES layer) tax revenue"
p21_taxrevResEx_iter(iteration,ttot,all_regi)              "reference level value of resource extraction tax revenue"
p21_taxrevPE2SE_iter(iteration,ttot,all_regi)              "reference level value of pe2se technologies tax revenue"
p21_taxrevXport_iter(iteration,ttot,all_regi)              "reference level value of exports tax revenue"
p21_taxrevSO2_iter(iteration,ttot,all_regi)                "reference level value of SO2 tax revenue"
p21_taxrevBio_iter(iteration,ttot,all_regi)                "reference level value of bioenergy tax revenue"
p21_implicitDiscRate_iter(iteration,ttot,all_regi)           "reference level value of implicit tax on energy efficient capital"
p21_taxrevFlex_iter(iteration,ttot,all_regi)               "reference level value of flexibility tax revenue"


p21_deltarev(iteration,all_regi)             "convergence criteria for iteration on tax revenue recycling"

p21_tau_CO2_tax_gdx(ttot,all_regi)           "tax path from gdx, may overwrite default values"
p21_tau_CO2_tax_gdx_bau(ttot,all_regi)       "tax path from gdx, may overwrite default values"

p21_implicitDiscRateMarg(ttot,all_regi,all_in)  "Difference between the normal discount rate and the implicit discount rate"

;

Scalars
s21_so2_tax_2010                             "SO2 tax value in 2010 in 10^12$/TgS = 10^6 $/t S"
s21_tax_time                                 "time when final tax level is reached"
s21_tax_value                                "target level of tax, sub, inconv in $/GJ, must always be rescaled after setting"
;

variables
v21_tau_bio(ttot)                            "demand-dependent bioenergy tax"
v21_taxrevGHG(ttot,all_regi)                 "tax on greenhouse gas emissions"
v21_taxrevCO2luc(ttot,all_regi)              "tax on co2luc emissions"
v21_taxrevCCS(ttot,all_regi)                 "tax on CCS (to reflect leakage risk)"
v21_taxrevNetNegEmi(ttot,all_regi)           "tax on net-negative emissions (to reflect climate damages due to overshoot)"
v21_taxrevFEtrans(ttot,all_regi)             "tax on final energy transport (?)"
v21_taxrevFEBuildInd(ttot,all_regi)          "tax on final energy buildings and industry (to reflect the different final energy taxes/subsidies in industry and buildings)"
v21_taxrevFE_Es(ttot,all_regi)               "tax on final energy going through ES layer - Pathway III"
v21_taxrevResEx(ttot,all_regi)               "tax on resource extraction (?)"
v21_taxrevPE2SE(ttot,all_regi)               "tax on pe2se technologies (?)"
v21_taxrevXport(ttot,all_regi)               "tax on exports (?)"
v21_taxrevSO2(ttot,all_regi)                 "tax on SO2 (to reflect health impacts)"
v21_taxrevBio(ttot,all_regi)                 "tax on bioenergy (to reflect sustainability constraints on bioenergy production)"
v21_taxrevFlex(ttot,all_regi)                "tax on technologies with flexible or inflexible electricity input"
v21_implicitDiscRate(ttot,all_regi)           "implicit tax on energy efficient capital"
;

Positive Variable
v21_emiALLco2neg(ttot,all_regi)             "negative part of total CO2 emissions"
v21_emiALLco2neg_slack(ttot,all_regi)       "dummy variable to extract negatice CO2 emissions from emiAll"
;
equations 
q21_taxrev(ttot,all_regi)                    "calculation of difference in tax volume"
q21_emiAllco2neg(ttot,all_regi)              "calculates negative part of CO2 emissions"
q21_tau_bio(ttot)                            "calculation of demand-dependent bioenergy tax"
q21_taxrevGHG(ttot,all_regi)                 "calculation of tax on greenhouse gas emissions"
q21_taxrevCO2luc(ttot,all_regi)              "calculation of tax on co2luc emissions"
q21_taxrevCCS(ttot,all_regi)                 "calculation of tax on CCS"
q21_taxrevNetNegEmi(ttot,all_regi)           "calculation of tax on net-negative emissions"
q21_taxrevFEtrans(ttot,all_regi)             "calculation of tax on final energy transport"
q21_taxrevFEBuildInd(ttot,all_regi)          "calculation of tax on final energy buildings and industry - Pathway I"
q21_taxrevFE_Es(ttot,all_regi)               "calculation of tax on final energy going through ES layer - Pathway III"
q21_taxrevResEx(ttot,all_regi)               "calculation of tax on resource extraction"
q21_taxrevPE2SE(ttot,all_regi)               "calculation of tax on pe2se technologies"
q21_taxrevXport(ttot,all_regi)               "calculation of tax on exports"
q21_taxrevSO2(ttot,all_regi)                 "calculation of tax on SO2"
q21_taxrevBio(ttot,all_regi)                 "calculation of tax on bioenergy"
q21_taxrevFlex(ttot,all_regi)                "tax on technologies with flexible or inflexible electricity input"
q21_implicitDiscRate(ttot,all_regi)           "calculation of the implicit discount rate on energy efficiency capital"
;   

*** EOF ./modules/21_tax/on/declarations.gms
