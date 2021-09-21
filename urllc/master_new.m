clear;
num_speeds = 5;
num_snaps_complete = zeros(num_speeds);
max_num_snaps = 50000;
num_locs = 1681;
snr_complete = zeros(num_speeds, max_num_snaps, num_locs);


load("C:\Users\AnbalaganSN\OneDrive - Universiteit Twente\Documenten\Codes\Project\channel_quality/cc_5mhzbw_27dB_3500MHz_10cmps.mat");
snr_complete(1,:,:) = snr_dB + 10;
num_snaps_complete(1) = num_snaps;
% Changes for urllc
clear snr_dB pragmatic_loss chumma blersnr frsp kf_db noise_floor sf sota_thr std_BLER_pred std_BLER_sota std_throughput_pred std_throughput_sota throughput_gain BLER_exp processing_time
clear mean_BLER_pred mean_BLER_sota max_locs num_snaps mean_throughput_pred mean_throughput_sota  pred_bler pred_mcs pred_thr rx_pow_db sota_bler sota_mcs snr_row_val
clear a abc antenna_gain c c_freq carrier_freq carrier_freq_vals d di e eirp f fc fi filename g i kf l location loop max_inter_SRS_time mcsthr p pow 
clear r1 rx_pow_dbm speed_index speed speed_vals s b samples_per_meter temp tracklen txh txPower txPower_vals x xlim xlim_neg y ylim ylim_neg z zlim xpos ypos t zpos


load("C:\Users\AnbalaganSN\OneDrive - Universiteit Twente\Documenten\Codes\Project\channel_quality/cc_5mhzbw_27dB_3500MHz_30cmps.mat");
snr_complete(2,1:num_snaps,:) = snr_dB+10;
num_snaps_complete(2) = num_snaps;
% Changes for urllc
clear snr_dB pragmatic_loss chumma blersnr frsp kf_db noise_floor sf sota_thr std_BLER_pred std_BLER_sota std_throughput_pred std_throughput_sota throughput_gain BLER_exp processing_time
clear mean_BLER_pred mean_BLER_sota max_locs num_snaps mean_throughput_pred mean_throughput_sota  pred_bler pred_mcs pred_thr rx_pow_db sota_bler sota_mcs snr_row_val
clear a abc antenna_gain c c_freq carrier_freq carrier_freq_vals d di e eirp f fc fi filename g i kf l location loop max_inter_SRS_time mcsthr p pow 
clear r1 rx_pow_dbm speed_index speed speed_vals s b samples_per_meter temp tracklen txh txPower txPower_vals x xlim xlim_neg y ylim ylim_neg z zlim xpos ypos t zpos


load("C:\Users\AnbalaganSN\OneDrive - Universiteit Twente\Documenten\Codes\Project\channel_quality/cc_5mhzbw_27dB_3500MHz_100cmps.mat");
snr_complete(3,1:num_snaps,:) = snr_dB+10;
num_snaps_complete(3) = num_snaps;
% Changes for urllc
clear snr_dB pragmatic_loss chumma blersnr frsp kf_db noise_floor sf sota_thr std_BLER_pred std_BLER_sota std_throughput_pred std_throughput_sota throughput_gain BLER_exp processing_time
clear mean_BLER_pred mean_BLER_sota max_locs num_snaps mean_throughput_pred mean_throughput_sota  pred_bler pred_mcs pred_thr rx_pow_db sota_bler sota_mcs snr_row_val
clear a abc antenna_gain c c_freq carrier_freq carrier_freq_vals d di e eirp f fc fi filename g i kf l location loop max_inter_SRS_time mcsthr p pow 
clear r1 rx_pow_dbm speed_index speed speed_vals s b samples_per_meter temp tracklen txh txPower txPower_vals x xlim xlim_neg y ylim ylim_neg z zlim xpos ypos t zpos


load("C:\Users\AnbalaganSN\OneDrive - Universiteit Twente\Documenten\Codes\Project\channel_quality/cc_5mhzbw_27dB_3500MHz_300cmps.mat");
snr_complete(4,1:num_snaps,:) = snr_dB+10;
num_snaps_complete(4) = num_snaps;
% Changes for urllc
clear snr_dB pragmatic_loss chumma blersnr frsp kf_db noise_floor sf sota_thr std_BLER_pred std_BLER_sota std_throughput_pred std_throughput_sota throughput_gain BLER_exp processing_time
clear mean_BLER_pred mean_BLER_sota max_locs num_snaps mean_throughput_pred mean_throughput_sota  pred_bler pred_mcs pred_thr rx_pow_db sota_bler sota_mcs snr_row_val
clear a abc antenna_gain c c_freq carrier_freq carrier_freq_vals d di e eirp f fc fi filename g i kf l location loop max_inter_SRS_time mcsthr p pow 
clear r1 rx_pow_dbm speed_index speed speed_vals s b samples_per_meter temp tracklen txh txPower txPower_vals x xlim xlim_neg y ylim ylim_neg z zlim xpos ypos t zpos


% load("C:\Users\AnbalaganSN\OneDrive - Universiteit Twente\Documenten\Codes\Project\channel_quality/cc_5mhzbw_27dB_3500MHz_500cmps.mat");
% snr_complete(5,1:num_snaps,:) = snr_dB+10;
% num_snaps_complete(5) = num_snaps;
% % Changes for urllc
% clear snr_dB pragmatic_loss chumma blersnr frsp kf_db noise_floor sf sota_thr std_BLER_pred std_BLER_sota std_throughput_pred std_throughput_sota throughput_gain BLER_exp processing_time
% clear mean_BLER_pred mean_BLER_sota max_locs num_snaps mean_throughput_pred mean_throughput_sota  pred_bler pred_mcs pred_thr rx_pow_db sota_bler sota_mcs snr_row_val
% clear a abc antenna_gain c c_freq carrier_freq carrier_freq_vals d di e eirp f fc fi filename g i kf l location loop max_inter_SRS_time mcsthr p pow 
% clear r1 rx_pow_dbm speed_index speed speed_vals s b samples_per_meter temp tracklen txh txPower txPower_vals x xlim xlim_neg y ylim ylim_neg z zlim xpos ypos t zpos


load("C:\Users\AnbalaganSN\OneDrive - Universiteit Twente\Documenten\Codes\Project\channel_quality/cc_5mhzbw_27dB_3500MHz_1000cmps.mat");
snr_complete(5,1:num_snaps,:) = snr_dB+10;
num_snaps_complete(5) = num_snaps;
% Changes for urllc
clear snr_dB pragmatic_loss chumma blersnr frsp kf_db noise_floor sf sota_thr std_BLER_pred std_BLER_sota std_throughput_pred std_throughput_sota throughput_gain BLER_exp processing_time
clear mean_BLER_pred mean_BLER_sota max_locs num_snaps mean_throughput_pred mean_throughput_sota  pred_bler pred_mcs pred_thr rx_pow_db sota_bler sota_mcs snr_row_val
clear a abc antenna_gain c c_freq carrier_freq carrier_freq_vals d di e eirp f fc fi filename g i kf l location loop max_inter_SRS_time mcsthr p pow 
clear r1 rx_pow_dbm speed_index speed speed_vals s b samples_per_meter temp tracklen txh txPower txPower_vals x xlim xlim_neg y ylim ylim_neg z zlim xpos ypos t zpos

num_snaps_complete = num_snaps_complete(:,1);
speed_vals = [0.1, 0.3, 1, 3, 10];

disp('Imports done...')
%%
load('bler_snr_URLLC_64', 'bler_snr_URLLC_64');
max_times = 500000;
num_locs = 1681;
BLER_exp = 0.0001;
PRBs_per_slot = 25;

message_size = 32*8; %bits
num_bits_per_PRB = zeros(15);
num_bits_per_PRB(1) = 0.1523 * 168;
num_bits_per_PRB(2) = 0.2344 * 168;
num_bits_per_PRB(3) = 0.377 * 168;
num_bits_per_PRB(4) = 0.6016 * 168;
num_bits_per_PRB(5) = 0.877 * 168;
num_bits_per_PRB(6) = 1.1758 * 168;
num_bits_per_PRB(7) = 1.4766 * 168;
num_bits_per_PRB(8) = 1.9141 * 168;
num_bits_per_PRB(9) = 2.4063 * 168;
num_bits_per_PRB(10) = 2.7305 * 168;
num_bits_per_PRB(11) = 3.3223 * 168;
num_bits_per_PRB(12) = 3.9023 * 168;
num_bits_per_PRB(13) = 4.5234 * 168;
num_bits_per_PRB(14) = 5.1152 * 168;
num_bits_per_PRB(15) = 5.5547 * 168;
num_bits_per_PRB = num_bits_per_PRB(:,1);


min_snr = bler_snr_URLLC_64(1,1);
max_snr = bler_snr_URLLC_64(size(bler_snr_URLLC_64,1),1);
optimal_MCS = zeros(num_speeds, max_num_snaps, num_locs);
for speed = 1: num_speeds
    num_snaps = num_snaps_complete(speed);
    for loop=1:num_locs
        for i=1:max_num_snaps
            if(i>num_snaps)
                t = floor(i / num_snaps);
                i_for_others = i-(t*num_snaps);
                if(i_for_others == 0)
                    i_for_others = num_snaps;
                end
            else
                i_for_others = i;
            end
            lookup_snr_val = snr_complete(speed,i_for_others,loop);
            if(lookup_snr_val >= max_snr)
                lookup_snr_val = max_snr;
            else
                if (lookup_snr_val <= min_snr)
                    lookup_snr_val = min_snr;
                end
            end
            snr_row_val = round(((lookup_snr_val + 9.5)*100)+1);
%             snr_row_val = get_SNR_row_val(lookup_snr_val);
            
            for k=size(bler_snr_URLLC_64,2):-1:2
                bler_val = bler_snr_URLLC_64(snr_row_val,k);
                if(bler_val <= BLER_exp || k==2)
                    optimal_MCS(speed,i_for_others,loop) = (k-1); %because column is one more than mcs val
                    break
                end
            end
         end
    end
end
disp('optimal done...')

save('49optimal_MCS' ,'optimal_MCS', '-v7.3');

%%
r1 = rand(max_num_snaps,1);
processing_time = 0;
times = floor(max_times./num_snaps_complete);
%%
SRS_Periodicity_array = [2, 5, 10, 20, 40, 80];
num_period = size(SRS_Periodicity_array,2);
SOTA_PRBs_used = 0;
SOTA_resource_utilization = zeros(num_speeds, num_period, num_locs);
optimal_PRBs_used = 0;
optimal_resource_utilization = zeros(num_speeds, num_locs);
PDR_optimal = zeros(num_speeds, num_locs);
PDR_SOTA = zeros(num_speeds, num_period,num_locs);

stepsize_array = [0.000001,0.00001, 0.0001 0.001, 0.01, 0.1, 1, 2, 4, 5];
num_stepsize = size(stepsize_array,2);
OLLA_PRBs_used = zeros(num_stepsize);
OLLA_resource_utilization = zeros(num_speeds, num_period, num_stepsize, num_locs);
PDR_OLLA = zeros(num_speeds,num_period ,num_stepsize,num_locs);

improbable = 0;


for speed=1:num_speeds
    num_snaps = num_snaps_complete(speed);
    convergence = floor(num_snaps_complete(1)/num_snaps_complete(speed));
    for iter=1:num_period
        inter_SRS_time = SRS_Periodicity_array(iter);
        for loop = 1:num_locs
            sota_failed_tx = 0;
            optimal_failed_tx = 0;
            sota_succ_tx = 0;
            optimal_succ_tx = 0;
            new_val_age = 0;
            mcs_col = optimal_MCS(speed,1,loop) + 1;
            olla_succ_tx = zeros(num_stepsize,1);
            olla_failed_tx = zeros(num_stepsize,1);
            delta_olla = zeros(num_stepsize,1);
            t=0;
            for i=1:num_snaps*times(speed)
                if(i>num_snaps)
                    t = floor(i / num_snaps);
                    i_for_others = i-(t*num_snaps);
                    if(i_for_others == 0)
                        i_for_others = num_snaps;
                        r1 = rand(max_num_snaps,1);
                    end
                else
                    i_for_others = i;
                end
                
                if(mod(i_for_others,inter_SRS_time) == 0 || i_for_others==1)
                    new_mcs_col = optimal_MCS(speed,i_for_others,loop) + 1;
                    new_val_age = 1;
                    check = 1;
                end
                if((check == 1) && (new_val_age > processing_time))
                    mcs_col = new_mcs_col;
                    check = 0;
                end
                
                lookup_snr_val = snr_complete(speed,i_for_others,loop);
                if(lookup_snr_val >= max_snr)
                    lookup_snr_val = max_snr;
                else
                    if (lookup_snr_val <= min_snr)
                        lookup_snr_val = min_snr;
                    end
                end
                snr_row_val = round(((lookup_snr_val + 9.5)*100)+1);
                optimal_mcs_val = optimal_MCS(speed, i_for_others, loop);
                sota_mcs_val = mcs_col - 1;
                sotabler = bler_snr_URLLC_64(snr_row_val, (sota_mcs_val + 1));
                optimalbler = bler_snr_URLLC_64(snr_row_val, optimal_mcs_val+1);
                new_val_age = new_val_age + 1;
                instant_rand = r1(i_for_others,1);
                if(instant_rand >= sotabler && t>convergence)
                    sota_succ_tx = sota_succ_tx + 1;
                    SOTA_PRBs_used = SOTA_PRBs_used + ( (ceil(message_size / num_bits_per_PRB(sota_mcs_val,1))) / PRBs_per_slot);
                else
                    sota_failed_tx = sota_failed_tx +1;
                end
                if(instant_rand >= optimalbler && t>convergence)
                    optimal_succ_tx = optimal_succ_tx + 1;
                    optimal_PRBs_used = optimal_PRBs_used + ( (ceil(message_size / num_bits_per_PRB(optimal_mcs_val,1))) / PRBs_per_slot);
                else
                    optimal_failed_tx = optimal_failed_tx + 1;
%                     if(optimal_mcs_val > 1)
% %                         disp('duuude, improbable has happened');
%                         improbable = improbable + 1;
%                     end
                end
%                 if(sotabler<r1(i_for_others) && r1(i_for_others)<optimalbler)
%                     disp('sota better than optimal');
%                 end
                %olla starts
                random_value = rand();
                for step=1:num_stepsize
                    stepsize = stepsize_array(step);
                    temp_olla_mcs_val =  mcs_col - 1;
                    if (random_value < (ceil(delta_olla(step)) - delta_olla(step)))
                        offset = floor(delta_olla(step));
                    else
                        offset = ceil(delta_olla(step));
                    end
                    olla_mcs_val = (temp_olla_mcs_val + offset);
                    if ((olla_mcs_val) < 1 )
                        olla_mcs_val = 1;
                    else
                        if ((olla_mcs_val) > 15)
                            olla_mcs_val = 15;
                        end
                    end
                    ollabler = bler_snr_URLLC_64(snr_row_val, (olla_mcs_val + 1));
                    if(instant_rand >= ollabler)
                        delta_olla(step) = delta_olla(step) + (BLER_exp * stepsize);
                        if(t>convergence)
                            olla_succ_tx(step) = olla_succ_tx(step) + 1;
                            OLLA_PRBs_used(step) = OLLA_PRBs_used(step) + ( (ceil(message_size / num_bits_per_PRB(olla_mcs_val,1))) / PRBs_per_slot);
                        end
                    else
                        delta_olla(step) = delta_olla(step) - ( (1-BLER_exp) * stepsize);
                        olla_failed_tx(step) = olla_failed_tx(step) +1;
                    end
%                     if optimal_succ_tx < olla_succ_tx(step)
%                         disp('prob')
%                     end
                end
                
            end
            
            for step=1:num_stepsize
                PDR_OLLA(speed,iter,step,loop) = olla_succ_tx(step) / (num_snaps*(times(speed)-(convergence+1)));
                OLLA_resource_utilization(speed,iter,step,loop) = OLLA_PRBs_used(step) / olla_succ_tx(step);
            end
            PDR_SOTA(speed, iter, loop) = sota_succ_tx / (num_snaps*(times(speed)-(convergence+1)));
            PDR_optimal(speed, loop) = optimal_succ_tx / (num_snaps*(times(speed)-(convergence+1)));
            optimal_resource_utilization(speed,loop) = optimal_PRBs_used / optimal_succ_tx;
            SOTA_resource_utilization(speed, iter,loop) = SOTA_PRBs_used / sota_succ_tx;
            optimal_PRBs_used = 0;
            SOTA_PRBs_used = 0;
            OLLA_PRBs_used = zeros(num_stepsize,1);
        end
    end
end
save('49optimal_resource_utilization' ,'optimal_resource_utilization', '-v7.3');
save('49SOTA_resource_utilization' ,'SOTA_resource_utilization', '-v7.3');
save('49PDR_optimal' ,'PDR_optimal', '-v7.3');
save('49PDR_SOTA' ,'PDR_SOTA', '-v7.3');
disp('SOTA done...')
save('49OLLA_resource_utilization' ,'OLLA_resource_utilization', '-v7.3');
save('49PDR_OLLA' ,'PDR_OLLA', '-v7.3');
disp('OLLA done...')

%%
clear optimal_resource_utilization SOTA_resource_utilization PDR_OLLA PDR_optimal PDR_SOTA OLLA_resource_utilization
sigma_stepsize = 0.05;
sigma_count = 20;

PDR_predicted = zeros(num_speeds,sigma_count, num_locs);
predicted_resource_utilization = zeros(num_speeds,sigma_count, num_locs);
predicted_PRBs_used = 0;

sigmas = zeros([sigma_count, 1]);
random_normal = normrnd(0, 1, sigma_count, max_num_snaps, num_locs);
disp("sizes of random_normal:" + size(random_normal));
% pred_mcs_size = size(pred_mcs, 2);
disp("generated random numbers");



for sigma_index = 1:sigma_count
    sigma = sigma_stepsize * (sigma_index - 1);
    sigmas(sigma_index) = sigma;
end
 

for speed=1:num_speeds
    num_snaps = num_snaps_complete(speed);
    ran_check=1;
    for iter=1:sigma_count
        sigma = sigmas(iter);
        for loop = 1:num_locs
            predicted_failed_tx = 0;
            predicted_succ_tx = 0;
            new_val_age = 0;
            mcs_col = optimal_MCS(speed,1,loop) + 1;
            
            for i=1:num_snaps*times(speed)
                if(i>num_snaps)
                    t = floor(i / num_snaps);
                    i_for_others = i-(t*num_snaps);
                    if(i_for_others == 0)
                        i_for_others = num_snaps;
                        r1 = rand(max_num_snaps,1);
                    end
                else
                    i_for_others = i;
                end
                actual_snr = snr_complete(speed,i_for_others, loop);
                predicted_snr = random_normal(iter,i_for_others, loop) * sigma + (actual_snr);
                
                if(predicted_snr >= max_snr)
                    predicted_snr = max_snr;
                else
                    if (predicted_snr <= min_snr)
                        predicted_snr = min_snr;
                    end
                end
                snr_row_val = round(((predicted_snr + 9.5)*100)+1);
                if(actual_snr >= max_snr)
                    actual_snr = max_snr;
                else
                    if (actual_snr <= min_snr)
                        actual_snr = min_snr;
                    end
                end
                actual_snr_row_val = round(((actual_snr + 9.5)*100)+1);
                for k=size(bler_snr_URLLC_64,2):-1:2
                    bler_val = bler_snr_URLLC_64(snr_row_val,k);
                    if(bler_val <= BLER_exp || k==2)
                        predicted_mcs_val = (k-1);
                        break
                    end
                end
                predicted_bler = bler_snr_URLLC_64(actual_snr_row_val, (predicted_mcs_val + 1));
               
                if(r1(i_for_others,1) >= predicted_bler)
                    predicted_succ_tx = predicted_succ_tx + 1;
                    predicted_PRBs_used = predicted_PRBs_used + ( (ceil(message_size / num_bits_per_PRB(predicted_mcs_val,1))) / PRBs_per_slot);
                else
                    predicted_failed_tx = predicted_failed_tx +1;
                end
            end
            
            PDR_predicted(speed, iter, loop) = predicted_succ_tx / (num_snaps*times(speed));
            predicted_resource_utilization(speed,iter,loop) = predicted_PRBs_used / predicted_succ_tx;
            predicted_PRBs_used = 0;
        end
    end
end
save('49predicted_resource_utilization' ,'predicted_resource_utilization', '-v7.3');
save('49PDR_predicted' ,'PDR_predicted', '-v7.3');
disp('Prediction done...')

%% 10th Percentile users
num_speeds = 5;
num_period = 6;
num_stepsize = 10;
sigma_count = 20;
num_locs = 1681;
speed_vals = [0.1, 0.3, 1, 3, 10];
SRS_Periodicity_array = [2, 5, 10, 20, 40, 80];
signi_bits = 4;
urllc_10_prctil_value = zeros(num_speeds, num_period);
for i=1:num_speeds
    for j=1:num_period
        urllc_10_prctil_value(i,j) = round(prctile(PDR_SOTA(i,j,:),10),signi_bits);
    end
end

urllc_10_prctil_loc = zeros(num_speeds, num_period, 168);

for i=1:num_speeds
    for j=1:num_period
        index = 1;
        for k=1:num_locs
            temp = PDR_SOTA(i,j,k);
            if (temp < urllc_10_prctil_value(i,j))
                urllc_10_prctil_loc(i,j,index) = k;
                index = index+1;
            end
        end
    end
end

%%
CI_olla_stepsize_10p = zeros(num_speeds, num_period,num_stepsize,index-1);
CI_SOTA_speeds_10p = zeros(num_speeds, num_period, index-1);
CI_optimal_speeds_10p = zeros(num_speeds, index-1);
CI_predicted_speeds_10p = zeros(num_speeds, sigma_count, index-1);

CI_olla_stepsize_10p_RU = zeros(num_speeds, num_period,num_stepsize, index-1);
CI_SOTA_speeds_10p_RU = zeros(num_speeds, num_period, index-1 );
CI_optimal_speeds_10p_RU = zeros(num_speeds, index-1);
CI_predicted_speeds_10p_RU = zeros(num_speeds, sigma_count, index-1);

olla_stepsize_10p = zeros(num_speeds, num_period,num_stepsize);
SOTA_speeds_10p = zeros(num_speeds, num_period);
optimal_speeds_10p = zeros(num_speeds);
predicted_speeds_10p = zeros(num_speeds, sigma_count);

olla_stepsize_10p_RU = zeros(num_speeds, num_period,num_stepsize);
SOTA_speeds_10p_RU = zeros(num_speeds, num_period);
optimal_speeds_10p_RU = zeros(num_speeds);
predicted_speeds_10p_RU = zeros(num_speeds, sigma_count);


for i=1:num_speeds
    for jj=1:num_period
        for j=1:num_stepsize
            temp_olla=0;
            temp_optimal=0;
            temp_SOTA=0;
            temp_olla_resource_utilization=0;
            temp_SOTA_resource_utilization=0;
            temp_optimal_resource_utilization=0;
            temp_predicted = zeros(sigma_count,1);
            temp_predicted_resource_utilization=0;
            count=0;
            for k=1:size(urllc_10_prctil_loc(i,jj,:),3)
                locs = squeeze(urllc_10_prctil_loc(i,jj,:));
                if(locs(k,1) ~=0)
                    temp_olla = temp_olla + PDR_OLLA(i,jj,j,locs(k,1));
                    temp_optimal = temp_optimal + PDR_optimal(i,locs(k,1));
                    temp_SOTA = temp_SOTA + PDR_SOTA(i,jj,locs(k,1));
                    temp_predicted = temp_predicted + (PDR_predicted(i,:,locs(k,1)).');
                    
                    temp_olla_resource_utilization = temp_olla_resource_utilization + OLLA_resource_utilization(i,jj,j,locs(k,1));
                    temp_optimal_resource_utilization = temp_optimal_resource_utilization + optimal_resource_utilization(i,locs(k,1));
                    temp_SOTA_resource_utilization = temp_SOTA_resource_utilization + SOTA_resource_utilization(i,jj,locs(k,1));
                    temp_predicted_resource_utilization = temp_predicted_resource_utilization + predicted_resource_utilization(i,:,locs(k,1));
                    CI_olla_stepsize_10p(i,jj,j,count+1) = PDR_OLLA(i,jj,j,locs(k,1));
                    CI_SOTA_speeds_10p( i, jj,count+1) = PDR_SOTA(i,jj,locs(k,1));
                    CI_optimal_speeds_10p(i,count+1) = PDR_optimal(i,locs(k,1));
                    CI_predicted_speeds_10p(i,:,count+1) = (PDR_predicted(i,:,locs(k,1)).');

                    CI_olla_stepsize_10p_RU(i,jj,j,count+1) = OLLA_resource_utilization(i,jj,j,locs(k,1));
                    CI_SOTA_speeds_10p_RU(i,jj,count+1) = SOTA_resource_utilization(i,jj,locs(k,1));
                    CI_optimal_speeds_10p_RU(i,count+1) = optimal_resource_utilization(i,locs(k,1));
                    CI_predicted_speeds_10p_RU(i,:,count+1) = predicted_resource_utilization(i,:,locs(k,1));
                    
                    count = count+1;
                end
            end
            olla_stepsize_10p(i,jj,j) = round(temp_olla/count,signi_bits);
            SOTA_speeds_10p( i, jj) = round(temp_SOTA/count,signi_bits);
            optimal_speeds_10p(i) = round(temp_optimal/count,signi_bits);            
            predicted_speeds_10p(i,:) = round((temp_predicted ./ count) ,signi_bits);
            
            olla_stepsize_10p_RU(i,jj,j) = round(temp_olla_resource_utilization/count,signi_bits);
            SOTA_speeds_10p_RU(i,jj) = round(temp_SOTA_resource_utilization/count,signi_bits);
            optimal_speeds_10p_RU(i) = round(temp_optimal_resource_utilization/count,signi_bits);
            predicted_speeds_10p_RU(i,:) = round((temp_predicted_resource_utilization./count),signi_bits);
        end
    end
end

%% OLLA CI calculation
OLLA_PDR_CIs = zeros(num_speeds,num_period, num_stepsize,3);
OLLA_RU_CIs = zeros(num_speeds,num_period, num_stepsize,3);

SOTA_PDR_CIs_opti = zeros(num_speeds, num_period,3);
SOTA_RU_CIs_opti = zeros(num_speeds, num_period,3);

optimal_PDR_CIs_opti = zeros(num_speeds,3);
optimal_RU_CIs_opti = zeros(num_speeds,3);

for i=1:num_speeds
    for j=1:num_period
        for k=1:num_stepsize
            SEM = std(CI_olla_stepsize_10p(i,j,k,1:sum(CI_olla_stepsize_10p(1,1,1,:)~=0)))/sqrt(sum(CI_olla_stepsize_10p(i,j,k,:)~=0));               % Standard Error
            ts = tinv([0.025  0.975],sum(CI_olla_stepsize_10p(i,j,k,:)~=0)-1);      % T-Score
            OLLA_PDR_CIs(i,j,k,2:3) = round((olla_stepsize_10p(i,j,k) + (ts*SEM)), signi_bits);
            OLLA_PDR_CIs(i,j,k,1) = round(olla_stepsize_10p(i,j,k),signi_bits);
            
            SEM = std(CI_olla_stepsize_10p_RU(i,j,k,1:sum(CI_olla_stepsize_10p_RU(1,1,1,:)~=0)))/sqrt(sum(CI_olla_stepsize_10p_RU(i,j,k,:)~=0));               % Standard Error
            ts = tinv([0.025  0.975],sum(CI_olla_stepsize_10p_RU(i,j,k,:)~=0)-1);      % T-Score
            OLLA_RU_CIs(i,j,k,2:3) = round(olla_stepsize_10p_RU(i,j,k) + ts*SEM,signi_bits);
            OLLA_RU_CIs(i,j,k,1) = round(olla_stepsize_10p_RU(i,j,k),signi_bits);
        end
        SEM = std(CI_SOTA_speeds_10p(i,j,1:sum(CI_SOTA_speeds_10p(i,j,:)~=0)))/sqrt(sum(CI_SOTA_speeds_10p(i,j,:)~=0));               % Standard Error
        ts = tinv([0.025  0.975],sum(CI_SOTA_speeds_10p(i,j,:)~=0)-1);      % T-Score
        SOTA_PDR_CIs_opti(i,j,k,2:3) = round(SOTA_speeds_10p(i,j) + ts*SEM, signi_bits);
        SOTA_PDR_CIs_opti(i,j,k,1) = round(SOTA_speeds_10p(i,j),signi_bits);
        
        SEM = std(CI_SOTA_speeds_10p_RU(i,j,1:sum(CI_SOTA_speeds_10p_RU(i,j,:)~=0)))/sqrt(sum(CI_SOTA_speeds_10p_RU(i,j,:)~=0));               % Standard Error
        ts = tinv([0.025  0.975],sum(CI_SOTA_speeds_10p_RU(i,j,:)~=0)-1);      % T-Score
        SOTA_RU_CIs_opti(i,j,2:3) = round(SOTA_speeds_10p_RU(i,j) + ts*SEM,signi_bits);
        SOTA_RU_CIs_opti(i,j,1) = round(SOTA_speeds_10p_RU(i,j),signi_bits);
    end
    SEM = std(CI_optimal_speeds_10p(i,1:sum(CI_optimal_speeds_10p(i,:)~=0)))/sqrt(sum(CI_optimal_speeds_10p(i,:)~=0));               % Standard Error
    ts = tinv([0.025  0.975],sum(CI_optimal_speeds_10p(i,:)~=0)-1);      % T-Score
    optimal_PDR_CIs_opti(i,2:3) = round(optimal_speeds_10p(i)+ ts*SEM, signi_bits);
    optimal_PDR_CIs_opti(i,1) = round(optimal_speeds_10p(i),signi_bits);
    
    SEM = std(CI_optimal_speeds_10p_RU(i,1:sum(CI_optimal_speeds_10p_RU(i,:)~=0)))/sqrt(sum(CI_optimal_speeds_10p_RU(i,:)~=0));               % Standard Error
    ts = tinv([0.025  0.975],sum(CI_optimal_speeds_10p_RU(i,:)~=0)-1);      % T-Score
    optimal_RU_CIs_opti(i,2:3) = round(optimal_speeds_10p_RU(i) + ts*SEM,signi_bits);
    optimal_RU_CIs_opti(i,1) = round(optimal_speeds_10p_RU(i),signi_bits);
end
%%

olla_opti_stepsize = zeros(num_speeds, num_period);
for i=1:num_speeds
    for j=1:num_period
%        max_pdr = max(OLLA_PDR_CIs(i,j,:,1));
        max_pdr = 0.9986;
       ci_width = 1;
        for k=1:num_stepsize
            temp = OLLA_PDR_CIs(i,j,k,1); %mean
            if temp>=max_pdr
                temp_ci = OLLA_PDR_CIs(i,j,k,3) - OLLA_PDR_CIs(i,j,k,2);
%                 if temp_ci < ci_width
                    olla_opti_stepsize(i,j) = k;
                    ci_width = temp_ci;
                    break;
%                 end
            end
        end
    end
end
%%
OLLA_PDR_CIs_opti = zeros(num_speeds, num_period,3);
OLLA_RU_CIs_opti = zeros(num_speeds, num_period,3);

for i=1:num_speeds
    for j=1:num_period
        OLLA_PDR_CIs_opti(i,j,:) = OLLA_PDR_CIs(i,j,olla_opti_stepsize(i,j),:);
        OLLA_RU_CIs_opti(i,j,:) = OLLA_RU_CIs(i,j,olla_opti_stepsize(i,j),:);
        
    end
end

%% find the optimal stepsize for 3ms and 40ms. 
tteemmpp = zeros(num_speeds,2);
% tteemmpp(:,1) = SOTA_speeds_10p(:,3);
tteemmpp(:,1) = OLLA_PDR_CIs_opti(:,5,1);
tteemmpp(:,2) = optimal_PDR_CIs_opti(:,1);
figure;
bar(tteemmpp, 'grouped');
error_series1 = (OLLA_PDR_CIs_opti(:,5,3) - OLLA_PDR_CIs_opti(:,5,2))/2;
error_series2 = (optimal_PDR_CIs_opti(:,3) - optimal_PDR_CIs_opti(:,2))/2;
err = [error_series1 error_series2];
set(gca,'xticklabel',{'0.1','0.3','1','3', '10'});
set(gca, 'YScale', 'log');
xlabel('UE Speed [m/s]');
ylabel('Reliability');
hold on
ngroups = size(tteemmpp, 1);
nbars = size(tteemmpp, 2);
groupwidth = min(0.8, nbars/(nbars + 1.5));
for i = 1:nbars
    % Calculate center of each bar
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x, tteemmpp(:,i), err(:,i), 'k', 'linestyle', 'none');
end
set(gca, 'YScale', 'log');
%%
RU_diff = zeros(num_speeds, num_period);
for i=1:num_speeds
    for j=1:num_period
        RU_diff(i,j) = optimal_RU_CIs_opti(i,1) - OLLA_RU_CIs_opti(i,j,1);
    end
end

figure;
speed_col = reshape(speed_vals(1:num_speeds),[],1);
SRS_col = reshape(SRS_Periodicity_array(1:num_period),[],1);
surf(SRS_col,speed_col,RU_diff(:,1:num_period));
set(gca, 'YScale', 'log');
set(gca, 'XScale', 'log');
xlabel('UE Speed [m/s]');
ylabel('CQI Periodicity [ms]');
zlabel('Resource Utilization');

PDR_diff = zeros(num_speeds, num_period);
for i=1:num_speeds
    for j=1:num_period
        PDR_diff(i,j) = (optimal_PDR_CIs_opti(i,1) - OLLA_PDR_CIs_opti(i,j,1));
    end
end

figure;
speed_col = reshape(speed_vals(1:num_speeds),[],1);
SRS_col = reshape(SRS_Periodicity_array(1:num_period),[],1);
surf(SRS_col,speed_col,PDR_diff(:,1:num_period));
set(gca, 'YScale', 'log');
set(gca, 'XScale', 'log');
set(gca, 'ZScale', 'log');