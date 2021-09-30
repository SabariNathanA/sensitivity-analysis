# eMBB sensitivity analysis
## Codes
par_master10p.m -> This code is the MAIN execution file. This performs the mentioned sensitivity analysis. This code is optimized for parallel execution.
pp_diff_BLER.m -> % This program uses BLER_exp_mod_PP as the BLER target for PP (optimal) and BLER_exp as the BLER_target for OLLA. Having different BLER targets for PP and OLLA.
pp_master10p_optimalwith_olla.m -> We added OLLA to the perfect prediction scenario. 
get_SNR_row_val.m -> helper file for execution of all above files.
pp_olla_static_master.m -> We tried to check the difference between PP and OLLA for static user scenario
## Results
SensitivityAnalysiseMBBResults.zip -> The results of the submitted paper.
corrected_eMBB_1000cmps_lowsteps_BLER_xx.mat -> Result of scenario with UE moving at 1000 centimetres per second. The difference between files being the Target_BLER. Example: BLER15=0.15% BLER
bler_SNR_256QAM.mat -> mapping between BLER and SNR for 15 CQI levels reaching upto 256QAM (Table 5.2.2.1-3 from 3GPP TS 38.214
