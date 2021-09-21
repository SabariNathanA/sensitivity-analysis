clear;

max_num_snaps = 50000;
% snr_complete = zeros(max_num_snaps, num_locs);

load('bler_snr_URLLC_64', 'bler_snr_URLLC_64');
max_times = 5000000;
num_snaps = 500; %10-50000;30-16665;100-5000;300-1665;1000-500
BLER_exp = 0.00001; %39 - 0.001; 49 - 0.0001; 59 = 0.00001
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

processing_time = 0;

times = floor(max_times/num_snaps);
convergence_times = floor(max_num_snaps/num_snaps);



min_snr = bler_snr_URLLC_64(1,1);
max_snr = bler_snr_URLLC_64(size(bler_snr_URLLC_64,1),1);


num_period = 6;
num_stepsize = 11;
sigma_count = 20;
PDR_optimal_10p = zeros(10,1);
PDR_SOTA_10p = zeros(10, num_period);
PDR_OLLA_10p = zeros(10, num_period, num_stepsize);
RU_optimal_90p = zeros(10,1);
RU_SOTA_90p = zeros(10, num_period);
RU_OLLA_90p = zeros(10, num_period, num_stepsize);
PDR_predicted_10p = zeros(10, sigma_count);
RU_predicted_90p = zeros(10, sigma_count);
RU_optimal_mean = zeros(10,1);
RU_SOTA_mean = zeros(10, num_period);
RU_OLLA_mean = zeros(10, num_period, num_stepsize);
RU_predicted_mean = zeros(10, sigma_count);

for fileid=1:10
    a= 'C:\Users\AnbalaganSN\Documents\Sabari\MATLAB_src\channel_quality/cc_50grid_5mhzbw_20dB_3500MHz_1000cmps_';
    z='.mat';
    filename = [a num2str(fileid) z];
    snr_complete = load(filename).snr_dB;
    snr_complete = snr_complete + 15;
    num_locs = size(snr_complete,2);
    optimal_MCS = zeros(num_snaps, num_locs);
    SRS_Periodicity_array = [2, 5, 10, 20, 40, 80];
    stepsize_array = [0.0000001,0.000001,0.00001,0.0001,0.001,0.01,0.1,1,2,3,4];
    num_stepsize = size(stepsize_array,2);
    num_period = size(SRS_Periodicity_array,2);
    for loop=1:num_locs
        for i=1:num_snaps*times
            if(i>num_snaps)
                t = floor(i / num_snaps);
                i_for_others = i-(t*num_snaps);
                if(i_for_others == 0)
                    i_for_others = num_snaps;
                end
            else
                i_for_others = i;
            end
            lookup_snr_val = snr_complete(i_for_others,loop);
            if(lookup_snr_val >= max_snr)
                lookup_snr_val = max_snr;
            else
                if (lookup_snr_val <= min_snr)
                    lookup_snr_val = min_snr;
                end
            end
            snr_row_val = round(((lookup_snr_val + 9.5)*100)+1);
            for k=size(bler_snr_URLLC_64,2):-1:2
                bler_val = bler_snr_URLLC_64(snr_row_val,k);
                if(bler_val <= BLER_exp || k==2)
                    optimal_MCS(i_for_others,loop) = (k-1); %because column is one more than mcs val
                    break
                end
            end
        end
    end
    %     test(:,fileid) = mean(optimal_MCS,1);
    convergence = convergence_times;
    PDR_optimal = zeros(num_locs,1);
    PDR_SOTA = zeros(num_period,num_locs);
    optimal_RU = zeros( num_locs,1);
    SOTA_RU = zeros( num_period, num_locs);
    olla_RU = zeros(num_period, num_stepsize, num_locs);
    PDR_OLLA = zeros(num_period ,num_stepsize,num_locs);
    r1 = rand(max_num_snaps,1);
    check=0;
    new_mcs_col=0;
    for iter=1:num_period
        inter_SRS_time = SRS_Periodicity_array(iter);
        for loop = 1:num_locs
            sota_failed_tx = 0;
            optimal_failed_tx = 0;
            sota_succ_tx = 0;
            optimal_succ_tx = 0;
            new_val_age = 0;
            SOTA_PRBs_used = 0;
            optimal_PRBs_used = 0;
            OLLA_PRBs_used = zeros(num_stepsize,1);
            mcs_col = optimal_MCS(1,loop) + 1;
            olla_succ_tx = zeros(num_stepsize,1);
            olla_failed_tx = zeros(num_stepsize,1);
            delta_olla = zeros(num_stepsize,1);
            t=0;
            for i=1:num_snaps*times
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
                    new_mcs_col = optimal_MCS(i_for_others,loop) + 1;
                    new_val_age = 1;
                    check = 1;
                end
                if((check == 1) && (new_val_age > processing_time))
                    mcs_col = new_mcs_col;
                    check = 0;
                end
                
                lookup_snr_val = snr_complete(i_for_others,loop);
                if(lookup_snr_val >= max_snr)
                    lookup_snr_val = max_snr;
                else
                    if (lookup_snr_val <= min_snr)
                        lookup_snr_val = min_snr;
                    end
                end
                snr_row_val = round(((lookup_snr_val + 9.5)*100)+1);
                optimal_mcs_val = optimal_MCS(i_for_others, loop);
                sota_mcs_val = mcs_col - 1;
                sotabler = bler_snr_URLLC_64(snr_row_val, (sota_mcs_val + 1));
                optimalbler = bler_snr_URLLC_64(snr_row_val, optimal_mcs_val+1);
                % increment new value age
                new_val_age = new_val_age + 1;
                if(t>convergence)
                    instant_rand = r1(i_for_others,1);
                    SOTA_PRBs_used = SOTA_PRBs_used + ( (ceil(message_size / num_bits_per_PRB(sota_mcs_val,1))) / PRBs_per_slot);
                    if(instant_rand >= sotabler)
                        
                        sota_succ_tx = sota_succ_tx + 1;
                    else
                        sota_failed_tx = sota_failed_tx +1;
                    end
                    optimal_PRBs_used = optimal_PRBs_used + ( (ceil(message_size / num_bits_per_PRB(optimal_mcs_val,1))) / PRBs_per_slot);
                    if(instant_rand >= optimalbler)
                        optimal_succ_tx = optimal_succ_tx + 1;
                        
                    else
                        optimal_failed_tx = optimal_failed_tx + 1;
                    end
                end
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
                    new_val_age = new_val_age + 1;
                    if (t>convergence)
                        OLLA_PRBs_used(step) = OLLA_PRBs_used(step) +  ( (ceil(message_size / num_bits_per_PRB(olla_mcs_val,1))) / PRBs_per_slot);
                        if(instant_rand >= ollabler )
                            delta_olla(step) = delta_olla(step) + (BLER_exp * stepsize);
                            olla_succ_tx(step) = olla_succ_tx(step) + 1;
                            
                        end
                    else
                        delta_olla(step) = delta_olla(step) - ( (1-BLER_exp) * stepsize);
                        olla_failed_tx(step) = olla_failed_tx(step) +1;
                    end
                    
                end
            end
            for step=1:num_stepsize
                PDR_OLLA(iter,step,loop) = olla_succ_tx(step) / (num_snaps*(times-(convergence+1)));
                olla_RU(iter,step,loop) = OLLA_PRBs_used(step) / (num_snaps*(times-(convergence+1)));
            end
            optimal_RU(loop,1) = optimal_PRBs_used / (num_snaps*(times-(convergence+1)));
            SOTA_RU( iter, loop) = SOTA_PRBs_used / (num_snaps*(times-(convergence+1)));
            PDR_SOTA(iter, loop) = sota_succ_tx / (num_snaps*(times-(convergence+1)));
            PDR_optimal(loop,1) = optimal_succ_tx /(num_snaps*(times-(convergence+1)));
        end
    end
    PDR_optimal_10p(fileid,1) = prctile(PDR_optimal(:,1),10);
    RU_optimal_90p(fileid,1) = prctile(optimal_RU(:,1),90);
    RU_optimal_mean(fileid, 1) = mean(optimal_RU,1);
    for  emp = [1,2,3,4,5,6]
        for step=[1,2,3,4,5,6,7,8,9,10,11]
            PDR_OLLA_10p(fileid, emp, step) = prctile(PDR_OLLA(emp, step, :),10);
            RU_OLLA_90p(fileid, emp, step) = prctile(olla_RU(emp, step, :),90);
            RU_OLLA_mean(fileid, emp, step) = mean(olla_RU(emp,step,:),3);
        end
        PDR_SOTA_10p(fileid,emp) = prctile(PDR_SOTA(emp,:),10);
        RU_SOTA_90p(fileid, emp) = prctile(SOTA_RU(emp,:),90);
        RU_SOTA_mean(fileid, emp) = mean(SOTA_RU(emp,:), 2);
    end

    sigma_stepsize = 0.05;
    sigma_count = 20;
    
    sigmas = zeros([sigma_count, 1]);
    random_normal = normrnd(0, 1, max_num_snaps, num_locs);
    PDR_predicted = zeros(sigma_count,num_locs);
    predicted_RU = zeros(sigma_count,num_locs);

    for sigma_index = 1:sigma_count
        sigma = sigma_stepsize * (sigma_index - 1);
        sigmas(sigma_index) = sigma;
    end
    for iter=1:sigma_count
        sigma = sigmas(iter);
        for loop = 1:num_locs
            predicted_failed_tx = 0;
            predicted_succ_tx = 0;
            predicted_PRBs_used=0;
            new_val_age = 0;
            mcs_col = optimal_MCS(1,loop) + 1;
            predicted_mcs_val=0;
            t=0;
            for i=1:num_snaps*times
                if(i>num_snaps)
                    t = floor(i / num_snaps);
                    i_for_others = i-(t*num_snaps);
                    if(i_for_others == 0)
                        i_for_others = num_snaps;
                        r1 = rand(max_num_snaps,1);
%                         random_normal = normrnd(0, 1, max_num_snaps, 1);
                    end
                else
                    i_for_others = i;
                end
                actual_snr = snr_complete(i_for_others, loop);
                predicted_snr = random_normal(i_for_others, loop) * sigma + (actual_snr);
%                 predicted_snr = (normrnd(0,1) * sigma) + actual_snr;

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
                if(t>convergence)
                    predicted_PRBs_used=predicted_PRBs_used + ( (ceil(message_size / num_bits_per_PRB(predicted_mcs_val,1))) / PRBs_per_slot);
                    if((r1(i_for_others,1) >= predicted_bler))
                        predicted_succ_tx = predicted_succ_tx + 1;
                        
                    else
                        predicted_failed_tx = predicted_failed_tx +1;
                    end
                end
            end
            
            PDR_predicted(iter, loop) = predicted_succ_tx / (num_snaps*(times-(convergence+1)));
            predicted_RU(iter, loop) = predicted_PRBs_used / (num_snaps*(times-(convergence+1)));
        end
    end
    for emp = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
       PDR_predicted_10p(fileid, emp) = prctile(PDR_predicted(emp,:),10);
       RU_predicted_90p(fileid, emp) = prctile(predicted_RU(emp,:),90);
       RU_predicted_mean(fileid, emp) = mean(predicted_RU(emp,:),2);
    end
end
save('new_plus15_Looong_corrected_urllc_1000cmps_59s','RU_optimal_mean','RU_SOTA_mean','RU_OLLA_mean','RU_predicted_mean', 'PDR_OLLA_10p', 'PDR_optimal_10p', 'PDR_SOTA_10p', 'RU_OLLA_90p','RU_optimal_90p','RU_SOTA_90p', 'PDR_predicted_10p', 'RU_predicted_90p');
