# -*- coding: utf-8 -*-

import numpy as np


## Ridge regression
# X: N by P feature matrix, N number of samples, P number of features
# y: N by 1 target vector
# b: P by 1 regression coefficients
# b0: the intercept

# 岭回归(英文名：ridge regression)
# 是一种专用于共线性数据分析的有偏估计回归方法，
# 实质上是一种改良的最小二乘估计法，
# 通过放弃最小二乘法的无偏性，以损失部分信息、降低精度为代价
# 获得回归系数更为符合实际、更可靠的结果，
# 对病态数据的拟合要强于最小二乘法。
def ridgereg(y, X, coeff = 1e-4):
    N, P = X.shape
    PHI = np.concatenate((np.ones([N,1]), X), axis=1)
    invC = np.linalg.inv(coeff*np.eye(P+1)+ np.matmul(PHI.T, PHI))
    w = np.matmul(np.matmul(invC, PHI.T), y)
    b = w[1:]
    b0 = w[0]
    return b, b0