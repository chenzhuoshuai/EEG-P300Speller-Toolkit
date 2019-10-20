%% test version
labels_validation1=ones(100,1);
labels_validation2=ones(100,1);
labels_validation3=ones(100,1);
labels_validation4=ones(100,1);
labels_validation5=ones(100,1);
labels_validation1=svmclassify(SVM_model1,biclass_trainset);
labels_validation2=svmclassify(SVM_model2,biclass_trainset);
labels_validation3=svmclassify(SVM_model3,biclass_trainset);
labels_validation4=svmclassify(SVM_model4,biclass_trainset);
labels_validation5=svmclassify(SVM_model5,biclass_trainset);

%% 验证各个分类器的性能
labels_validation_total=[labels_validation1,labels_validation2,labels_validation3,labels_validation4,labels_validation5];
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

