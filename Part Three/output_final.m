%% output file
function [output_averaged,output_final]=output_final(testset)
labels_validation1=svmclassify(SVM_model1,testset);
labels_validation2=svmclassify(SVM_model2,testset);
labels_validation3=svmclassify(SVM_model3,testset);
labels_validation4=svmclassify(SVM_model4,testset);
labels_validation5=svmclassify(SVM_model5,testset);
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
end