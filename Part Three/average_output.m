output_averaged=ones(size(labels_validation_total,1),1);
for i=1:size(labels_validation_total,1)
   output_averaged(i)=mean(labels_validation_total(i,:)); 
end
output_avg_final=ones(size(labels_validation_total,1),1);
output_final=-ones(size(output_averaged));
for i=1:(size(labels_validation_total,1)/12)
       a=output_averaged((i-1)*12+1:12*i,:);
       [~,I]=sort(a);
       output_final((i-1)*12+I(11))=1;
       output_final((i-1)*12+I(12))=1;
end

