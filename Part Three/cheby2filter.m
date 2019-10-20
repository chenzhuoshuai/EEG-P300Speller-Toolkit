function [y0]=cheby2filter(N,Rs,fp,signal)
Wn=2*fp/240;
[C2b,C2a]=cheby2(N,Rs,Wn,'low'); % 调用MATLAB cheby2函数快速设计低通滤波器  
[C2H,C2W]=freqz(C2b,C2a); % 绘制频率响应曲线  
y0=filter(C2b,C2a,signal); % 进行低通滤波  
%C2y=fft(C2f,len);  % 对滤波后信号做len点FFT变换  
end
% N=0; % 阶数  
% Fp=50; % 通带截止频率50Hz  
% Fc=100; % 阻带截止频率100Hz  
% Rp=1; % 通带波纹最大衰减为1dB  
% Rs=60; % 阻带衰减为60dB  