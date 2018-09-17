function  ecg = ecg_calib_sign(ecg,QRS)


sign = mean(ecg(QRS));
if sign <0

    ecg = -ecg;
end