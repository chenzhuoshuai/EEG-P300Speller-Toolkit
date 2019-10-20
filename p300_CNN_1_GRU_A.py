# -*- coding:utf-8 -*-

import numpy as np
from EEG_Preprocessor import *
from common.regressor import *
import random
import tensorflow as tf

# 6 × 6  字符矩阵
matrix='ABCDEF'+'GHIJKL'+'MNOPQR'+'STUVWX'+'YZ1234'+'56789_'

# 需要修改路径
datapath = 'E:/bcicompetition/bci2005/II/'

subject = 'Subject_A'
featureTrain, labelTrain, targetTrain, featureTest, labelTest, targetTest = load_dataset(datapath, subject)
# featureTrain.shape:(85, 12, 15, 1536)
# labelTrain.shape:(85, 12, 15)
# featureTest.shape:(100, 12, 15, 1536)
# labelTest.shape:(100, 12, 15)

num_train, num_chars, num_repeats, num_features = featureTrain.shape
# num_train: 85 （Subject_B注视的85个字符）
# num_chars： 12 （6行+6列=12种闪烁）
# num_repeats： 15 （12次闪烁，重复15次，对应一个字符的完整输入）
# num_features： 1536 （64个通道与24个时间步值）

num_test = featureTest.shape[0]
# featureTest.shape：(100, 12, 15, 1536)             # 1536=24* 64 拉成一维向量
X_train = np.reshape(featureTrain, [-1, 24, 64])     # 拉成二维
# X_train:(85*12*15=15300, 1536)
y_train = np.reshape(labelTrain, [-1])
# y_train.shape:(15300,)
X_test = np.reshape(featureTest, [-1, 24, 64])
# X_test.shape :(100*12*15=18000, 1536)
y_test = np.reshape(labelTest, [-1])


from keras.models import Sequential
from keras.layers import Dense, Dropout, BatchNormalization, GRU
from keras.layers import Conv1D, GlobalAveragePooling1D, MaxPooling1D,Conv2D,Flatten
from keras.layers.core import Reshape

# 每个信道降采样滤波后的信号长度
seq_length = 24

model = Sequential()
#转为2D图像的形式
model.add(Reshape((seq_length, 64, 1), input_shape=(seq_length, 64)))

# 输入形状:3D张量与形状： (batch, steps, channels)
model.add(Conv2D(filters=10,
                 kernel_size=(1, 64),
                 padding='valid',
                 activation='sigmoid'))

#输入已经变成了 24*1*10
model.add(Reshape((seq_length, 10)))

#为什么 GRU的时间维度上的输入 是对应着十个卷积核？
model.add(GRU(24))

model.add(Dropout(0.5))

# output layer
model.add(Dense(1, activation='sigmoid'))


model.compile(loss='binary_crossentropy',
              optimizer='rmsprop',
              metrics=['accuracy'])

history = model.fit(X_train, y_train,epochs=10,batch_size=128,validation_data=(X_test, y_test))

score = model.evaluate(X_test, y_test, batch_size=128)
print(score)
y_predict = model.predict(X_test)

targetPredict = np.zeros([num_test, num_repeats], dtype=np.str)
# targetPredict.shape:(100, 15)

for trial in range(num_test):  #range(0, 100)
    ytrial = y_predict[trial*num_chars*num_repeats:(trial+1)*num_chars*num_repeats]
    # 如果trial=0, ytrial = y_predict[0:12*15=180]
    ytrial = np.reshape(ytrial, [num_chars, num_repeats])
    # 改变形状：ytrial.shape :(12, 15)
    for repeat in range(num_repeats):  # range(0, 15)
        yavg = np.mean(ytrial[:,0:repeat+1], axis=1)
        # 取repeat次重复后的ytrial在0:repeat+1轴的平均值
        row = np.argmax(yavg[6:])
        col = np.argmax(yavg[0:6])
        # 取行中最大的概率和列中最大的概率
        targetPredict[trial, repeat] = matrix[int(row*6+col)]
        # 预测字符

accTest = np.zeros(num_repeats)
# accTest.shape:(15,)
for i in range(num_repeats):  # range(0, 15)
    accTest[i] = np.mean(np.array(targetPredict[:,i] == targetTest).astype(int))
    # 计算1，2，...，15次重复后的准确率的平均值

# 计算指标
from common.standard import *
y = y_predict.copy()
for i in range(len(y_predict)):
    if y[i] >= 0.5:
        y[i] = 1
    else:
        y[i] = 0
print(zhi_biao(y, y_test.T))

# 画图
import matplotlib.pyplot as plt
plt.plot(np.arange(num_repeats)+1, accTest*100, 'k-')
plt.title('Character Recognition Rate for ' + subject)
plt.xlabel('Repeat [n]')
plt.ylabel('Accuracy [%]')
plt.grid(which='both', axis='both')
plt.xlim(0, 16)
plt.ylim(0, 100)
plt.show()

# 绘制训练 & 验证的准确率值
plt.plot(history.history['acc'])
plt.plot(history.history['val_acc'])
plt.title('Model accuracy')
plt.ylabel('Accuracy')
plt.xlabel('Epoch')
plt.legend(['Train', 'Test'], loc='upper left')
plt.show()


# 绘制训练 & 验证的损失值
# plt.plot(history.history['loss'])
# plt.plot(history.history['val_loss'])
# plt.title('Model loss')
# plt.ylabel('Loss')
# plt.xlabel('Epoch')
# plt.legend(['Train', 'Test'], loc='upper left')
# plt.show()
