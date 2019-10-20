load('ouput_avg_test_B.mat')
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
        
%extract flashing code sequence
for epoch = 1 : totaln
    for i = 1 : 180
        flashseq((epoch-1)*180+i,1) = StimulusCode(epoch,(i-1)*42+1);
    end
end

%combine
combinedmat = [output_averaged,flashseq];

%split up
splittedmat = zeros(totaln,180,2);
for epoch = 1 : totaln
    for i = 1 : 180
        splittedmat(epoch,i,:) = combinedmat((epoch-1)*180+i,:);
    end
end

score = zeros(totaln,12);
for epoch = 1 : totaln
    for i = 1 : 180
        switch splittedmat(epoch,i,2)
            case 1
                score(epoch,1) = score(epoch,1) + splittedmat(epoch,i,1);
            case 2
                score(epoch,2) = score(epoch,2) + splittedmat(epoch,i,1);
            case 3
                score(epoch,3) = score(epoch,3) + splittedmat(epoch,i,1);
            case 4
                score(epoch,4) = score(epoch,4) + splittedmat(epoch,i,1);
            case 5
                score(epoch,5) = score(epoch,5) + splittedmat(epoch,i,1);
            case 6
                score(epoch,6) = score(epoch,6) + splittedmat(epoch,i,1);
            case 7
                score(epoch,7) = score(epoch,7) + splittedmat(epoch,i,1);
            case 8
                score(epoch,8) = score(epoch,8) + splittedmat(epoch,i,1);
            case 9
                score(epoch,9) = score(epoch,9) + splittedmat(epoch,i,1);
            case 10
                score(epoch,10) = score(epoch,10) + splittedmat(epoch,i,1);
            case 11
                score(epoch,11) = score(epoch,11) + splittedmat(epoch,i,1);
            case 12
                score(epoch,12) = score(epoch,12) + splittedmat(epoch,i,1);
            otherwise
        end
    end
end

%discriminate desired row and column that get highest score
index = cell(totaln,1);
for epoch = 1 : totaln
    judge = 1;
    rget = 0;
    cget = 0;
    tempvect = score(epoch,:);
    while(judge)
        [r,c] = max(tempvect);
        if c >= 7 && rget ~= 1
            row = c;
            rget = 1;
        elseif c <= 6 && cget ~=1
            col = c;
            cget = 1;
        end
        tempvect(c) = -99;
        if rget == 1 && cget == 1
            judge = 0;
            index{epoch,1} = [row,col,(row-7)*6+col];
        end
    end
end

%get char from screen
finalchar = '';
for epoch = 1 : totaln
    scalarindex = index{epoch,1}(1,3);
    finalchar(1,epoch) = screen(scalarindex);
end

%×Ö·û´®±È½Ï
t = length(TargetChar);
a = 0;
for i = 1 : t
    if TargetChar(i) == finalchar(i);
        a = a + 1;
    end
end
acc = a/t;