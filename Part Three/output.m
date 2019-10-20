load('output_final_test_B.mat')
load('Subject_B_Test.mat')
% convert to double precision
Signal=double(Signal);
Flashing=double(Flashing);
StimulusCode=double(StimulusCode);
%StimulusType=double(StimulusType);
totaln = size(StimulusCode,1);


% 6 X 6 onscreen matrix
screen=char('A','B','C','D','E','F',...
            'G','H','I','J','K','L',...
            'M','N','O','P','Q','R',...
            'S','T','U','V','W','X',...
            'Y','Z','1','2','3','4',...
            '5','6','7','8','9','_');

% 预分配空间
flashseq = zeros(totaln,180);

%获得闪光序列
for epoch = 1 : totaln
    for i = 1 : 7560/42
        flashseq(epoch,i) = StimulusCode(epoch,(i-1)*42+1);
    end
end

%将输出化成相同纬度的矩阵
seperatedcomp = zeros(totaln,15,12);
j = 0;
for epoch = 1 : totaln
    for i = 1 : 15
        for k = 1 : 12
            j = j + 1;
            seperatedcomp(epoch,i,k) = output_final(j,1);
        end
    end
end

%判断闪光对应的字母
stimulusseq = cell(totaln,15);
for epoch = 1 : totaln
    for i = 1 : 15
        tempseq = [];
        j = 1;
        for k = 1 : 12
            if seperatedcomp(epoch,i,k) == 1
                tempseq(j) = flashseq(epoch,(i-1)*12+k);
                j = j + 1;
            end
        end
        stimulusseq{epoch,i} = tempseq;
    end
end

%
correspondingindex = zeros(totaln,15);
correspondingchar = '';
for epoch = 1 : totaln
    for i = 1 : 15
        if ~isempty(stimulusseq{epoch,i})
            col = min(stimulusseq{epoch,i});
            row = max(stimulusseq{epoch,i});
            if col <= 6 && row >= 7
                correspondingindex(epoch,i) = (row-7)*6+col;
            else
                correspondingindex(epoch,i) = 0;
            end
        else
            correspondingindex(epoch,i) = 0;
        end
        
    end
    temptable = [];
    temptable = tabulate(correspondingindex(epoch,:));
    temptable = temptable(2:size(temptable,1),:);
    maxperc = max(temptable(:,3));
    [r,c] = find(temptable == maxperc);
    index = temptable(r,1);
    if isscalar(index) == 1;
        correspondingchar(1,epoch) = screen(index);
    else
        correspondingchar(1,epoch) = screen(index(1));
    end
end

%字符串比较
t = length(TargetChar);
a = 0;
for i = 1 : t
    if TargetChar(i) == correspondingchar(i);
        a = a + 1;
    end
end
acc = a/t;

