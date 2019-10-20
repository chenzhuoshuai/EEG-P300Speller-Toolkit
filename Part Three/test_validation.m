%% 判断模型在训练集上的表现

load('Subject_A_Train.mat');
Flashing=double(Flashing);
StimulusCode=double(StimulusCode);
screen=char('A','B','C','D','E','F',...
            'G','H','I','J','K','L',...
            'M','N','O','P','Q','R',...
            'S','T','U','V','W','X',...
            'Y','Z','1','2','3','4',...
            '5','6','7','8','9','_');
 reponses_code_train=ones(size(Flashing,1),12*15);
  for epoch=1:size(Flashing,1)
    seq=1;
    for n=2:size(Flashing,2)%对一个序列 做分析
        if Flashing(epoch,n)==0 & Flashing(epoch,n-1)==1
           reponses_code_train(epoch,seq)=StimulusCode(epoch,n-1);
            seq=seq+1;
        end
    end
  end
responses_seq_train=reshape(reponses_code_train',15300,1);
clear Flashing;
clear StimulusCode;
load('Subject_A_Test.mat');
Flashing=double(Flashing);
StimulusCode=double(StimulusCode);
  reponses_code_test=ones(size(Flashing,1),12*15);
  for epoch=1:size(Flashing,1)
    seq=1;
    for n=2:size(Flashing,2)%对一个序列 做分析
        if Flashing(epoch,n)==0 & Flashing(epoch,n-1)==1
           reponses_code_test(epoch,seq)=StimulusCode(epoch,n-1);
            seq=seq+1;
        end
    end
  end
 responses_seq_test=reshape(reponses_code_test',18000,1);

  