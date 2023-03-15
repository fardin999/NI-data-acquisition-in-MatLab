%%-------------------------------------------------------------------------
% This code has been developed by Fardin 
%
%
%%-----------------Code----------------------------------------------------
clear all;
close all;
clc;

% This code has 2 modes:
% 1: when you run it at first you have to define instrument
% to the MATLAB
% 2: in other runs no need.

%mode=1; % 1 or 2

timee=1 ;   % 7 Time
rate =20; % 65536 (Hz)

mode = "input 1 for calibration, 2 for Acquisition? ";
modee = input(mode);

prompt = "How many Data do you want to Acquise? ";
cylce = input(prompt);
mm=cylce;
cylce=cylce+1;
fixx=fix(cylce/3)+1;

n=1;
%figure
tiledlayout(fixx,3);
filename = 'voltage_Mat.xlsx';

while cylce >n ;

nexttile
   fprintf('Discovering Available Devices \n')
   d = daqlist;
   d(1, :) 
   
   fprintf('Instrument Defined \n')
   
   fprintf('Creating a DataAcquisition \n')
   
   dq = daq("ni")
   
   fprintf('Adding an Analog Input Channel \n')
   
   ch = addinput(dq,"cDAQ1Mod1", "ai0","Voltage")
   
   fprintf('Acquire Timestamped Data \n')
   
   
   clc;
   
   data = read(dq, seconds(timee));
   
   dq.Rate = rate;
   
   
   
   [data, startTime] = read(dq, seconds(timee));
   plot(data.Time, data.cDAQ1Mod1_ai0);
   
   freq = "Please input the Frequnecy: ";
   frequency(n) = input(freq);
   
   title (sprintf('%dth test %.1f frequency',n,frequency))
   ylabel("Voltage (V)");xlabel("Time (Sec)");
   
   if modee==1
     SP = "Please input the Static Pressure: ";
     Static_press(n) = input(SP);
   end


   voltage=data.cDAQ1Mod1_ai0(:);
   Voltage_AVE(n)=mean(voltage)
   Voltage_MIN(n)=max (voltage)
   Voltage_MAX(n)=min (voltage)
   
   voltage_Mat(:,n)=voltage;
   
   legend(sprintf('AVE= %.4f',Voltage_AVE))
   
   n=n+1;
   
%    continuee = "Are you Ready to Continue? Press Enter "
    modddeee = "Change Frequency and enter ";
    modddee = input(modddeee);
%    modde = "Are you Ready to Continue? Press Enter? ";
   if cylce >n;
     continuee = "Are you Ready to Continue? Press Enter ";
     print('Finished')
   elseif cylce == n;
       disp('Data Acquisition is Finished')
   end
%end    
end


rho=1.293; % air Density
for i=1:mm;
    
    Velocity_AVE(i)=sqrt(2*Static_press(i)/rho);
    
end
xlswrite(filename,voltage_Mat)
%------------ Curve Fit-----------------------
Trans_Velocity=transpose(Velocity_AVE);
Trans_Voltage=transpose(Voltage_AVE);

ft = fittype("fitter(x,a,b,n)");
fi = fit(Trans_Velocity,Trans_Voltage,ft,"StartPoint",[Voltage_AVE(1) Voltage_AVE(2) Voltage_AVE(3)])

figure(3)
plot(fi,Trans_Velocity,Trans_Voltage)
title ('Fit Curve');
ylabel("Voltage (V)");xlabel("Velocity (m/sec)");

MyCoeffs = coeffvalues(fi);
a=MyCoeffs(1)
b=MyCoeffs(2)
n=MyCoeffs(3)

save MyCoeffs;
save Trans_Velocity;
save Trans_Voltage;

