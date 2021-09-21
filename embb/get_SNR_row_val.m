function temp_snr_row_val = get_SNR_row_val(snr_observed)
    temp_snr_row_val = ((snr_observed + 9.5)*100)+1;
    temp_snr_row_val = round(temp_snr_row_val);
end