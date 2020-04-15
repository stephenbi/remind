*** |  (C) 2006-2019 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of REMIND and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  REMIND License Exception, version 1.0 (see LICENSE file).
*** |  Contact: remind@pik-potsdam.de
*** SOF ./modules/36_buildings/services_putty/presolve.gms



*** Take average price over previous iterations
if (ord(iteration) ge 5,
p36_fePrice(t,regi_dyn36(regi),entyFe) = 
            ( p36_fePrice_iter(iteration - 1,t,regi,entyFe)
            + p36_fePrice_iter(iteration - 2,t,regi,entyFe)
            + p36_fePrice_iter(iteration - 3,t,regi,entyFe)
            + p36_fePrice_iter(iteration - 4,t,regi,entyFe)
            )
            / 4;
);

*** smooth the costs

*** Smooth 2005 prices
$offOrder
p36_kapPrice(t,regi_dyn36(regi))$(ord(t) eq 1)
  = ( p36_kapPrice(t+1,regi) * 2
    + p36_kapPrice(t+2,regi)
    )
  / 3;

p36_fePrice(t,regi_dyn36(regi),entyFe)$(ord(t) eq 1)
  = ( p36_fePrice(t+1,regi,entyFe) * 2
    + p36_fePrice(t+2,regi,entyFe)
    )
  / 3;
$onOrder  
*** Smooth non 2005 prices with moving average
$OFForder
loop (t$ ( not ((ord(t) le 1) or (ord(t) eq card(t)))),
p36_kapPrice(t,regi_dyn36(regi))  =
                           ( p36_kapPrice(t-1,regi)
                           + p36_kapPrice(t,regi)
                           + p36_kapPrice(t+1,regi)
                            ) / 3  ;

p36_fePrice(t,regi_dyn36(regi),entyFe)  =
                             (p36_fePrice(t-1,regi,entyFe)
                             + p36_fePrice(t,regi,entyFe)                             
                             + p36_fePrice(t+1,regi,entyFe)
                             ) / 3;

);
$ONorder 

loop (fe2ces_dyn36(entyFe,esty,teEs,in),
p36_kapPriceImplicit(t,regi_dyn36(regi),teEs) = p36_kapPrice(t,regi) + p36_implicitDiscRateMarg(t,regi,in);
);

 p36_esCapCost(t,regi_dyn36(regi),teEs_dyn36(teEs)) =
   (f36_datafecostsglob("inco0",teEs) 
   *   p36_kapPrice(t,regi) / (1 - (1 + p36_kapPrice(t,regi))** (-f36_datafecostsglob("lifetime",teEs))) !! annualised initial capital costs
   + f36_datafecostsglob("omf",teEs)   
   )
   / f36_datafecostsglob("usehr",teEs)   !! from T$/TW to T$/TWh
   * sm_day_2_hour * sm_year_2_day         !! from T$/TWh to T$/TWa
   ;

 p36_esCapCostImplicit(t,regi_dyn36(regi),teEs_dyn36(teEs)) =
   (f36_datafecostsglob("inco0",teEs) 
   *   p36_kapPriceImplicit(t,regi,teEs) / (1 - (1 + p36_kapPriceImplicit(t,regi,teEs))** (-f36_datafecostsglob("lifetime",teEs))) !! annualised initial capital costs
   + f36_datafecostsglob("omf",teEs)   
   )
   / f36_datafecostsglob("usehr",teEs)   !! from T$/TW to T$/TWh
   * sm_day_2_hour * sm_year_2_day         !! from T$/TWh to T$/TWa
   ;   
 
p36_inconvpen(t,regi_dyn36(regi),teEs)$f36_inconvpen(teEs) = 
   (1 -
    min(max((20 - (vm_cesIO.L(t,regi,"inco")$( NOT sameAs(iteration,"1"))
                   +pm_gdp(t,regi)$ sameAs(iteration,"1")) / pm_shPPPMER(regi)
                  / pm_pop(t,regi))
            /(20 - 3),0),1)  !! (1-lambda) = 0 if gdppop < 3000, 1 if gdppop >= 20000
    )
    * f36_inconvpen(teEs) ;

loop ( fe2es_dyn36(entyFe,esty,teEs),
p36_techCosts(t,regi_dyn36(regi),entyFe,esty,teEs) =
       p36_esCapCostImplicit(t,regi,teEs)
       +
      (p36_fePrice(t,regi,entyFe)
      + p36_inconvpen(t,regi,teEs)
      + pm_tau_fe_tax_ES_st(t,regi,esty) 
      + pm_tau_fe_sub_ES_st(t,regi,esty)
      )
      / pm_fe2es(t,regi,teEs)
      !! add taxes, subsidies, and later on costs
      ;
);      

loop (ttot $ ( ( NOT t0(ttot)) AND pm_ttot_val(ttot) ge cm_startyear), 

***Compute the production of UE from remaining from last period's equipment.
p36_prodUEintern(ttot,regi_dyn36(regi),entyFe,esty,teEs) = (1 -p36_depreciationRate(teEs)) ** pm_dt(ttot) * p36_prodUEintern(ttot-1,regi,entyFe,esty,teEs);

if (t36_hist(ttot),
p36_prodUEintern(ttot,regi_dyn36(regi),entyFe,esty,teEs) = min (p36_prodUEintern(ttot,regi,entyFe,esty,teEs),
                                                                 p36_prodEs(ttot,regi,entyFe,esty,teEs) );
);
*** Ensure for scenario periods that the some of the remaining equipment is lower than the demand in the next period
if (t36_scen(ttot),
    loop ((regi_dyn36(regi),inViaEs_dyn36(in)), 
          if ( ( sum (fe2ces_dyn36(entyFe,esty,teEs,in),p36_prodUEintern(ttot,regi,entyFe,esty,teEs)) gt (0.90 * p36_demUEtotal(ttot,regi,in))),
              sm_tmp = 0.90 * p36_demUEtotal(ttot,regi,in)
                       / sum (fe2ces_dyn36(entyFe,esty,teEs,in),p36_prodUEintern(ttot,regi,entyFe,esty,teEs)) ;
             loop (fe2ces_dyn36(entyFe,esty,teEs,in),
                   p36_prodUEintern(ttot,regi,entyFe,esty,teEs)  = sm_tmp * p36_prodUEintern(ttot,regi,entyFe,esty,teEs);
             );
          );
    );
);
*** Compute the UE demand that is not covered by the remaining UE demand.
p36_demUEdelta(ttot,regi_dyn36(regi),in) = p36_demUEtotal(ttot,regi,in) - sum (fe2ces_dyn36(entyFe,esty,teEs,in),p36_prodUEintern(ttot,regi,entyFe,esty,teEs));

*** For historical periods:
if (t36_hist(ttot),
*** Compute the share of UE for each technology that is needed to get the aggregate technological distribution observed
loop (fe2ces_dyn36(entyFe,esty,teEs,in),
p36_shUeCesDelta(ttot,regi_dyn36(regi),entyFe,in,teEs) = (p36_prodEs(ttot,regi,entyFe,esty,teEs) 
                                             - p36_prodUEintern(ttot,regi,entyFe,esty,teEs)
                                             ) 
                                             / (p36_demUEtotal(ttot,regi,in) 
                                                 - sum ( fe2ces_dyn36_2(entyFe2,esty2,teEs2,in),p36_prodUEintern(ttot,regi,entyFe2,esty2,teEs2)));

     loop (regi_dyn36(regi),
     if ( p36_shUeCesDelta(ttot,regi,entyFe,in,teEs) lt 0,
     put testfile;
     put p36_shUeCesDelta.tn(ttot,regi,entyFe,in,teEs) , " = ", p36_shUeCesDelta(ttot,regi,entyFe,in,teEs) /;
     put p36_demUEtotal.tn(ttot,regi,in) , " = ", p36_demUEtotal(ttot,regi,in) /;
     put p36_prodEs.tn(ttot,regi,entyFe,esty,teEs) , " = ", p36_prodEs(ttot,regi,entyFe,esty,teEs) /;
     put p36_prodUEintern.tn(ttot,regi,entyFe,esty,teEs), " = ", p36_prodUEintern(ttot,regi,entyFe,esty,teEs) /;
     putclose;
     abort "some share was decreasing faster than planned. Look at the logfile for more information";
     );
     );                                        
);

*** Compute the calibration factors for the historical periods
loop (fe2ces_dyn36(entyFe,esty,teEs,in),
p36_logitCalibration(ttot,regi_dyn36(regi),entyFe,esty,teEs) $ p36_shUeCesDelta(ttot,regi,entyFe,in,teEs) !! exclude shares which are zero
        =
   (1/ (p36_logitLambda(regi,in))
    * log ( p36_shUeCesDelta(ttot,regi,entyFe,in,teEs))
    - p36_techCosts(ttot,regi,entyFe,esty,teEs)
   )
   -
   (1 / sum (fe2ces_dyn36_2(entyFe2,esty2,teEs2,in)$p36_shUeCesDelta(ttot,regi,entyFe2,in,teEs2),1) ) 
   * sum (fe2ces_dyn36_2(entyFe2,esty2,teEs2,in)$p36_shUeCesDelta(ttot,regi,entyFe2,in,teEs2), !! exclude shares which are zero
   1/ ( p36_logitLambda(regi,in))
    * log ( p36_shUeCesDelta(ttot,regi,entyFe2,in,teEs2))
    - p36_techCosts(ttot,regi,entyFe2,esty2,teEs2)
   );

);

*** For the last historical period, attribute the last historical value of the calibration parameter to the scenario periods
*** The calibration factors are reduced towards 80% in the long term to represent the enhanced flexibility of the system
*** Long lasting non-price barriers should preferably be represented through price mark-ups
if ( t36_hist_last(ttot),

 p36_logitCalibration(ttot,regi_dyn36(regi),entyFe,esty,teEs) $ ( fe2es_dyn36(entyFe,esty,teEs)
                                                                 AND NOT p36_logitCalibration(ttot,regi,entyFe,esty,teEs))
  = 5;

loop ( t36_scen(t2),
   
  p36_logitCalibration(t2,regi_dyn36(regi),entyFe,esty,teEs) $ fe2es_dyn36(entyFe,esty,teEs)
   = min(max((2100 - pm_ttot_val(t2))/(2100 -ttot.val),0),1)  !! lambda = 1 in 2015 and 0 in 2100
    * (p36_logitCalibration(ttot,regi,entyFe,esty,teEs)
       - 0.80 * p36_logitCalibration(ttot,regi,entyFe,esty,teEs))
     +  0.80 * p36_logitCalibration(ttot,regi,entyFe,esty,teEs)
    ;
    
    !! give a high parameter value to the technologies that do not have some
   p36_logitCalibration(t2,regi_dyn36(regi),entyFe,esty,teEs) $ (fe2es_dyn36(entyFe,esty,teEs)
                                                    AND NOT p36_logitCalibration(t2,regi,entyFe,esty,teEs))
  =   min(max((2100 - pm_ttot_val(t2))/(2100 -ttot.val),0),1)  !! lambda = 1 in 2015 and 0 in 2100     
      * (5
       - 0.3 * 5)
     +  0.3 * 5;
     
     !! Decrease the calibration factor for some technologies, based on the difference between the 2015 (ttot) Income per capita and scenario (t2) income per capita.
     !! the calibration factor decreases by 90% when income reaches 30 k$ if income per capita was equal or below 5 k$ in 2015.
     !! the decrease is lower if the starting income was above 10k$ and is 0 if income was above 30k$
   p36_logitCalibration(t2,regi_dyn36(regi),entyFe,esty,teEs) $ richTechs(teEs) =  !! calib = calib * (1 - 0.90 * X) 
     p36_logitCalibration(ttot,regi,entyFe,esty,teEs) 
     *  (1 - 0.90 
     * (( max ( 5, min (30, (vm_cesIO.L(t2,regi,"inco")$( NOT sameAs(iteration,"1")) + pm_gdp(t2,regi)$ sameAs(iteration,"1")) / pm_shPPPMER(regi) / pm_pop(t2,regi) ))
         - min (30, max (5, (vm_cesIO.L(ttot,regi,"inco")$( NOT sameAs(iteration,"1")) + pm_gdp(ttot,regi)$ sameAs(iteration,"1")) / pm_shPPPMER(regi) / pm_pop(ttot,regi) ))
         )
         / (30 -5))
       ) 
     ;
     
);
); 

);

*** Compute the UE shares delta based on the energy costs and calibration parameters.

loop (fe2ces_dyn36(entyFe,esty,teEs,in),

p36_shUeCesDelta(ttot,regi_dyn36(regi),entyFe,in,teEs)$t36_scen(ttot)
   = exp ( p36_logitLambda(regi,in) 
          *  ( p36_techCosts(ttot,regi,entyFe,esty,teEs)
              + p36_logitCalibration(ttot,regi,entyFe,esty,teEs)
              )
           )
     /
     sum (fe2ces_dyn36_2(entyFe2,esty2,teEs2,in), 
           exp ( p36_logitLambda(regi,in) 
          *  ( p36_techCosts(ttot,regi,entyFe2,esty2,teEs2)
              + p36_logitCalibration(ttot,regi,entyFe2,esty2,teEs2)
              )
           )
     )
 ;


*** Compute the aggregate UE shares
p36_shUeCes(ttot,regi_dyn36(regi),entyFe,in,teEs) =  (p36_prodUEintern(ttot,regi,entyFe,esty,teEs) 
                                          + p36_shUeCesDelta(ttot,regi,entyFe,in,teEs)
                                            * p36_demUEdelta(ttot,regi,in)
                                          )
                                          / p36_demUEtotal(ttot,regi,in);
);
);
*** Compute FE shares

p36_shFeCes(t,regi_dyn36(regi),entyFe,in,teEs)$p36_shUeCes(t,regi,entyFe,in,teEs) 
                                                = (1 / p36_fe2es(t,regi,teEs))
                                                 / sum ( (fe2ces_dyn36(entyFe2,esty2,teEs2,in)), (1 / p36_fe2es(t,regi,teEs2))
                                                                         * p36_shUeCes(t,regi,entyFe2,in,teEs2))
                                                 * p36_shUeCes(t,regi,entyFe,in,teEs)
                                                 ;
*** Pass on to core parameters
loop (fe2ces_dyn36(entyFe,esty,teEs,in),
pm_shFeCes(t,regi_dyn36(regi),entyFe,in,teEs)$( NOT t0(t)) = p36_shFeCes(t,regi,entyFe,in,teEs);
);
pm_esCapCost(t,regi_dyn36(regi),teEs_dyn36(teEs)) = p36_esCapCost(t,regi,teEs);


*** Diagnostics
*** Compute the norm of the difference between the share vectors of two iterations
p36_shUeCes_iter(iteration,t,regi,entyFe,in,teEs)  = p36_shUeCes(t,regi,entyFe,in,teEs) ;
if ( ord(iteration) gt 1,
loop ((t,regi_dyn36(regi),inViaEs_dyn36(in)),
p36_logitNorm(iteration,t,regi,in) = sqrt ( 
                                            sum (fe2ces_dyn36(entyFe,esty,teEs,in) ,
                                                 power ( p36_shUeCes_iter(iteration,t,regi,entyFe,in,teEs)
                                                         - p36_shUeCes_iter(iteration - 1,t,regi,entyFe,in,teEs),
                                                         2)
                                                 )
                                            )
;
)
);                                            

*** Reporting
put file_logit_buildings;
put "scenario", "iteration", "period", "region", "variable", "tech", "ces_out", "value" /;

*** Report on the historical shares

  loop (t36_hist(ttot),
    loop (regi_dyn36(regi),
      loop (fe2ces_dyn36(entyFe,esty,teEs,in),
         
         put "%c_expname%", "target", ttot.tl, regi.tl, "shareFE", teEs.tl, in.tl, p36_shFeCes(ttot,regi,entyFe,in,teEs) /;
         
            );
           );
         );

loop ((t,regi_dyn36(regi),fe2ces_dyn36(entyFe,esty,teEs,in)),
put "%c_expname%", iteration.tl, t.tl,regi.tl, "shareFE", teEs.tl, in.tl, p36_shFeCes(t,regi,entyFe,in,teEs) /;
put "%c_expname%", iteration.tl, t.tl,regi.tl, "shareUE", teEs.tl, in.tl, p36_shUeCes(t,regi,entyFe,in,teEs) /;
put "%c_expname%", iteration.tl, t.tl,regi.tl, "cost", teEs.tl, in.tl, (p36_techCosts(t,regi,entyFe,esty,teEs) * 1000 / (sm_day_2_hour * sm_year_2_day)) /;
put "%c_expname%", iteration.tl, t.tl,regi.tl, "calibfactor", teEs.tl, in.tl, (p36_logitCalibration(t,regi,entyFe,esty,teEs)* 1000 / (sm_day_2_hour * sm_year_2_day)) /;
put "%c_expname%", iteration.tl, t.tl,regi.tl, "FEpriceWoTax", teEs.tl, in.tl, (p36_fePrice(t,regi,entyFe) * 1000 / (sm_day_2_hour * sm_year_2_day)) /;
put "%c_expname%", iteration.tl, t.tl,regi.tl, "OM", teEs.tl, in.tl, ((p36_fePrice(t,regi,entyFe)
                                                                         + p36_inconvpen(t,regi,teEs)
                                                                         + pm_tau_fe_tax_ES_st(t,regi,esty) 
                                                                         + pm_tau_fe_sub_ES_st(t,regi,esty)
                                                                         )
                                                                         / pm_fe2es(t,regi,teEs) * 1000 / (sm_day_2_hour * sm_year_2_day)) /;
put "%c_expname%", iteration.tl, t.tl,regi.tl, "OM_FEpriceWtax", teEs.tl, in.tl, (
                                                                         (p36_fePrice(t,regi,entyFe)
                                                                         + pm_tau_fe_tax_ES_st(t,regi,esty) 
                                                                         + pm_tau_fe_sub_ES_st(t,regi,esty)
                                                                         )
                                                                         / pm_fe2es(t,regi,teEs) * 1000 / (sm_day_2_hour * sm_year_2_day)) /;
put "%c_expname%", iteration.tl, t.tl,regi.tl, "OM_inconvenience", teEs.tl, in.tl, ((
                                                                          p36_inconvpen(t,regi,teEs)
                                                                         )
                                                                         / pm_fe2es(t,regi,teEs) * 1000 / (sm_day_2_hour * sm_year_2_day)) /;
put "%c_expname%", iteration.tl, t.tl,regi.tl, "FEpriceTax", teEs.tl, in.tl, ((p36_fePrice(t,regi,entyFe)
                                                                         + pm_tau_fe_tax_ES_st(t,regi,esty) 
                                                                         + pm_tau_fe_sub_ES_st(t,regi,esty)
                                                                         )
                                                                         * 1000 / (sm_day_2_hour * sm_year_2_day)) /;
put "%c_expname%", iteration.tl, t.tl,regi.tl, "CapCosts", teEs.tl, in.tl, (p36_esCapCost(t,regi,teEs) * 1000 / (sm_day_2_hour * sm_year_2_day)) /;
put "%c_expname%", iteration.tl, t.tl,regi.tl, "CapCostsImplicit", teEs.tl, in.tl, (p36_esCapCostImplicit(t,regi,teEs) * 1000 / (sm_day_2_hour * sm_year_2_day)) /;
);

if ( ord(iteration) gt 1,
loop ((t,regi_dyn36(regi),inViaEs_dyn36(in)),
put "%c_expname%", iteration.tl, t.tl,regi.tl, "norm_diff", "NA" ,in.tl, p36_logitNorm(iteration,t,regi,in) /;
);
);

putclose;

*** EOF ./modules/36_buildings/services_putty/presolve.gms
