%% 五个SVM分类器训练
% 生成 随机分配 划分五个数据集
Indices = crossvalind('Kfold', 15300/180, 5);
labelset1=[];labelset2=[];labelset3=[];labelset4=[];labelset5=[];
trainset1=[];trainset2=[];trainset3=[];trainset4=[];trainset5=[];
for i=1:size(Indices,1)
    switch Indices(i)
        case 1 
            labelset1=[labelset1;biclass_labelset(180*(i-1)+1:180*i)];
            trainset1=[trainset1;biclass_trainset(180*(i-1)+1:180*i,:)];
        case 2
             labelset2=[labelset2;biclass_labelset(180*(i-1)+1:180*i)];
             trainset2=[trainset2;biclass_trainset(180*(i-1)+1:180*i,:)];
        case 3
             labelset3=[labelset3;biclass_labelset(180*(i-1)+1:180*i)];
             trainset3=[trainset3;biclass_trainset(180*(i-1)+1:180*i,:)];
        case 4
             labelset4=[labelset4;biclass_labelset(180*(i-1)+1:180*i)];
             trainset4=[trainset4;biclass_trainset(180*(i-1)+1:180*i,:)];
       case 5
             labelset5=[labelset5;biclass_labelset(180*(i-1)+1:180*i)];
             trainset5=[trainset5;biclass_trainset(180*(i-1)+1:180*i,:)];
    end
end
%% Ensemble Training
opts=statset('MaxIter',15000000);% 1500000次不行 目前使用1500万次
SVM_model1=svmtrain(trainset1,labelset1,'kernel_function','linear','options',opts);
fprintf(1, ' 第一个分类器完成 \n' )  
SVM_model2=svmtrain(trainset2,labelset2,'kernel_function','linear','options',opts);
fprintf(1, ' 第二个分类器完成 \n' )  
SVM_model3=svmtrain(trainset3,labelset3,'kernel_function','linear','options',opts);
fprintf(1, ' 第三个分类器完成 \n' )  
SVM_model4=svmtrain(trainset4,labelset4,'kernel_function','linear','options',opts);
fprintf(1, ' 第四个分类器完成 \n' )  
SVM_model5=svmtrain(trainset5,labelset5,'kernel_function','linear','options',opts);
fprintf(1, ' 第五个分类器完成 \n' )  
% https://blog.csdn.net/shenziheng1/article/details/54178685 或者直接help
% svmtrain 查看
%% 然后总的训练集查看每个分类器的精度
labels_validation1=svmclassify(SVM_model1,biclass_trainset);
labels_validation2=svmclassify(SVM_model2,biclass_trainset);
labels_validation3=svmclassify(SVM_model3,biclass_trainset);
labels_validation4=svmclassify(SVM_model4,biclass_trainset);
labels_validation5=svmclassify(SVM_model5,biclass_trainset);
%% 验证各个分类器的性能
valid1=confusionmat(biclass_labelset,labels_validation1);
valid2=confusionmat(biclass_labelset,labels_validation2);
valid3=confusionmat(biclass_labelset,labels_validation3);
valid4=confusionmat(biclass_labelset,labels_validation4);
valid5=confusionmat(biclass_labelset,labels_validation5);

labels_validation_total=[labels_validation1,labels_validation2,labels_validation3,labels_validation4,labels_validation5];
output=ones(15300,1);
% 简易阈值化 非最好办法
for i=1:size(labels_validation_total,1)
    output(i)=sign(sum(labels_validation_total(i,:)));
end
valid_total=confusionmat(biclass_labelset,output);
% comparison=[output,biclass_labelset];
output_averaged=ones(size(labels_validation_total,1),1);
for i=1:size(labels_validation_total,1)
   output_averaged(i)=mean(labels_validation_total(i,:)); 
end
output_final=-ones(size(output_averaged));
for i=1:(size(labels_validation_total,1)/12)
       a=output_averaged((i-1)*12+1:12*i,:);
       [~,I]=sort(a);
       output_final((i-1)*12+I(11))=1;
       output_final((i-1)*12+I(12))=1;
end





