load fisheriris
data=meas;
groups=ismember(species,'setosa');
[train,test]=crossvalind('holdOut',groups);
model1=svmtrain(data(train,:),groups(train,:));
model2=svmtrain(data(test,:),groups(test,:));
classes1=svmclassify(model1,data);
classes2=svmclassify(model2,data);

classes=(classes1+classes2)/2;
