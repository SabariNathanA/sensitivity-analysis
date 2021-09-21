clear;

load('bler_snr_256QAM', 'bler_snr_256');
max_times = 500000; %Number of TTIs to simulate
num_snaps = 50000;%change for speed
max_num_snaps = 50000;%dont change for max randum number
times = floor(max_times/num_snaps);
convergence_times = floor(max_num_snaps/num_snaps);
% convergence_times=0;
BLER_exp = 0.1;

PRBs_per_slot = 25;
num_bits_per_slot = zeros(15);
num_bits_per_slot(1) = 0.1523 * 168 * PRBs_per_slot;
num_bits_per_slot(2) = 0.377 * 168 * PRBs_per_slot;
num_bits_per_slot(3) = 0.877 * 168 * PRBs_per_slot;
num_bits_per_slot(4) = 1.4766 * 168 * PRBs_per_slot;
num_bits_per_slot(5) = 1.9141 * 168 * PRBs_per_slot;
num_bits_per_slot(6) = 2.4063 * 168 * PRBs_per_slot;
num_bits_per_slot(7) = 2.7305 * 168 * PRBs_per_slot;
num_bits_per_slot(8) = 3.3223 * 168 * PRBs_per_slot;
num_bits_per_slot(9) = 3.9023 * 168 * PRBs_per_slot;
num_bits_per_slot(10) = 4.5234 * 168 * PRBs_per_slot;
num_bits_per_slot(11) = 5.1152 * 168 * PRBs_per_slot;
num_bits_per_slot(12) = 5.5547 * 168 * PRBs_per_slot;
num_bits_per_slot(13) = 6.2266 * 168 * PRBs_per_slot;
num_bits_per_slot(14) = 6.9141 * 168 * PRBs_per_slot;
num_bits_per_slot(15) = 7.4063 * 168 * PRBs_per_slot;
num_bits_per_slot = num_bits_per_slot(:,1);

processing_time = 2;
min_snr = bler_snr_256(1,1);
max_snr = bler_snr_256(size(bler_snr_256,1),1);

num_period = 1;
num_stepsize = 11;
sigma_count = 20;

PDR_optimal_wolla_10p = zeros(10,num_stepsize);
PDR_optimal_woutolla_10p = zeros(10,1);
Thr_optimal_wolla_10p = zeros(10,num_stepsize);
Thr_optimal_woutolla_10p = zeros(10,1);
PDR_OLLA_10p = zeros(10, num_period, num_stepsize);
Thr_OLLA_10p = zeros(10, num_period, num_stepsize);
PDR_predicted_10p = zeros(10, sigma_count); % to change for PP+OLLA
Thr_predicted_10p = zeros(10, sigma_count);
for fileid=1:1

    snr_complete = ones(50000,2601) * (-3.81);
    num_locs = size(snr_complete,2);
    optimal_MCS = zeros(num_snaps, num_locs);
    SRS_Periodicity_array = [2, 5, 10, 20, 40, 80];
    stepsize_array = [0.0000001,0.000001,0.00001,0.0001,0.001,0.01,0.1,1,2,3,4];
    num_stepsize = size(stepsize_array,2);
    num_period = size(SRS_Periodicity_array,2);
    for loop=1:num_locs
        for i=1:num_snaps
            lookup_snr_val = snr_complete(i,loop);
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
                    optimal_MCS(i,loop) = (k-1); %because column is one more than mcs val
                    break
                end
            end
        end
    end

    convergence = convergence_times;
    
    PDR_optimal = zeros(num_locs,num_stepsize);
    PDR_optimal_woutolla = zeros(num_locs,1);
    optimal_woutolla_throughput = zeros( num_locs,1);
    optimal_throughput = zeros( num_locs,num_stepsize);
    olla_througphut = zeros(num_period, num_stepsize, num_locs);
    PDR_OLLA = zeros(num_period ,num_stepsize,num_locs);
    r1 = rand(max_num_snaps,1);
    check=0;
    new_mcs_col=0;
    for iter=1:num_period
        inter_SRS_time = SRS_Periodicity_array(iter);
        for loop = 1:num_locs
            optimal_failed_tx = zeros(num_stepsize,1);
            optimal_failed_tx_woutolla = 0;
            optimal_succ_tx_wolla = zeros(num_stepsize,1);
            optimal_succ_tx_woutolla = 0;
            new_val_age = 0;
            optimal_bytes_wolla = zeros(num_stepsize,1);
            optimal_bytes_woutolla = 0;
            olla_bytes_wolla = zeros(num_stepsize,1);
            mcs_col = optimal_MCS(1,loop) + 1;
            olla_succ_tx = zeros(num_stepsize,1);
            olla_failed_tx = zeros(num_stepsize,1);
            delta_olla = zeros(num_stepsize,1);
            delta_opt_olla = zeros(num_stepsize,1);
            opt_offset = 0;
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
                if((check == 1) && (new_val_age >= processing_time))
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
                instant_rand = r1(i_for_others,1);
                optimal_mcs_val = optimal_MCS(i_for_others, loop);
                opt_bler_wout = bler_snr_256(snr_row_val, (optimal_mcs_val + 1));
                if(instant_rand >= opt_bler_wout && t>convergence)
                    optimal_bytes_woutolla = optimal_bytes_woutolla + num_bits_per_slot(optimal_mcs_val,1);
                    optimal_succ_tx_woutolla = optimal_succ_tx_woutolla + 1;
                else
                    optimal_failed_tx_woutolla = optimal_failed_tx_woutolla +1;
                end
                for step=1:num_stepsize
                    stepsize = stepsize_array(step);
                    random_value = rand();% for olla
                    if (random_value < (ceil(delta_opt_olla(step)) - delta_opt_olla(step)))
                        opt_offset = floor(delta_opt_olla(step));
                    else
                        opt_offset = ceil(delta_opt_olla(step));
                    end
                    opt_olla_mcs_val = (optimal_mcs_val + opt_offset);
                    if ((opt_olla_mcs_val) < 1 )
                        opt_olla_mcs_val = 1;
                    else
                        if ((opt_olla_mcs_val) > 15)
                            opt_olla_mcs_val = 15;
                        end
                    end
                    opt_olla_bler = bler_snr_256(snr_row_val, (opt_olla_mcs_val + 1));
                    if(instant_rand >= opt_olla_bler )
                        delta_opt_olla(step) = delta_opt_olla(step) + (BLER_exp * stepsize);
                        if (t>convergence)
                            optimal_succ_tx_wolla(step,1) = optimal_succ_tx_wolla(step,1) + 1;
                            optimal_bytes_wolla(step,1) = optimal_bytes_wolla(step,1) +  num_bits_per_slot(opt_olla_mcs_val,1);
                        end
                    else
                        delta_opt_olla(step) = delta_opt_olla(step) - ( (1-BLER_exp) * stepsize);
                        optimal_failed_tx(step,1) = optimal_failed_tx(step,1) +1;
                    end
                    %%%%%%%%%%%%%%%%%%%%
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
                            olla_bytes_wolla(step) = olla_bytes_wolla(step) +  num_bits_per_slot(olla_mcs_val,1);
                        end
                    else
                        delta_olla(step) = delta_olla(step) - ( (1-BLER_exp) * stepsize);
                        olla_failed_tx(step) = olla_failed_tx(step) +1;
                    end
                end
            end
            for step=1:num_stepsize
                PDR_OLLA(iter,step,loop) = olla_succ_tx(step) / (num_snaps*(times-(convergence+1)));
                olla_througphut(iter,step,loop) = olla_bytes_wolla(step) / (num_snaps*(times-(convergence+1)));
                PDR_optimal(loop, step) = optimal_succ_tx_wolla(step,1) /(num_snaps*(times-(convergence+1)));
                optimal_throughput(loop, step) = optimal_bytes_wolla(step,1) / (num_snaps*(times-(convergence+1)));
            end
            optimal_woutolla_throughput(loop) = optimal_bytes_woutolla / (num_snaps*(times-(convergence+1)));
            PDR_optimal_woutolla(loop,1) = optimal_succ_tx_woutolla /(num_snaps*(times-(convergence+1)));
        end
    end
    PDR_optimal_woutolla_10p(fileid,1) = prctile(PDR_optimal_woutolla(:,1),10);
    Thr_optimal_woutolla_10p(fileid,1) = prctile(optimal_woutolla_throughput(:,1),10);
    for  emp = [1:1:num_period]
        for step=[1:1:num_stepsize]
            PDR_OLLA_10p(fileid, emp, step) = prctile(PDR_OLLA(emp, step, :),10);
            PDR_optimal_wolla_10p(fileid,step) = prctile(PDR_optimal(:,step),10);
            Thr_optimal_wolla_10p(fileid,step) = prctile(optimal_throughput(:,step),10);
            Thr_OLLA_10p(fileid, emp, step) = prctile(olla_througphut(emp, step, :),10);
        end
    end
end
save('ollaperf_static_1KKpoints_embb_10cmps','PDR_optimal_wolla_10p','Thr_optimal_wolla_10p', 'PDR_optimal_woutolla_10p','Thr_optimal_woutolla_10p','PDR_OLLA_10p' ,'Thr_OLLA_10p');
%     sigma_stepsize = 0.5;
%     sigma_count = 20;
%     
%     sigmas = zeros([sigma_count, 1]);
%     random_normal = normrnd(0, 1, max_num_snaps, num_locs);
%     PDR_predicted = zeros(sigma_count,num_locs);
%     predicted_throughput = zeros(sigma_count,num_locs);
% 
%     for sigma_index = 1:sigma_count
%         sigma = sigma_stepsize * (sigma_index - 1);
%         sigmas(sigma_index) = sigma;
%     end
%     for iter=1:sigma_count
%         sigma = sigmas(iter);
%         for loop = 1:num_locs
%             predicted_failed_tx = 0;
%             predicted_succ_tx = 0;
%             pred_bytes=0;
%             new_val_age = 0;
%             mcs_col = optimal_MCS(1,loop) + 1;
%             predicted_mcs_val=0;
%             for i=1:num_snaps*times
%                 if(i>num_snaps)
%                     t = floor(i / num_snaps);
%                     i_for_others = i-(t*num_snaps);
%                     if(i_for_others == 0)
%                         i_for_others = num_snaps;
%                         r1 = rand(max_num_snaps,1);
%                     end
%                 else
%                     i_for_others = i;
%                 end
%                 actual_snr = snr_complete(i_for_others, loop);
%                 predicted_snr = random_normal(i_for_others, loop) * sigma + (actual_snr);
%                 
%                 if(predicted_snr >= max_snr)
%                     predicted_snr = max_snr;
%                 else
%                     if (predicted_snr <= min_snr)
%                         predicted_snr = min_snr;
%                     end
%                 end
%                 snr_row_val = round(((predicted_snr + 9.5)*100)+1);
%                 if(actual_snr >= max_snr)
%                     actual_snr = max_snr;
%                 else
%                     if (actual_snr <= min_snr)
%                         actual_snr = min_snr;
%                     end
%                 end
%                 actual_snr_row_val = round(((actual_snr + 9.5)*100)+1);
%                 for k=size(bler_snr_256,2):-1:2
%                     bler_val = bler_snr_256(snr_row_val,k);
%                     if(bler_val <= BLER_exp || k==2)
%                         predicted_mcs_val = (k-1);
%                         
%                         break
%                     end
%                 end
%                 predicted_bler = bler_snr_256(actual_snr_row_val, (predicted_mcs_val + 1));
%                 
%                 if(r1(i_for_others,1) >= predicted_bler)
%                     predicted_succ_tx = predicted_succ_tx + 1;
%                     pred_bytes=pred_bytes + num_bits_per_slot(predicted_mcs_val,1);
%                 else
%                     predicted_failed_tx = predicted_failed_tx +1;
%                 end
%             end
%             
%             PDR_predicted(iter, loop) = predicted_succ_tx / (num_snaps*times);
%             predicted_throughput(iter, loop) = pred_bytes/(num_snaps*times);
%         end
%     end
%     for emp = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
%        PDR_predicted_10p(fileid, emp) = prctile(PDR_predicted(emp,:),10);
%        Thr_predicted_10p(fileid, emp) = prctile(predicted_throughput(emp,:),10);
%     end
% end
% save('thresh1_embb_1000cmps', 'Thr_OLLA_threshold_10p', 'PDR_OLLA_threshold_10p', 'PDR_optimal_10p', 'Thr_optimal_10p');
% save('perfolla_embb_10cmps_lowsteps','Thr_OLLA_threshold_10p', 'Thr_olla_ms_10p','PDR_OLLA_threshold_10p', 'PDR_optimal_woutolla_10p', 'Thr_optimal_woutolla_10p','Thr_optimal_wolla_10p','PDR_optimal_wolla_10p')