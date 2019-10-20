% k=15;                            %将样本降到k维参数设置
% %% 使用Matlab工具箱princomp函数实现PCA
% [COEFF SCORE latent]=princomp(downsampledsig_2dimension)
% pcaData1=SCORE(:,1:k)            %取前k个主成
k=15;
[r, e]=size(downsampledsig_2dimension);
meanVec=mean(downsampledsig_2dimension);%求样本的均值
Z=(downsampledsig_2dimension-repmat(meanVec,r,1));
covMatT=Z*Z'; %计算协方差矩阵，此处是小样本矩阵
[V, D]=eigs(covMatT,k);%计算前k个特征值和特征向量
V=Z'*V;%得到协方差矩阵covMatT'的特征向量
%特征向量归一化单位特征向量
for i=1:k
    V(:,i)=V(:,i)/norm(V(:,i));
end
pcaA=Z*V;%线性变化降维至k维
