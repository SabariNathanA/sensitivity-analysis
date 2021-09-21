clear;

max_num_snaps = 50000;%dont change for max randum number
% snr_complete = zeros(max_num_snaps, num_locs);

load('bler_snr_256QAM', 'bler_snr_256');
max_times = 500000; %Number of samples
num_snaps =50000;%change for speed
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

processing_time = 0;

times = floor(max_times/num_snaps);
convergence_times = 1;



min_snr = bler_snr_256(1,1);
max_snr = bler_snr_256(size(bler_snr_256,1),1);


num_period = 6;
num_stepsize = 9;
sigma_count = 20;
PDR_optimal_wolla_10p = zeros(10,num_stepsize);
PDR_optimal_woutolla_10p = zeros(10,1);
PDR_SOTA_10p = zeros(10, num_period);
PDR_OLLA_threshold_10p = zeros(10, num_period, num_stepsize);
Thr_optimal_wolla_10p = zeros(10,num_stepsize);
Thr_optimal_woutolla_10p = zeros(10);
Thr_SOTA_10p = zeros(10, num_period);
Thr_OLLA_threshold_10p = zeros(10, num_period, num_stepsize);
PDR_predicted_10p = zeros(10, sigma_count);
Thr_predicted_10p = zeros(10, sigma_count);
Thr_olla_ms_10p = zeros(10, num_period, num_stepsize);
parfor fileid=1:10
    a= 'C:\Users\AnbalaganSN\Documents\Sabari\MATLAB_src\channel_quality/cc_50grid_5mhzbw_20dB_3500MHz_1000cmps_';
    z='.mat';
    filename = [a num2str(fileid) z];
    snr_complete = load(filename).snr_dB;
    snr_complete = snr_complete + 10;
    num_locs = size(snr_complete,2);
    optimal_MCS = zeros(num_snaps, num_locs);
    SRS_Periodicity_array = [2, 5, 10, 20, 40, 80];
    stepsize_array = [0.0000001,0.000001,0.00001,0.0001,0.001,0.01,0.1,1,2,4];
%     stepsize_array = [0.0001,0.00025, 0.0005,0.00075,0.001,0.0025,0.005,0.0075,0.01];
%     stepsize_array = [0.0000001,0.0000002,0.0000003,0.0000004,0.0000005,0.0000006,0.0000007, 0.0000008,0.0000009,0.000001]
    num_stepsize = size(stepsize_array,2);
    num_period = size(SRS_Periodicity_array,2);
%     Thr_perf = zeros(num_locs,1);
    for loop=1:num_locs
        perf_bytes=0;
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
            snr_row_val = get_SNR_row_val(lookup_snr_val);
            for k=size(bler_snr_256,2):-1:2
                bler_val = bler_snr_256(snr_row_val,k);
                if(bler_val <= BLER_exp || k==2)
                    optimal_MCS(i_for_others,loop) = (k-1);
                    break
                end
            end
        end
    end
    convergence = convergence_times;
    PDR_optimal_woutolla = zeros(num_locs,1);
    PDR_SOTA = zeros(num_period,num_locs);
    optimal_woutolla_throughput = zeros( num_locs,1);
    SOTA_throughput = zeros( num_period, num_locs);
    olla_thr_ms = zeros(num_period, num_stepsize, num_locs);
    PDR_OLLA = zeros(num_period ,num_stepsize,num_locs);
    r1 = rand(max_num_snaps,1);
    check=0;
    new_mcs_col=0;
    for iter=1:num_period
        inter_SRS_time = SRS_Periodicity_array(iter);
        for loop = 1:num_locs
            sota_failed_tx = 0;
            optimal_failed_tx_woutolla = 0;
            sota_succ_tx = 0;
            optimal_succ_tx_woutolla = 0;
            new_val_age = 0;
            sota_bytes = 0;
            optimal_bytes_woutolla = 0;
            olla_bytes = zeros(num_stepsize,1);
            mcs_col = optimal_MCS(1,loop) + 1;
            olla_succ_tx = zeros(num_stepsize,1);
            olla_failed_tx = zeros(num_stepsize,1);
            delta_olla = zeros(num_stepsize,1);
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
                snr_row_val = get_SNR_row_val(lookup_snr_val);
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
                opt_bler_wout = bler_snr_256(snr_row_val, (optimal_mcs_val + 1));
                if(instant_rand >= opt_bler_wout && t>convergence)
                    optimal_bytes_woutolla = optimal_bytes_woutolla + num_bits_per_slot(optimal_mcs_val,1);
                    optimal_succ_tx_woutolla = optimal_succ_tx_woutolla + 1;
                else
                    optimal_failed_tx_woutolla = optimal_failed_tx_woutolla +1;
                end
                for step=1:num_stepsize
                    stepsize = stepsize_array(step);
                    random_value = rand();% fo
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
%                     if(delta_olla(step) < -1)
%                         delta_olla(step) = -1;
%                     else
%                         if (delta_olla(step) >1)
%                             delta_olla(step) = 1;
%                         end
%                     end
                    
                end
            end
            for step=1:num_stepsize
                PDR_OLLA(iter,step,loop) = olla_succ_tx(step) / (num_snaps*(times-(convergence+1)));
                olla_thr_ms(iter,step,loop) = olla_bytes(step) / (num_snaps*(times-(convergence+1)));
            end
            optimal_woutolla_throughput(loop) = optimal_bytes_woutolla / (num_snaps*(times-(convergence+1)));
            SOTA_throughput( iter, loop) = sota_bytes / (num_snaps*(times-(convergence+1)));
            PDR_SOTA(iter, loop) = sota_succ_tx / (num_snaps*(times-(convergence+1)));
            PDR_optimal_woutolla(loop,1) = optimal_succ_tx_woutolla /(num_snaps*(times-(convergence+1)));
        end
    end
    PDR_optimal_woutolla_10p(fileid,1) = prctile(PDR_optimal_woutolla(:,1),10);
    Thr_optimal_woutolla_10p(fileid,1) = prctile(optimal_woutolla_throughput(:,1),10);
    for  emp = [1,2,3,4,5,6]
        for step=[1,2,3,4,5,6,7,8,9]
            PDR_OLLA_threshold_10p(fileid, emp, step) = prctile(PDR_OLLA(emp, step, :),10);
           Thr_olla_ms_10p(fileid, emp, step) = prctile(olla_thr_ms(emp, step, :),10);
        end
        PDR_SOTA_10p(fileid,emp) = prctile(PDR_SOTA(emp,:),10);
        Thr_SOTA_10p(fileid, emp) = prctile(SOTA_throughput(emp,:),10);
    end
end
% save('thresh1_embb_1000cmps', 'Thr_OLLA_threshold_10p', 'PDR_OLLA_threshold_10p', 'PDR_optimal_10p', 'Thr_optimal_10p');
save('perfolla_embb_10cmps_lowsteps','Thr_olla_ms_10p','PDR_OLLA_threshold_10p', 'PDR_optimal_woutolla_10p', 'Thr_optimal_woutolla_10p','Thr_optimal_wolla_10p','PDR_optimal_wolla_10p')