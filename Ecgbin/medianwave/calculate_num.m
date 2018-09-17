function [I_num,II_num,V1_num,V2_num,V3_num,V4_num,V5_num,V6_num] = ...
    calculate_num(meas, percentage,I_num,II_num,V1_num,V2_num,V3_num,V4_num,V5_num,V6_num)
   if meas(1) >= percentage 
       I_num = I_num +1;
   end
   if meas(2) >= percentage
       II_num = II_num +1;
   end
   if meas(3) >= percentage
       V1_num = V1_num +1;
   end
   if meas(4) >= percentage
       V2_num = V2_num +1;   
   end
   if meas(5) >= percentage
       V3_num = V3_num +1;      
   end
   if meas(6) >= percentage
       V4_num = V4_num +1;   
   end
   if meas(7) >= percentage
       V5_num = V5_num +1;  
   end
   if meas(8) >= percentage
       V6_num = V6_num +1;
   end       
end