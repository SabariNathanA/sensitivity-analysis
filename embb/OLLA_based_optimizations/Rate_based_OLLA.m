% We decide to go one level higher if the (Rate_8 * (1-BLER)) is lower than
% Rate_9 * (1-BLER)).



clear;
load('bler_snr_256QAM', 'bler_snr_256');

BLER_exp = 0.1;
PRBs_per_slot = 25;


num_bits_per_slot = zeros(15,1);
num_bits_per_slot(1,1) = 0.1523 * 168 * PRBs_per_slot;
num_bits_per_slot(2,1) = 0.377 * 168 * PRBs_per_slot;
num_bits_per_slot(3,1) = 0.877 * 168 * PRBs_per_slot;
num_bits_per_slot(4,1) = 1.4766 * 168 * PRBs_per_slot;
num_bits_per_slot(5,1) = 1.9141 * 168 * PRBs_per_slot;
num_bits_per_slot(6,1) = 2.4063 * 168 * PRBs_per_slot;
num_bits_per_slot(7,1) = 2.7305 * 168 * PRBs_per_slot;
num_bits_per_slot(8,1) = 3.3223 * 168 * PRBs_per_slot;
num_bits_per_slot(9,1) = 3.9023 * 168 * PRBs_per_slot;
num_bits_per_slot(10,1) = 4.5234 * 168 * PRBs_per_slot;
num_bits_per_slot(11,1) = 5.1152 * 168 * PRBs_per_slot;
num_bits_per_slot(12,1) = 5.5547 * 168 * PRBs_per_slot;
num_bits_per_slot(13,1) = 6.2266 * 168 * PRBs_per_slot;
num_bits_per_slot(14,1) = 6.9141 * 168 * PRBs_per_slot;
num_bits_per_slot(15,1) = 7.4063 * 168 * PRBs_per_slot;


processing_time = 0;
speed = [10, 30, 100, 300, 1000]; % 0.1, 0.3, 1, 3, 10
snaps = [50000, 16665, 5000, 1665, 500];
%%%%%%%%%% Variables %%%%%%%%%%%%%%%%%%%%
max_times = 500000; % Number of TTIs to simulate
chosen_speed = 1;
disp("running for "+ speed(chosen_speed) +"cm/s");
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
max_num_snaps = snaps(1); % This value is required to calculate how many TTIs we ignore in the beginning of the simulation
num_snaps = snaps(chosen_speed); 
times = floor(max_times/num_snaps);
convergence_times = round(max_num_snaps/num_snaps);

min_snr = bler_snr_256(1,1);
max_snr = bler_snr_256(size(bler_snr_256,1),1);

%%%%%%%%%%%%%% Check %%%%%%%%%%%%%%%%%
num_period = 6;
num_stepsize = 11;
sigma_count = 10;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PDR_PP_10p = zeros(10,1);
PDR_PP_OLLA_10p = zeros(10,1);
PDR_SOTA_10p = zeros(10, num_period);
PDR_OLLA_10p = zeros(10, num_period, num_stepsize);
PDR_mod_OLLA_10p = zeros(10, num_period, num_stepsize);
Thr_PP_10p = zeros(10,1);
Thr_PP_OLLA_10p = zeros(10,1);
Thr_SOTA_10p = zeros(10, num_period);
Thr_OLLA_10p = zeros(10, num_period, num_stepsize);
Thr_mod_OLLA_10p = zeros(10, num_period, num_stepsize);
PDR_predicted_10p = zeros(10, sigma_count); 
Thr_predicted_10p = zeros(10, sigma_count);
PDR_mod_predicted_10p = zeros(10, sigma_count);
Thr_mod_predicted_10p = zeros(10, sigma_count);

for fileid=1:1
    a= 'C:\Users\AnbalaganSN\Documents\Sabari\MATLAB_src\channel_quality/cc_50grid_5mhzbw_20dB_3500MHz_';
    c = 'cmps_';
    z='.mat';
    filename = [a num2str(speed(chosen_speed)) c num2str(fileid) z];
    snr_complete = load(filename).snr_dB;
    snr_complete = snr_complete + 10;
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
            for k=size(bler_snr_256,2):-1:2
                bler_val = bler_snr_256(snr_row_val,k);
                if(bler_val <= BLER_exp || k==2)
                    optimal_MCS(i_for_others,loop) = (k-1); %because column is one more than mcs val
                     break
                end
            end
        end
    end
    disp('first over')
    convergence = convergence_times;
    PDR_optimal = zeros(num_locs,1);
    PDR_mod_optimal = zeros( num_locs,1);
    PDR_SOTA = zeros(num_period,num_locs);    
    PDR_OLLA = zeros(num_period ,num_stepsize,num_locs);
    optimal_throughput = zeros( num_locs,1);
    mod_optimal_throughput = zeros( num_locs,1);
    SOTA_throughput = zeros( num_period, num_locs);
    olla_throughput = zeros(num_period, num_stepsize, num_locs);
    r1 = rand(max_num_snaps,1);
    check=0;
    new_mcs_col=0;
    for iter=1:1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        inter_SRS_time = SRS_Periodicity_array(iter);
        
        for loop = 1:num_locs
            sota_failed_tx = 0;
            optimal_failed_tx = 0;
            sota_succ_tx = 0;
            optimal_succ_tx = 0;
            mod_optimal_succ_tx = 0;
            mod_optimal_failed_tx = 0;
            sota_bytes = 0;
            optimal_bytes = 0;
            mod_optimal_bytes = 0;
            olla_bytes = zeros(num_stepsize,1);
            mcs_col = optimal_MCS(1,loop) + 1;
            olla_succ_tx = zeros(num_stepsize,1);
            olla_failed_tx = zeros(num_stepsize,1);
            delta_olla = zeros(num_stepsize,1);
            new_val_age = 0;
            offset=0;
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
                new_val_age = new_val_age + 1;
                lookup_snr_val = snr_complete(i_for_others,loop);
                if(lookup_snr_val >= max_snr)
                    lookup_snr_val = max_snr;
                else
                    if (lookup_snr_val <= min_snr)
                        lookup_snr_val = min_snr;
                    end
                end
                snr_row_val = round(((lookup_snr_val + 9.5)*100)+1);
                sota_mcs_val = mcs_col - 1;
                sotabler = bler_snr_256(snr_row_val, (sota_mcs_val + 1));
                instant_rand = r1(i_for_others,1);
                if(instant_rand >= sotabler && t>convergence)
                    sota_bytes = sota_bytes + num_bits_per_slot(sota_mcs_val,1);
                    sota_succ_tx = sota_succ_tx + 1;
                else
                    sota_failed_tx = sota_failed_tx +1;
                end
                
                optimal_mcs_val = optimal_MCS(i_for_others, loop);
                opt_bler = bler_snr_256(snr_row_val, (optimal_mcs_val + 1));
                if(optimal_mcs_val < 15) 
                    high_mcs = optimal_mcs_val + 1;
                else
                    high_mcs = optimal_mcs_val;
                end
                high_mcs_bler = bler_snr_256(snr_row_val, (high_mcs + 1));
                if(instant_rand >= opt_bler && t>convergence)
                    optimal_bytes = optimal_bytes + num_bits_per_slot(optimal_mcs_val,1);
                    optimal_succ_tx = optimal_succ_tx + 1;
                else
                    optimal_failed_tx = optimal_failed_tx +1;
                end
                if( ((1-opt_bler)*num_bits_per_slot(optimal_mcs_val)) > ((1-high_mcs_bler)*num_bits_per_slot(high_mcs)))
                    mod_optimal_mcs = optimal_mcs_val;
                    mod_optimal_bler = opt_bler;
                else
                    mod_optimal_mcs = high_mcs;
                    mod_optimal_bler = high_mcs_bler;
                end
                if(instant_rand >= mod_optimal_bler && t>convergence)
                    mod_optimal_bytes = mod_optimal_bytes + num_bits_per_slot(mod_optimal_mcs,1);
                    mod_optimal_succ_tx = mod_optimal_succ_tx + 1;
                else
                    mod_optimal_failed_tx = mod_optimal_failed_tx +1;
                end

                for step=1:num_stepsize
                    stepsize = stepsize_array(step);
                    random_value = rand();% for olla
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
                    ollabler = bler_snr_256(snr_row_val, (olla_mcs_val + 1));
                    if(instant_rand >= ollabler )
                        delta_olla(step) = delta_olla(step) + (BLER_exp * stepsize);
                        if (t>convergence)
                            olla_succ_tx(step) = olla_succ_tx(step) + 1;
                            olla_bytes(step) = olla_bytes(step) +  num_bits_per_slot(olla_mcs_val,1);
                        end
                    else
                        delta_olla(step) = delta_olla(step) - ( (1-BLER_exp) * stepsize);
                        olla_failed_tx(step) = olla_failed_tx(step) +1;
                    end
                end
            end
            for step=1:num_stepsize
                PDR_OLLA(iter,step,loop) = olla_succ_tx(step) / (num_snaps*(times-(convergence+1)));
                olla_throughput(iter,step,loop) = olla_bytes(step) / (num_snaps*(times-(convergence+1)));
            end
            optimal_throughput(loop,1) = optimal_bytes / (num_snaps*(times-(convergence+1)));
            SOTA_throughput( iter, loop) = sota_bytes / (num_snaps*(times-(convergence+1)));
            PDR_SOTA(iter, loop) = sota_succ_tx / (num_snaps*(times-(convergence+1)));
            PDR_optimal(loop,1) = optimal_succ_tx /(num_snaps*(times-(convergence+1)));
            PDR_mod_optimal(loop,1) = mod_optimal_succ_tx / (num_snaps*(times-(convergence+1)));
            mod_optimal_throughput(loop,1) = mod_optimal_bytes / (num_snaps*(times-(convergence+1)));            
        end

    end
    PDR_PP_10p(fileid,1) = prctile(PDR_optimal(:,1),10);
    Thr_PP_10p(fileid,1) = prctile(optimal_throughput(:,1),10);
    PDR_PP_OLLA_10p(fileid,1) = prctile(PDR_mod_optimal(:,1),10);
    Thr_PP_OLLA_10p(fileid,1) = prctile(mod_optimal_throughput(:,1),10);
    
    for  emp =[1,2,3,4,5,6]
        for step= [1,2,3,4,5,6,7,8,9,10,11]
            PDR_OLLA_10p(fileid, emp, step) = prctile(PDR_OLLA(emp, step, :),10);
            Thr_OLLA_10p(fileid, emp, step) = prctile(olla_throughput(emp, step, :),10);
        end
        PDR_SOTA_10p(fileid,emp) = prctile(PDR_SOTA(emp,:),10);
        Thr_SOTA_10p(fileid, emp) = prctile(SOTA_throughput(emp,:),10);
    end
    
        disp('second over')
    sigma_stepsize = 0.5;
    sigma_count = 20;    
    sigmas = zeros([sigma_count, 1]);
    random_normal = normrnd(0, 1, max_num_snaps, num_locs);
    PDR_predicted = zeros(sigma_count,num_locs);
    predicted_throughput = zeros(sigma_count,num_locs);
    PDR_mod_predicted = zeros(sigma_count,num_locs);
    mod_predicted_throughput = zeros(sigma_count,num_locs);

    for sigma_index = 1:sigma_count
        sigma = sigma_stepsize * (sigma_index - 1);
        sigmas(sigma_index) = sigma;
    end
    for iter=1:sigma_count
        sigma = sigmas(iter);
        for loop = 1:num_locs
            predicted_failed_tx = 0;
            predicted_succ_tx = 0;
            pred_bytes=0;
            mod_predicted_failed_tx = 0;
            mod_predicted_succ_tx = 0;
            mod_pred_bytes=0;
            up_pred_bytes = 0;
            down_pred_bytes=0;
            new_val_age = 0;
            mcs_col = optimal_MCS(1,loop) + 1;
            predicted_mcs_val=0;
            mod_pred_one_up_mcs = 0;
            mod_pred_one_down_mcs = 0;
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
                actual_snr = snr_complete(i_for_others, loop);
                predicted_snr = random_normal(i_for_others, loop) * sigma + (actual_snr);
                
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
                for k=size(bler_snr_256,2):-1:2
                    bler_val = bler_snr_256(snr_row_val,k);
                    if(bler_val <= BLER_exp || k==2)
                        predicted_mcs_val = (k-1);
                        
                        break
                    end
                end
               
                if(t>convergence)
                    predicted_bler = bler_snr_256(actual_snr_row_val, (predicted_mcs_val + 1));%transmission
                    if(r1(i_for_others,1) >= predicted_bler)
                        predicted_succ_tx = predicted_succ_tx + 1;
                        pred_bytes=pred_bytes + num_bits_per_slot(predicted_mcs_val,1);
                    else
                        predicted_failed_tx = predicted_failed_tx +1;
                    end
                    
                    pred_bler = bler_snr_256(snr_row_val, (predicted_mcs_val + 1));% for comparison
                    if(predicted_mcs_val==15)
                        mod_pred_one_up_mcs = 15;
                    else
                        mod_pred_one_up_mcs = predicted_mcs_val+1;
                    end
                    up_predicted_bler = bler_snr_256(snr_row_val, (mod_pred_one_up_mcs + 1));
                    
                    if(predicted_mcs_val==1)
                        mod_pred_one_down_mcs = 1;
                    else
                        mod_pred_one_down_mcs = predicted_mcs_val-1;
                    end
                    down_predicted_bler = bler_snr_256(snr_row_val, (mod_pred_one_down_mcs + 1));
                    
                    up_pred_bytes = (1-up_predicted_bler)*num_bits_per_slot(mod_pred_one_up_mcs,1);
                    down_pred_bytes= (1-down_predicted_bler)* num_bits_per_slot(mod_pred_one_down_mcs,1);
                    actual_pred_bytes = (1-pred_bler) * num_bits_per_slot(predicted_mcs_val,1);
                    
                    instant_max= max([up_pred_bytes, actual_pred_bytes, down_pred_bytes]);
                    if(instant_max == up_pred_bytes)
                        mod_pred_mcs = mod_pred_one_up_mcs;
                    else
                        if(instant_max == actual_pred_bytes)
                             mod_pred_mcs = predicted_mcs_val;
                        else
                            mod_pred_mcs = mod_pred_one_down_mcs;
                            
                        end
                    end
                    mod_pred_bler = bler_snr_256(actual_snr_row_val, (mod_pred_mcs + 1)); %transmission
                    if(r1(i_for_others,1) >= mod_pred_bler)
                        mod_predicted_succ_tx = mod_predicted_succ_tx + 1;
                        mod_pred_bytes=mod_pred_bytes + num_bits_per_slot(mod_pred_mcs,1);
                    else
                        mod_predicted_failed_tx = mod_predicted_failed_tx +1;
                    end
                end
            end
            
            PDR_predicted(iter, loop) = predicted_succ_tx / (num_snaps*(times-(convergence+1)));
            predicted_throughput(iter, loop) = pred_bytes/(num_snaps*(times-(convergence+1)));
            
            PDR_mod_predicted(iter, loop) = mod_predicted_succ_tx / (num_snaps*(times-(convergence+1)));
            mod_predicted_throughput(iter, loop) = mod_pred_bytes/(num_snaps*(times-(convergence+1)));
            
        end
    end
    for emp = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
       PDR_predicted_10p(fileid, emp) = prctile(PDR_predicted(emp,:),10);
       Thr_predicted_10p(fileid, emp) = prctile(predicted_throughput(emp,:),10);
       PDR_mod_predicted_10p(fileid, emp) = prctile(PDR_mod_predicted(emp,:),10);
       Thr_mod_predicted_10p(fileid, emp) = prctile(mod_predicted_throughput(emp,:),10);      
    end
end
save('Rate_based_PPandPOLLA_BLER_10_embb_10cmps', 'Thr_PP_10p','Thr_PP_OLLA_10p','PDR_PP_OLLA_10p','PDR_PP_10p','Thr_SOTA_10p', 'PDR_SOTA_10p', 'PDR_OLLA_10p', 'Thr_OLLA_10p','PDR_predicted_10p','Thr_predicted_10p','PDR_mod_predicted_10p','Thr_mod_predicted_10p');