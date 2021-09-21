close all;
clear all;
clc;



% Global variables

tracklen = 5;
xlim = 25;                                                      
xlim_neg = -25;
ylim = 25;
ylim_neg = -25;
zlim = 5;
num_trials = ((xlim-xlim_neg) + 1) * (1 + (ylim - ylim_neg));
pragmatic_loss = 23.3; %db
noise_floor = -96; %dbm
% location = zeros(num_trials, 2);
antenna_gain = 2.15; %dbm
%%
disp('Running Sab scripts');
txPower_vals = [20];
carrier_freq_vals = [3.5e9];
c_freq = [3500];
speed_vals = [10000];
speed = [10];%in cmps

% txPower_vals = [24, 27, 30];
% carrier_freq_vals = [2.57e9, 3.5e9, 4.8e9];
% c_freq = [2570, 3500, 4800];
% speed_vals = [10000, 3333, 1000, 333, 200, 100];
% speed = [10, 30, 100, 300, 500, 1000];


for pow = 1:size(txPower_vals,2)
    for fc = 1:size(carrier_freq_vals,2)
        for speed_index = 1:size(speed_vals,2)
            txPower = txPower_vals(pow);
            eirp = txPower+antenna_gain; %dbm
            carrier_freq = carrier_freq_vals(fc);
            samples_per_meter = speed_vals(speed_index);
            num_snaps = tracklen * samples_per_meter;
            x='channel_quality/';
            a='cc_50grid_5mhzbw_';
            b=num2str(txPower);
            c='dB_';
            di = c_freq(fc);
            d=num2str(di);
            e='MHz_';
            fi=speed(speed_index);
            f=num2str(fi);
            g='cmps.mat';
            filename = [x a b c d e f];
            disp(filename);
            
            rx_pow_db = zeros(num_snaps,1);
            txh=linspace(1,5,1).';
            
            
            
            %             loop = 0;
            parfor ii=1:10
                loop = 0;
                snr_dB = zeros(num_snaps,num_trials);
                s = qd_simulation_parameters;
                s.show_progress_bars = 0;                           % power Disable progress bars
                s.center_frequency = carrier_freq;                  % Set center frequency
                s.sample_density = 2.5;                             % Number of samples per half wavelength 1.2 for single mobility and 2.5 for dual mobility
                
                l = qd_layout( s );                                 % New layout
                
                t = qd_track( 'linear',0,0);                        % Static track facing north-east
                %t.initial_position = [0;0;3];                      % 6 m height
                t.name = 'BS';                                      % Assign unique name
                
                abc=qd_arrayant( 'omni' ) ;
                
                
                l.tx_track(1,1) = t;                                % Assign static tx track
                l.tx_array = abc;
                t.initial_position = [0;0;6];
                for x = xlim_neg:xlim                       %for every position of UE, we obtain the throughput
                    fprintf('%d ',x)
                    for y = ylim_neg:ylim
                        xpos = x;
                        ypos = y;
                        loop = loop + 1;
                        
                        
                        zpos = 1.5;                                     % UE Position
                        %                     location(loop,1) = xpos;
                        %                     location(loop,2) = ypos;
                        l.rx_track = qd_track('circular',tracklen,pi/2);
                        l.rx_track.interpolate_positions(samples_per_meter);    % Number of positions for UE
                        % this helps in finding
                        % new samples.
                        l.rx_position = [xpos;ypos;zpos];
                        l.set_scenario('QuaDRiGa_Industrial_NLOS');
                        
                        p = l.init_builder;                            % Generate small-scale-fading
                        
                        p.gen_ssf_parameters;                          % Channel Coefficients
                        for i=2:size(p.fbs_pos,2)
                            
                            if p.fbs_pos(1,i) > 25
                                p.fbs_pos(1,i) = randi([1,25],1,1);
                            end
                            if p.fbs_pos(1,i) < -25
                                p.fbs_pos(1,i) = randi([-25,1],1,1);
                            end
                            if p.fbs_pos(2,i) > 25
                                p.fbs_pos(1,i) = randi([1,25],1,1);
                            end
                            if p.fbs_pos(2,i) < -25
                                p.fbs_pos(1,i) = randi([-25,1],1,1);
                            end
                            if p.fbs_pos(3,i) > 5
                                p.fbs_pos(3,i) = rand*5;
                            end
                            if p.fbs_pos(3,i) < 0
                                p.fbs_pos(3,i) = rand*5;
                            end
                            
                            if p.lbs_pos(1,i) > 25
                                p.lbs_pos(1,i) = randi([1,25],1,1);
                            end
                            if p.lbs_pos(1,i) < -25
                                p.lbs_pos(1,i) = randi([-25,1],1,1);
                            end
                            if p.lbs_pos(2,i) > 25
                                p.lbs_pos(2,i) = randi([1,25],1,1);
                            end
                            if p.lbs_pos(2,i) < -25
                                p.lbs_pos(2,i) = randi([-25,1],1,1);
                            end
                            if p.lbs_pos(3,i) > 5
                                p.lbs_pos(3,i) = rand*5;
                            end
                            if p.lbs_pos(3,i) < 0
                                p.lbs_pos(3,i) = rand*5;
                            end
                        end
                        c = p.get_channels;
                        
                        
                        [sf,kf] = p.get_sf_profile (l.rx_track);
                        kf_db = 10*log10(kf);
                        frsp = c.fr(5e6,1);
                        rx_pow_dbm = squeeze ( abs(frsp())).^2 ;
                        rx_pow_db = 10*log10(squeeze ( abs(frsp())).^2 ); %actually dbm
                        temp = (size(snr_dB(:,1),1)) - size(rx_pow_db(:,1),1);
                        if (temp >0 )
                            for chumma=1:temp
                                rx_pow_db(size(rx_pow_db)+1) = rx_pow_db(1);
                            end
                        end
                        snr_dB(:,loop) = rx_pow_db + eirp - pragmatic_loss - noise_floor  ; % received power-noise power+transmitted power-pragmatic error
                    end
                end
                %             save(filename);
                parsave(filename,ii,snr_dB);
                fprintf('\n');
            end
        end
    end
end





