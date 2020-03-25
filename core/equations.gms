*** |  (C) 2006-2019 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of REMIND and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  REMIND License Exception, version 1.0 (see LICENSE file).
*** |  Contact: remind@pik-potsdam.de
*** SOF ./core/equations.gms
***---------------------------------------------------------------------------
***---------------------------------------------------------------------------
***---------------------------------------------------------------------------
*** DEFINITION OF MODEL EQUATIONS:
***---------------------------------------------------------------------------
***---------------------------------------------------------------------------

***---------------------------------------------------------------------------
*' Fuel costs are associated with the use of exhaustible primary energy (fossils, uranium) and biomass.
***---------------------------------------------------------------------------
q_costFu(t,regi)..
  v_costFu(t,regi)
  =e=
  vm_costFuBio(t,regi) + sum(peEx(enty), vm_costFuEx(t,regi,enty))
;

***---------------------------------------------------------------------------
*' Specific investment costs of learning technologies are a model-endogenous variable; 
*' those of non-learning technologies are fixed to constant values. 
*' Total investment costs are the product of specific costs and capacity additions plus adjustment costs.
***---------------------------------------------------------------------------
q_costInv(t,regi)..
  v_costInv(t,regi)
  =e=
  sum(en2en(enty,enty2,te),
    v_costInvTeDir(t,regi,te) + v_costInvTeAdj(t,regi,te)$teAdj(te)
  )
  +
  sum(teNoTransform,
    v_costInvTeDir(t,regi,teNoTransform) + v_costInvTeAdj(t,regi,teNoTransform)$teAdj(teNoTransform)
  )
;

*RP* 2010-05-10 adjustment costs
q_costInvTeDir(t,regi,te)..
  v_costInvTeDir(t,regi,te)
  =e=
  vm_costTeCapital(t,regi,te) * sum(te2rlf(te,rlf), vm_deltaCap(t,regi,te,rlf) )
;
*RP* 2011-12-01 remove global adjustment costs to decrease runtime, only keep regional adjustment costs. Maybe change in the future.
v_adjFactorGlob.fx(t,regi,te) = 0;

q_costInvTeAdj(t,regi,teAdj)..
  v_costInvTeAdj(t,regi,teAdj)
  =e=
  vm_costTeCapital(t,regi,teAdj) * ( (p_adj_coeff(t,regi,teAdj) * v_adjFactor(t,regi,teAdj)) + (p_adj_coeff_glob(teAdj) * v_adjFactorGlob(t,regi,teAdj) ) )
;

***---------------------------------------------------------------------------
*' Operation and maintenance resut form costs maintenance of existing facilities according to their capacity and
*' operation of energy transformations according to the amount of produced secondary and final energy.
***---------------------------------------------------------------------------
q_costOM(t,regi)..
  v_costOM(t,regi)
  =e=
  sum(en2en(enty,enty2,te),
    pm_data(regi,"omf",te) 
    * sum(te2rlf(te,rlf), vm_costTeCapital(t,regi,te) * vm_cap(t,regi,te,rlf) )
    +
    pm_data(regi,"omv",te)
      * (vm_prodSe(t,regi,enty,enty2,te)$entySe(enty2)
         + vm_prodFe(t,regi,enty,enty2,te)$entyFe(enty2))
  )
  +
  sum(teNoTransform(te),
     pm_data(regi,"omf",te)
          * sum(te2rlf(te,rlf),
             vm_costTeCapital(t,regi,te) * vm_cap(t,regi,te,rlf)
            )
  )
  + vm_omcosts_cdr(t,regi)
;

***---------------------------------------------------------------------------
*' Energy balance equations equate the production of and demand for each primary, secondary and final energy.
*' The balance equation for primary energy equals supply of primary energy demand on primary energy.
***---------------------------------------------------------------------------
q_balPe(t,regi,entyPe(enty))..
         vm_prodPe(t,regi,enty) + p_macPE(t,regi,enty)
         =e=
         sum(pe2se(enty,enty2,te), vm_demPe(t,regi,enty,enty2,te))
*** through p_datacs one could correct for non-energetic use, e.g. bitumen for roads; set to 0 in current version, as the total oil value already contains the non-energy use part
         + p_datacs(regi,enty) / 0.95 
;


***---------------------------------------------------------------------------
*' The secondary energy balance comprises the following terms (except power, defined on module):
*' 1. Secondary energy can be produced from primary or (another type of) secondary energy.
*' 2. Own consumption of secondary energy occurs from the production of secondary and final energy, and from CCS technologies. 
*'Own consumption is calculated as the product of the respective production and a negative coefficient. 
*'The mapping defines possible combinations: the first two enty types of the mapping define the underlying
*'transformation process, the 3rd argument the technology, and the 4th argument specifies the consumed energy type.
*' 3. Couple production is modeled as own consumption, but with a positive coefficient.
*' 4. Secondary energy can be demanded to produce final or (another type of) secondary energy.
***---------------------------------------------------------------------------
q_balSe(t,regi,enty2)$( entySE(enty2) AND (NOT (sameas(enty2,"seel"))) )..
    sum(pe2se(enty,enty2,te), vm_prodSe(t,regi,enty,enty2,te))
  + sum(se2se(enty,enty2,te), vm_prodSe(t,regi,enty,enty2,te))
  + sum(pc2te(enty,entySE(enty3),te,enty2), 
      pm_prodCouple(regi,enty,enty3,te,enty2) 
    * vm_prodSe(t,regi,enty,enty3,te)
         )
  + sum(pc2te(enty4,entyFE(enty5),te,enty2), 
      pm_prodCouple(regi,enty4,enty5,te,enty2) 
    * vm_prodFe(t,regi,enty4,enty5,te)
    )
  + sum(pc2te(enty,enty3,te,enty2),
                sum(teCCS2rlf(te,rlf),
        pm_prodCouple(regi,enty,enty3,te,enty2) 
      * vm_co2CCS(t,regi,enty,enty3,te,rlf)
                )
         )
***   add (reused gas from waste landfills) to segas to not account for CO2 
***   emissions - it comes from biomass
  + ( sm_MtCH4_2_TWa
    * ( vm_macBase(t,regi,"ch4wstl")
      - vm_emiMacSector(t,regi,"ch4wstl")
      )
    )$( sameas(enty2,"segabio") AND t.val gt 2005 )
  + sum(prodSeOth2te(enty2,te), vm_prodSeOth(t,regi,enty2,te) ) 
  =e=
    sum(se2fe(enty2,enty3,te), vm_demSe(t,regi,enty2,enty3,te))
  + sum(se2se(enty2,enty3,te), vm_demSe(t,regi,enty2,enty3,te))
  + sum(demSeOth2te(enty2,te), vm_demSeOth(t,regi,enty2,te) )  
;

***---------------------------------------------------------------------------
*' Taking the technology-specific transformation eficiency into account, 
*' the equations describe the transformation of an energy type to another type.
*' Depending on the detail of the technology representation, the transformation technology's eficiency
*' can depend either only on the current year or on the year when a specific technology was built.
*' Transformation from primary to secondary energy: 
***---------------------------------------------------------------------------
*MLB 05/2008* correction factor included to avoid pre-triangular infeasibility
q_transPe2se(ttot,regi,pe2se(enty,enty2,te))$(ttot.val ge cm_startyear)..
         vm_demPe(ttot,regi,enty,enty2,te)
         =e=
         (1 / pm_eta_conv(ttot,regi,te) * vm_prodSe(ttot,regi,enty,enty2,te))$teEtaConst(te)
         +
***cb early retirement for some fossil technologies
        (1 - vm_capEarlyReti(ttot,regi,te))
        *

		sum(teSe2rlf(teEtaIncr(te),rlf),
                vm_capFac(ttot,regi,te)
             * (
                 sum(opTimeYr2te(te,opTimeYr)$(tsu2opTimeYr(ttot,opTimeYr) AND (opTimeYr.val gt 1) ),
                        pm_ts(ttot-(pm_tsu2opTimeYr(ttot,opTimeYr)-1)) 
                      / pm_dataeta(ttot-(pm_tsu2opTimeYr(ttot,opTimeYr)-1),regi,te) 
                      * pm_omeg(regi,opTimeYr+1,te)
                                * vm_deltaCap(ttot-(pm_tsu2opTimeYr(ttot,opTimeYr)-1),regi,te,rlf)
                      )
*LB* add half of the last time step ttot
               +  pm_dt(ttot)/2 / pm_dataeta(ttot,regi,te)
                * pm_omeg(regi,"2",te)
                * vm_deltaCap(ttot,regi,te,rlf)   
$ifthen setglobal END2110
                      - (pm_ts(ttot) / pm_dataeta(ttot,regi,te) * pm_omeg(regi,"11",te)
                   * 0.5*vm_deltaCap(ttot,regi,te,rlf))$(ord(ttot) eq card(ttot))
$endif
                                )
                        );

***---------------------------------------------------------------------------
*' Transformation from secondary to final energy:
***---------------------------------------------------------------------------
q_transSe2fe(t,regi,se2fe(entySE,entyFE,te)) .. 
    pm_eta_conv(t,regi,te)
  * vm_demSE(t,regi,entySE,entyFE,te)
  =e=
  vm_prodFE(t,regi,entySE,entyFE,te) 
;


***---------------------------------------------------------------------------
*' Transformation between secondary energy types:
***---------------------------------------------------------------------------
q_transSe2se(t,regi,se2se(enty,enty2,te))..
         pm_eta_conv(t,regi,te) * vm_demSe(t,regi,enty,enty2,te)
         =e=
         vm_prodSe(t,regi,enty,enty2,te);


***---------------------------------------------------------------------------
*' Final energy pathway I: Direct hand-over of FEs to CES.
***---------------------------------------------------------------------------

*MLB 5/2008* add correction for initial imbalance of fehes
qm_balFeForCesAndEs(t,regi,entyFe)$(feForCes(entyFe) OR feForEs(entyFe)) ..
  sum(se2fe(entySe,entyFe,te), vm_prodFE(t,regi,entySe,entyFe,te))
  =e=
***   FE Pathway I: Direct hand-over of FEs to CES
  sum(fe2ppfEn(entyFe,ppfEn), 
    vm_cesIO(t,regi,ppfEn)
  + pm_cesdata(t,regi,ppfEn,"offset_quantity") 
  ) 
***   FE Pathway III: Energy service layer (prodFe -> demFeForEs -> prodEs)
  +  sum(fe2es(entyFe,esty,teEs), vm_demFeForEs(t,regi,entyFe,esty,teEs) )
***   Other demand which is not Pathway II
  + vm_otherFEdemand(t,regi,entyFe)
;

***---------------------------------------------------------------------------
*' Final energy pathway II: Useful energy layer (prodFe -> demFe -> prodUe), with capacaity tracking.
***---------------------------------------------------------------------------

*' Final energy balance
q_balFe(t,regi,entyFe)$feForUe(entyFe)..
    sum(se2fe(enty,entyFe,te), vm_prodFe(t,regi,enty,entyFe,te) )
***   couple production from FE to ES for heavy duty vehicles
    + sum(pc2te(entyFE2,entyUe,te,entyFE),                        
        pm_prodCouple(regi,entyFE2,entyUe,te,entyFE) * vm_prodUe(t,regi,entyFE2,entyUe,te) )
    =e=
    sum(fe2ue(entyFe,entyUe,te), v_demFe(t,regi,entyFe,entyUe,te) )
    + vm_otherFEdemand(t,regi,entyFe)
;

*' Transformation from final energy to useful energy:
q_transFe2Ue(t,regi,fe2ue(entyFe,entyUe,te))..
    pm_eta_conv(t,regi,te) * v_demFe(t,regi,entyFe,entyUe,te)
    =e=
    vm_prodUe(t,regi,entyFe,entyUe,te);

*' Hand-over to CES:
q_esm2macro(t,regi,in)$ppfenFromUe(in)..
    vm_cesIO(t,regi,in) + pm_cesdata(t,regi,in,"offset_quantity")
    =e=
***   all entyFe that are first transformed into entyUe and then fed into the CES production function
    sum(fe2ue(entyFe,entyUe,te)$ue2ppfen(entyUe,in), vm_prodUe(t,regi,entyFe,entyUe,te))  
;

*' Definition of capacity constraints for FE to ES transformation:
q_limitCapUe(t,regi,fe2ue(entyFe,entyUe,te))..
    vm_prodUe(t,regi,entyFe,entyUe,te)
    =l=
    sum(teue2rlf(te,rlf),
        vm_capFac(t,regi,te) * vm_cap(t,regi,te,rlf)
    )
;

***---------------------------------------------------------------------------
*' FE Pathway III: Energy service layer (prodFe -> demFeForEs -> prodEs), no capacity tracking.
***---------------------------------------------------------------------------

*' Transformation from final energy to useful energy:
q_transFe2Es(t,regi,fe2es(entyFe,esty,teEs))..
    pm_fe2es(t,regi,teEs) * vm_demFeForEs(t,regi,entyFe,esty,teEs)
    =e=
    v_prodEs(t,regi,entyFe,esty,teEs);

*' Hand-over to CES:
q_es2ppfen(t,regi,in)$ppfenFromEs(in)..
    vm_cesIO(t,regi,in) + pm_cesdata(t,regi,in,"offset_quantity")
    =e=
    sum(fe2es(entyFe,esty,teEs)$es2ppfen(esty,in), v_prodEs(t,regi,entyFe,esty,teEs))
;

*' Shares of FE carriers w.r.t. a CES node:
q_shFeCes(t,regi,entyFe,in,teEs)$feViaEs2ppfen(entyFe,in,teEs)..
    sum(fe2es(entyFe2,esty,teEs2)$es2ppfen(esty,in), vm_demFeForEs(t,regi,entyFe2,esty,teEs2))
    * pm_shFeCes(t,regi,entyFe,in,teEs)
    =e=
    sum(fe2es(entyFe,esty,teEs)$es2ppfen(esty,in), vm_demFeForEs(t,regi,entyFe,esty,teEs))
;

***---------------------------------------------------------------------------
*' Definition of capacity constraints for primary energy to secondary energy transformation:
***--------------------------------------------------------------------------
q_limitCapSe(t,regi,pe2se(enty,enty2,te))..
        vm_prodSe(t,regi,enty,enty2,te)
        =e=
        sum(teSe2rlf(te,rlf),
               vm_capFac(t,regi,te) * pm_dataren(regi,"nur",rlf,te)
               * vm_cap(t,regi,te,rlf)
        )$(NOT teReNoBio(te))
    +
        sum(teRe2rlfDetail(te,rlf),
               ( 1$teRLDCDisp(te) +  pm_dataren(regi,"nur",rlf,te)$(NOT teRLDCDisp(te)) ) * vm_capFac(t,regi,te)  
               * vm_capDistr(t,regi,te,rlf)
        )$(teReNoBio(te)) 
;

***----------------------------------------------------------------------------
*' Definition of capacity constraints for secondary energy to secondary energy transformation:
***---------------------------------------------------------------------------
q_limitCapSe2se(t,regi,se2se(enty,enty2,te))..
         vm_prodSe(t,regi,enty,enty2,te)
         =e=
         sum(teSe2rlf(te,rlf),
                vm_capFac(t,regi,te) * pm_dataren(regi,"nur",rlf,te)
                * vm_cap(t,regi,te,rlf)
         );

***---------------------------------------------------------------------------
*' Definition of capacity constraints for secondary energy to final energy transformation:
***---------------------------------------------------------------------------
q_limitCapFe(t,regi,te)..
         sum((entySe,entyFe)$(se2fe(entySe,entyFe,te)), vm_prodFe(t,regi,entySe,entyFe,te))
         =l=
         sum(teFe2rlf(te,rlf), vm_capFac(t,regi,te) * vm_cap(t,regi,te,rlf));

***---------------------------------------------------------------------------
*' Definition of capacity constraints for CCS technologies:
***---------------------------------------------------------------------------
q_limitCapCCS(t,regi,ccs2te(enty,enty2,te),rlf)$teCCS2rlf(te,rlf)..
         vm_co2CCS(t,regi,enty,enty2,te,rlf)
         =e=
         sum(teCCS2rlf(te,rlf), vm_capFac(t,regi,te) * vm_cap(t,regi,te,rlf));

***-----------------------------------------------------------------------------
*' The capacities of vintaged technologies depreciate according to a vintage depreciation scheme, 
*' with generally low depreciation at the beginning of the lifetime, and fast depreciation around the average lifetime. 
*' Depreciation can generally be tracked for each grade separately. 
*' By implementation, however, only grades of level 1 are affected. The depreciation of any fossil
*' technology can be accelerated by early retirement, which is a crucial way to quickly phase out emissions 
*' after the implementation of stringent climate policies.
*' Calculation of actual capacities (exponential and vintage growth TE):
***-----------------------------------------------------------------------------
q_cap(ttot,regi,te2rlf(te,rlf))$(ttot.val ge cm_startyear)..
         vm_cap(ttot,regi,te,rlf)
         =e=
***cb early retirement for some fossil technologies
        (1 - vm_capEarlyReti(ttot,regi,te))
        *

        (sum(opTimeYr2te(te,opTimeYr)$(tsu2opTimeYr(ttot,opTimeYr) AND (opTimeYr.val gt 1) ),
                  pm_ts(ttot-(pm_tsu2opTimeYr(ttot,opTimeYr)-1)) 
                * pm_omeg(regi,opTimeYr+1,te)
                * vm_deltaCap(ttot-(pm_tsu2opTimeYr(ttot,opTimeYr)-1),regi,te,rlf)
            )
*LB* half of the last time step ttot
        +  pm_dt(ttot)/2 
         * pm_omeg(regi,"2",te)
         * vm_deltaCap(ttot,regi,te,rlf)
$ifthen setGlobal END2110
             - (pm_ts(ttot)* pm_omeg(regi,"11",te)
                  * 0.5 * vm_deltaCap(ttot,regi,te,rlf))$(ord(ttot) eq card(ttot))
$endif
        );

q_capDistr(t,regi,teReNoBio(te))..
    sum(teRe2rlfDetail(te,rlf), vm_capDistr(t,regi,te,rlf) )
    =e=
    vm_cap(t,regi,te,"1")
;

***---------------------------------------------------------------------------
*' Technological change is an important driver of the evolution of energy systems.
*' For mature technologies, such as coal-fired power plants, the evolution
*' of techno-economic parameters is prescribed exogenously. For less mature
*' technologies with substantial potential for cost decreases via learning-bydoing,
*' investment costs are determined via an endogenous one-factor learning
*' curve approach that assumes floor costs.
***---------------------------------------------------------------------------
***---------------------------------------------------------------------------
*' Calculation of cumulated capacities (learning technologies only):
***---------------------------------------------------------------------------
qm_deltaCapCumNet(ttot,regi,teLearn)$(ord(ttot) lt card(ttot) AND pm_ttot_val(ttot+1) ge max(2010, cm_startyear))..
  vm_capCum(ttot+1,regi,teLearn)
  =e=
  sum(te2rlf(teLearn,rlf),
         (pm_ts(ttot) / 2 * vm_deltaCap(ttot,regi,teLearn,rlf)) + (pm_ts(ttot+1) / 2 * vm_deltaCap(ttot+1,regi,teLearn,rlf))
  )
  +
  vm_capCum(ttot,regi,teLearn);

***---------------------------------------------------------------------------
*' Initial values for cumulated capacities (learning technologies only):
***---------------------------------------------------------------------------
q_capCumNet(t0,regi,teLearn)..
  vm_capCum(t0,regi,teLearn)
  =e=
  pm_data(regi,"ccap0",teLearn);

***---------------------------------------------------------------------------
*' Additional equation for fuel shadow price calulation:
***---------------------------------------------------------------------------
*ml* reasonable results only for members of peExGrade and peren2rlf30
*NB*110625 changes for transition towards grades
qm_fuel2pe(t,regi,peRicardian(enty))..
  vm_prodPe(t,regi,enty)
  =e=
  sum(pe2rlf(enty,rlf2),vm_fuExtr(t,regi,enty,rlf2))-(vm_Xport(t,regi,enty)-(1-pm_costsPEtradeMp(regi,enty))*vm_Mport(t,regi,enty))$(tradePe(enty)) -
                      sum(pe2rlf(enty2,rlf2), (pm_fuExtrOwnCons(regi, enty, enty2) * vm_fuExtr(t,regi,enty2,rlf2))$(pm_fuExtrOwnCons(regi, enty, enty2) gt 0));

***---------------------------------------------------------------------------
*' Definition of resource constraints for renewable energy types:
***---------------------------------------------------------------------------
*ml* assuming maxprod to be technical potential
q_limitProd(t,regi,teRe2rlfDetail(teReNoBio(te),rlf))..
  pm_dataren(regi,"maxprod",rlf,te)
  =g=
  ( 1$teRLDCDisp(te) +  pm_dataren(regi,"nur",rlf,te)$(NOT teRLDCDisp(te)) ) * vm_capFac(t,regi,te) * vm_capDistr(t,regi,te,rlf);
  
***-----------------------------------------------------------------------------
*' Definition of competition for geographical potential for renewable energy types:
***-----------------------------------------------------------------------------
*RP* assuming q_limitGeopot to be geographical potential, whith luse equivalent to the land use parameter
q_limitGeopot(t,regi,peReComp(enty),rlf)..
  p_datapot(regi,"limitGeopot",rlf,enty)
  =g=
  sum(te$teReComp2pe(enty,te,rlf), (vm_capDistr(t,regi,te,rlf) / (pm_data(regi,"luse",te)/1000)));

***  learning curve for investment costs
q_costTeCapital(t,regi,teLearn) .. 
  vm_costTeCapital(t,regi,teLearn)
  =e=
***  special treatment for first time steps: using global estimates better
***  matches historic values
    ( fm_dataglob("learnMult_wFC",teLearn) 
    * ( ( sum(regi2, vm_capCum(t,regi2,teLearn)) 
          + pm_capCumForeign(t,regi,teLearn)
        )
        ** fm_dataglob("learnExp_wFC",teLearn)
      )
    )$( t.val le 2005 )
***  special treatment for 2010, 2015: start divergence of regional values by using a
***  t-split of global 2005 to regional 2020 in order to phase-in the observed 2020 regional 
***  variation from input-data
  + ( (2020 - t.val)/15 * fm_dataglob("learnMult_wFC",teLearn) 
      * ( sum(regi2, vm_capCum(t,regi2,teLearn)) 
        + pm_capCumForeign(t,regi,teLearn)
        )
        ** fm_dataglob("learnExp_wFC",teLearn)
  	  
    + (t.val - 2005)/15 * pm_data(regi,"learnMult_wFC",teLearn)
      * ( sum(regi2, vm_capCum(t,regi2,teLearn)) 
        + pm_capCumForeign(t,regi,teLearn)
        )
  	  ** pm_data(regi,"learnExp_wFC",teLearn) 
    )$( (t.val gt 2005) AND (t.val lt 2020) )
  
***  assuming linear convergence of regional learning curves to global values until 2050
  + ( (pm_ttot_val(t) - 2020) / 30 * fm_dataglob("learnMult_wFC",teLearn) 
    * ( sum(regi2, vm_capCum(t,regi2,teLearn)) 
      + pm_capCumForeign(t,regi,teLearn)
      )
      ** fm_dataglob("learnExp_wFC",teLearn)
	  
    + (2050 - pm_ttot_val(t)) / 30 * pm_data(regi,"learnMult_wFC",teLearn)
    * ( sum(regi2, vm_capCum(t,regi2,teLearn)) 
      + pm_capCumForeign(t,regi,teLearn)
      )
	  ** pm_data(regi,"learnExp_wFC",teLearn) 
    )$( t.val ge 2020 AND t.val le 2050 )
	
*** globally harmonized costs after 2050
  + ( fm_dataglob("learnMult_wFC",teLearn) 
     * (sum(regi2, vm_capCum(t,regi2,teLearn)) + pm_capCumForeign(t,regi,teLearn) )
       **(fm_dataglob("learnExp_wFC",teLearn))
	)$(t.val gt 2050)
	
***  floor costs - calculated such that they coincide for all regions   
  + pm_data(regi,"floorcost",teLearn)
;


***---------------------------------------------------------------------------
*' EMF27 limits on fluctuating renewables, only turned on for special EMF27 and AWP 2 scenarios, not for SSP
***---------------------------------------------------------------------------
*** this is to prevent that in the long term, all solids are supplied by biomass. Residential solids can be fully supplied by biomass (-> wood pellets), so the FE residential demand is subtracted
*** vm_cesIO(t,regi,"fesob") will be 0 in the stationary realization
q_limitBiotrmod(t,regi)$(t.val > 2020).. 
    vm_prodSe(t,regi,"pebiolc","sesobio","biotrmod") 
   - sum (in$sameAs("fesob",in), vm_cesIO(t,regi,in)) 
   - sum (fe2es(entyFe,esty,teEs)$buildMoBio(esty), vm_demFeForEs(t,regi,entyFe,esty,teEs) )
    =l=
    (2 +  max(0,min(1,( 2100 - pm_ttot_val(t)) / ( 2100 - 2020 ))) * 3) !! 5 in 2020 and 2 in 2100
    * vm_prodSe(t,regi,"pecoal","sesofos","coaltr") 
;

***-----------------------------------------------------------------------------
*' Emissions result from primary to secondary energy transformation,
*' from secondary to final energy transformation (some air pollutants), or
*' transformations within the chain of CCS steps (Leakage).
***-----------------------------------------------------------------------------
q_emiTeDetail(t,regi,enty,enty2,te,enty3)$(   emi2te(enty,enty2,te,enty3)
                                           OR (    pe2se(enty,enty2,te) 
                                               AND sameas(enty3,"cco2")) ) ..
  vm_emiTeDetail(t,regi,enty,enty2,te,enty3)
  =e=
    sum(emi2te(enty,enty2,te,enty3),
      sum(pe2se(enty,enty2,te),
        pm_emifac(t,regi,enty,enty2,te,enty3)
      * vm_demPE(t,regi,enty,enty2,te)
      )
    + sum(se2fe(enty,enty2,te),
        pm_emifac(t,regi,enty,enty2,te,enty3)
      * vm_prodFE(t,regi,enty,enty2,te)
      )
    + sum((ccs2Leak(enty,enty2,te,enty3),teCCS2rlf(te,rlf)),
        pm_emifac(t,regi,enty,enty2,te,enty3)
      * vm_co2CCS(t,regi,enty,enty2,te,rlf)
      )
    )
;

***--------------------------------------------------
*' Total energy-emissions:
***--------------------------------------------------
*mh calculate total energy system emissions for each region and timestep:
q_emiTe(t,regi,emiTe(enty)) .. 
  vm_emiTe(t,regi,enty)
  =e=
    !! emissions from fuel combustion
    sum(emi2te(enty2,enty3,te,enty),     
      vm_emiTeDetail(t,regi,enty2,enty3,te,enty)
    )
    !! emissions from non-conventional fuel extraction
  + sum(emi2fuelMine(enty,enty2,rlf),       
      p_cint(regi,enty,enty2,rlf)
    * vm_fuExtr(t,regi,enty2,rlf)
    )$( c_cint_scen eq 1 )
    !! emissions from conventional fuel extraction
  + sum((pe2rlf(enty3,rlf2),enty2)$( pm_fuExtrOwnCons(regi,enty,enty2) gt 0 ),
      p_cintraw(enty2)
    * pm_fuExtrOwnCons(regi,enty2,enty3) 
    * vm_fuExtr(t,regi,enty3,rlf2)
    )
    !! Industry CCS emissions
  - sum(emiMac2mac(emiInd37_fuel,enty2),
      vm_emiIndCCS(t,regi,emiInd37_fuel)
    )$( sameas(enty,"co2") )
    !! Valve from cco2 capture step, to mangage if capture capacity and CCU/CCS 
    !! capacity don't have the same lifetime
  + v_co2capturevalve(t,regi)$( sameas(enty,"co2") )
    !! CO2 from short-term CCU
  + sum(teCCU2rlf(te2,rlf), 
      vm_co2CCUshort(t,regi,"cco2","ccuco2short",te2,rlf)
    )
;

***------------------------------------------------------
*' Mitigation options that are independent of energy consumption are represented
*' using marginal abatement cost (MAC) curves, which describe the
*' percentage of abated emissions as a function of the costs. 
*' Baseline emissions are obtained by three different methods: by source (via emission factors),
*' by econometric estimate, and exogenous. Emissions are calculated as
*' baseline emissions times (1 - relative emission reduction). 
*' In case of CO2 from landuse (co2luc), emissions can be negative. 
*' To treat these emissions in the same framework, we subtract the minimal emission level from
*' baseline emissions. This shift factor is then added again when calculating total emissions.
*' The ndogenous baselines of non-energy emissions are calculated in the following equation:
***------------------------------------------------------
q_macBase(t,regi,enty)$( emiFuEx(enty) OR sameas(enty,"n2ofertin") ) ..
  vm_macBase(t,regi,enty)
  =e=
    sum(emi2fuel(enty2,enty), 
      p_efFossilFuelExtr(regi,enty2,enty) 
    * sum(pe2rlf(enty2,rlf), vm_fuExtr(t,regi,enty2,rlf))
    )$( emiFuEx(enty) )
  + ( p_macBaseMagpie(t,regi,enty) 
    + p_efFossilFuelExtr(regi,"pebiolc","n2obio") 
    * vm_fuExtr(t,regi,"pebiolc","1")
    )$( sameas(enty,"n2ofertin") )
;

***------------------------------------------------------
*' Total non-energy emissions:
***------------------------------------------------------
q_emiMacSector(t,regi,emiMacSector(enty))..
  vm_emiMacSector(t,regi,enty)
  =e=

    ( vm_macBase(t,regi,enty)
    * sum(emiMac2mac(enty,enty2),
        1 - (pm_macSwitch(enty) * pm_macAbatLev(t,regi,enty2))
      )
    )$( NOT sameas(enty,"co2cement_process") )
***   cement process emissions are accounted for in the industry module
  + ( vm_macBaseInd(t,regi,enty,"cement")
    - vm_emiIndCCS(t,regi,enty)
    )$( sameas(enty,"co2cement_process") )

   + p_macPolCO2luc(t,regi)$( sameas(enty,"co2luc") )
;

q_emiMac(t,regi,emiMac) .. 
  vm_emiMac(t,regi,emiMac)
  =e=
  sum(emiMacSector2emiMac(emiMacSector,emiMac),
    vm_emiMacSector(t,regi,emiMacSector)
  )
;

***------------------------------------------------------
*' Total regional emissions are the sum of emissions from technologies, MAC-curves, CDR-technologies and emissions that are exogenously given for REMIND.
***------------------------------------------------------
*LB* calculate total emissions for each region at each time step
q_emiAll(t,regi,emi(enty)).. 
  vm_emiAll(t,regi,enty) 
  =e= 
    vm_emiTe(t,regi,enty) 
  + vm_emiMac(t,regi,enty) 
  + vm_emiCdr(t,regi,enty) 
  + pm_emiExog(t,regi,enty)
;

***------------------------------------------------------
*' Total global emissions are calculated for each GHG emission type and links the energy system to the climate module.
***------------------------------------------------------
*LB* calculate total global emissions for each timestep - link to the climate module
q_emiAllGlob(t,emi(enty)).. 
  vm_emiAllGlob(t,enty) 
  =e= 
  sum(regi, 
    vm_emiAll(t,regi,enty) 
  + pm_emissionsForeign(t,regi,enty)
  )
;

***------------------------------------------------------
*' Total regional emissions in CO2 equivalents that are part of the climate policy  are computed based on regional GHG
*' emissions from different sectors(energy system, non-energy system, exogenous, CDR technologies).
***------------------------------------------------------
*mlb 8/2010* extension for multigas accounting/trading 
*cb only "static" equation to be active before cm_startyear, as multigasscen could be different from a scenario to another that is fixed on the first
  q_co2eq(ttot,regi)$(ttot.val ge cm_startyear)..
         vm_co2eq(ttot,regi)
         =e=
           vm_emiAll(ttot,regi,"co2")
         + (s_tgn_2_pgc   * vm_emiAll(ttot,regi,"n2o") + s_tgch4_2_pgc * vm_emiAll(ttot,regi,"ch4")) $(cm_multigasscen eq 2 or cm_multigasscen eq 3)
         - vm_emiMacSector(ttot,regi,"co2luc") $(cm_multigasscen eq 3);

***------------------------------------------------------
*' Total global emissions in CO2 equivalents that are part of the climate policy also take into account foreign emissions. 
***------------------------------------------------------
*mlb 20140108* computation of global emissions (related to cap)
  q_co2eqGlob(t) $(t.val > 2010)..
        vm_co2eqGlob(t) =e= sum(regi, vm_co2eq(t,regi) + pm_co2eqForeign(t,regi)); 

***------------------------------------
*' Linking GHG emissions to tradable emission permits.
***------------------------------------
*mh for each region and time step: emissions + permit trade balance < emission cap
q_emiCap(t,regi) ..
                vm_co2eq(t,regi) + vm_Xport(t,regi,"perm") - vm_Mport(t,regi,"perm")
                + vm_banking(t,regi)
                =l= vm_perm(t,regi);

***-----------------------------------------------------------------
*** Budgets on GHG emissions (single or two subsequent time periods)
***-----------------------------------------------------------------

qm_co2eqCum(regi)..
    v_co2eqCum(regi)
    =e=
    sum(ttot$(ttot.val lt sm_endBudgetCO2eq and ttot.val gt s_t_start),
      pm_ts(ttot)
    * vm_co2eq(ttot,regi)
    )
    + sum(ttot$(ttot.val eq sm_endBudgetCO2eq or ttot.val eq s_t_start),
      pm_ts(ttot)
    / 2
    * vm_co2eq(ttot,regi)
    )
;    

q_budgetCO2eqGlob$(cm_emiscen=6)..
   sum(regi, v_co2eqCum(regi))
   =l=
   sum(regi, pm_budgetCO2eq(regi));


***---------------------------------------------------------------------------
*' Definition of carbon capture :
***---------------------------------------------------------------------------
q_balcapture(t,regi,ccs2te(ccsCO2(enty),enty2,te)) ..
  sum(teCCS2rlf(te,rlf),vm_co2capture(t,regi,enty,enty2,te,rlf))
  =e=
    sum(emi2te(enty3,enty4,te2,enty),
      vm_emiTeDetail(t,regi,enty3,enty4,te2,enty)
    )
  + sum(teCCS2rlf(te,rlf),
      vm_ccs_cdr(t,regi,enty,enty2,te,rlf)
    )
***   CCS from industry
  + sum(emiInd37,
      vm_emiIndCCS(t,regi,emiInd37)
    )
;
***--------------------------------------------------------------------------- 
*' Definition of splitting of captured CO2 to CCS, CCU and a valve (the valve 
*' accounts for different lifetimes of capture, CCS and CCU technologies s.t. 
*' extra capture capacities of CO2 capture can release CO2  directly to the 
*' atmosphere)
***---------------------------------------------------------------------------
q_balCCUvsCCS(t,regi) .. 
  sum(teCCS2rlf(te,rlf), vm_co2capture(t,regi,"cco2","ico2",te,rlf))
  =e=
    sum(teCCS2rlf(te,rlf), vm_co2CCS(t,regi,"cco2","ico2",te,rlf))
  + sum(teCCU2rlf(te,rlf), vm_co2CCUshort(t,regi,"cco2","ccuco2short",te,rlf))
  + v_co2capturevalve(t,regi)
;

***---------------------------------------------------------------------------
*' Definition of the CCS transformation chain:
***---------------------------------------------------------------------------
*** no effect while CCS chain is limited to just one step (ccsinje)   
q_transCCS(t,regi,ccs2te(enty,enty2,te),ccs2te2(enty2,enty3,te2),rlf)$teCCS2rlf(te2,rlf)..    
        (1-pm_emifac(t,regi,enty,enty2,te,"co2")) * vm_co2CCS(t,regi,enty,enty2,te,rlf)
        =e=
        vm_co2CCS(t,regi,enty2,enty3,te2,rlf);

q_limitCCS(regi,ccs2te2(enty,"ico2",te),rlf)$teCCS2rlf(te,rlf)..
        sum(ttot $(ttot.val ge 2005), pm_ts(ttot) * vm_co2CCS(ttot,regi,enty,"ico2",te,rlf))
        =l=
        pm_dataccs(regi,"quan",rlf);

***---------------------------------------------------------------------------
*' Emission constraint on SO2 after 2050:
***---------------------------------------------------------------------------
q_limitSo2(ttot+1,regi) $((pm_ttot_val(ttot+1) ge max(cm_startyear,2055)) AND (cm_emiscen gt 1) AND (ord(ttot) lt card(ttot))) ..
         vm_emiTe(ttot+1,regi,"so2")
         =l=
         vm_emiTe(ttot,regi,"so2");

q_limitCO2(ttot+1,regi) $((pm_ttot_val(ttot+1) ge max(cm_startyear,2055)) AND (ttot.val le 2100) AND (cm_emiscen eq 8)) ..
         vm_emiTe(ttot+1,regi,"co2")
         =l=
         vm_emiTe(ttot,regi,"co2");

q_eqadj(regi,ttot,teAdj(te))$(ttot.val ge max(2010, cm_startyear)) ..
         v_adjFactor(ttot,regi,te)
         =e=
         power(
         (sum(te2rlf(te,rlf),vm_deltaCap(ttot,regi,te,rlf)) - sum(te2rlf(te,rlf),vm_deltaCap(ttot-1,regi,te,rlf)))/(pm_ttot_val(ttot)-pm_ttot_val(ttot-1))
         ,2)
                /( sum(te2rlf(te,rlf),vm_deltaCap(ttot-1,regi,te,rlf)) + p_adj_seed_reg(ttot,regi) * p_adj_seed_te(ttot,regi,te)  
                   + p_adj_deltacapoffset("2010",regi,te)$(ttot.val eq 2010) + p_adj_deltacapoffset("2015",regi,te)$(ttot.val eq 2015)
                  );

***---------------------------------------------------------------------------
*' The use of early retirement is restricted by the following equations:
***---------------------------------------------------------------------------
q_limitCapEarlyReti(ttot,regi,te)$(ttot.val lt 2109 AND pm_ttot_val(ttot+1) ge max(2010, cm_startyear))..
        vm_capEarlyReti(ttot+1,regi,te)
        =g=
        vm_capEarlyReti(ttot,regi,te);

q_smoothphaseoutCapEarlyReti(ttot,regi,te)$(ttot.val lt 2120 AND pm_ttot_val(ttot+1) ge max(2010, cm_startyear))..
        vm_capEarlyReti(ttot+1,regi,te)
        =l=
        vm_capEarlyReti(ttot,regi,te) + (pm_ttot_val(ttot+1)-pm_ttot_val(ttot)) * (cm_earlyreti_rate 
*** more retirement possible for coal power plants in early time steps for Europe and USA, to account for relatively old fleet 
		+ p_earlyreti_adjRate(regi,te)$(ttot.val lt 2035)
*** more retirement possible for first generation biofuels		
		+ 0.05$(sameas(te,"biodiesel") or sameas(te, "bioeths")));



*JK* Result of split of budget equation. Sum of all energy related costs. 
q_costEnergySys(ttot,regi)$( ttot.val ge cm_startyear ) ..
    vm_costEnergySys(ttot,regi)
  =e=
    ( v_costFu(ttot,regi) 
    + v_costOM(ttot,regi) 
    + v_costInv(ttot,regi)
    ) 
  + sum(emiInd37, vm_IndCCSCost(ttot,regi,emiInd37))
  + pm_CementDemandReductionCost(ttot,regi)
;


***---------------------------------------------------------------------------
*' Investment equation for end-use capital investments (energy service layer):
***---------------------------------------------------------------------------
q_esCapInv(ttot,regi,teEs)$pm_esCapCost(ttot,regi,teEs) ..
    vm_esCapInv(ttot,regi,teEs)
    =e=
    sum (fe2es(entyFe,esty,teEs),
    pm_esCapCost(ttot,regi,teEs) * v_prodEs(ttot,regi,entyFe,esty,teEs)
    );
    ;



*' Limit electricity use for fehes to 1/4th of total electricity use:
q_limitSeel2fehes(t,regi)..
    1/4 * vm_usableSe(t,regi,"seel")
    =g=
    - vm_prodSe(t,regi,"pegeo","sehe","geohe") * pm_prodCouple(regi,"pegeo","sehe","geohe","seel")
;

*' Requires minimum share of liquids from oil in total liquids of 5%:
q_limitShOil(t,regi)..
    sum(pe2se("peoil",enty2,te)$(sameas(te,"refliq") ), 
       vm_prodSe(t,regi,"peoil",enty2,te) 
    ) 
    =g=
    0.05 * 
    sum(se2fe(enty,enty2,te)$(sameas(te,"tdfoshos") OR sameas(te,"tdfospet") OR sameas(te,"tdfosdie") ), 
       vm_demSe(t,regi,enty,enty2,te)
    ) 
;
 
***---------------------------------------------------------------------------
*' PE Historical Capacity:
*** set the bound at 0.9*historic capacities so that the model still needs to build additional capacity beyond the bound in order to fulfill FE demand, otherwise the calibration routine has problems
***---------------------------------------------------------------------------
q_PE_histCap(t,regi,entyPe,entySe)$(p_PE_histCap(t,regi,entyPe,entySe))..
    sum(te$pe2se(entyPe,entySe,te),
      sum(te2rlf(te,rlf), vm_cap(t,regi,te,rlf))
    )
    =g=
    0.9 * p_PE_histCap(t,regi,entyPe,entySe)
;
 
 
*** EOF ./core/equations.gms
