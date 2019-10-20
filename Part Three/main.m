%% 训练数据预处理
 clc;clear all
load('Subject_A_Train.mat');
window=240*0.7; % window after stimulus (1s)
channel_select=1:64; % only using Cz for analysis and plots
% size(channel_select,2);
fprintf(1, ' number of channel select：64 \n' )
% covert to double precision %转换精度
Signal=double(Signal);
Flashing=double(Flashing);
StimulusCode=double(StimulusCode);
StimulusType=double(StimulusType);
% 6 X 6 onscreen matrix
screen=char('A','B','C','D','E','F',...
            'G','H','I','J','K','L',...
            'M','N','O','P','Q','R',...
            'S','T','U','V','W','X',...
            'Y','Z','1','2','3','4',...
            '5','6','7','8','9','_');
 responses=ones(12*15,window,64);
 responses_total=ones(85,12*15,window,64);
 % 如果在此处 做信道选择 程序会比较快
% for each character epoch
for epoch=1:size(Signal,1)
    seq=1;
    for n=2:size(Signal,2)%对一个序列 做分析
        if Flashing(epoch,n)==0 && Flashing(epoch,n-1)==1
            %找到闪烁时间点 提取出240*0.7的脑电信号序列片
            responses(seq,:,:)=Signal(epoch,n-24:n+window-25,:);% 设置窗口为0s-0.7s 波峰出现在300-350ms
            seq=seq+1;
        end
    end
    responses_total(epoch,:,:,:)=responses;
end
fprintf(1, ' 提取信号片段完成 \n' )
%% 做信道选择
% responses_total_selected=[];
for k=1:size(channel_select,2)
    responses_total_selected(:,:,:,k)=responses_total(:,:,:,channel_select(k));
end
%% 进行滤波 使用的是cheby2 10阶 10Hz 低通滤波器
for epoch=1:85
    for i=1:(12*15)
            for k=1:size(channel_select,2)
            [responses_total_selected_filtered(epoch,i,:,k)]=cheby2filter(10,60,10,responses_total_selected(epoch,i,:,k));
            end
    end
end
fprintf(1, ' 滤波完成 \n' )
%% 进行每个四个取一次均值的滑动平均
[epoch_num,seq_num,sig_length,chan_num]=size(responses_total_selected_filtered);
downsampled_responses_total_selected_filtered=ones(epoch_num,seq_num,sig_length/6,chan_num);%将采样频率降为40Hz 40Hz 比较理想
for i=1:85
    for j=1:(12*15)
            for channel=1:chan_num
                for h=1:sig_length/6
                   downsampled_responses_total_selected_filtered(i,j,h,channel)= (responses_total_selected_filtered(i,j,h*6,channel)+responses_total_selected_filtered(i,j,h*6-1,channel)+responses_total_selected_filtered(i,j,h*6-2,channel)+responses_total_selected_filtered(i,j,h*6-3,channel)...
                      +responses_total_selected_filtered(i,j,h*6-4,channel)+responses_total_selected_filtered(i,j,h*6-5,channel))/6;
                end
            end
        end
end
fprintf(1, ' 滑动平均完成 \n' )
%% 进行合并 生成binary训练集
%信道合并 %小心排序方式是否按顺序
[a,b,d,e]=size( downsampled_responses_total_selected_filtered);
sig_channel_combined=ones(a,b,d*e);
for i=1:a
    for j=1:b
            for h=1:e
             sig_channel_combined(i,j,(((h-1)*d)+1):h*d)=downsampled_responses_total_selected_filtered(i,j,:,h);      
            end
    end 
end
% 合并85次 binary classification 训练集生成 
biclass_trainset=ones(a*b,d*e);
for i=1:a
    for j=1:b
        biclass_trainset(j+180*(i-1),:)=sig_channel_combined(i,j,:);   
    end 
end 
fprintf(1, ' 生成二分类训练集完成 \n' )
% 生成二分类的标签
% for each character epoch
for epoch=1:size(StimulusType,1)
    seq=1;
    for n=2:size(StimulusType,2)%对一个序列 做分析
        if Flashing(epoch,n)==0 & Flashing(epoch,n-1)==1
              label(seq,:)=StimulusType(epoch,n-1);
            seq=seq+1;
        end
    end
    label_total(epoch,:,:)=label;
end
%将85*180的向量变为 (85*180)*1的labelset
biclass_labelset=reshape(label_total',85*180,1); %记得进行转置
%将0替换为-1
for i=1:size(biclass_labelset,1)
    if biclass_labelset(i)==1
        biclass_labelset(i)=1;
    else
        biclass_labelset(i)=-1;
    end
end
fprintf(1, ' 标签集完成 \n' )  
