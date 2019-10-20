import numpy as np
'''
1:正类
0:负类
TP:预测为1,标签为1
TN:预测为0,标签为0
FP:预测为1,标签为0
FN:预测为0,标签为1
'''


def zhi_biao_result(predict, real):
    tp = sum([1 for i in range(len(real)) if predict[i] == 1 and real[i] == 1])
    tn = sum([1 for i in range(len(real)) if predict[i] == 0 and real[i] == 0])
    fp = sum([1 for i in range(len(real)) if predict[i] == 1 and real[i] == 0])
    fn = sum([1 for i in range(len(real)) if predict[i] == 0 and real[i] == 1])
    # 准确率
    acc = (tp + tn)/(tp + tn + fp + fn)
    # 查全率
    recall = tp/(tp + fn)
    silence = 1 - recall
    # 查准率
    precision = tp/(tp + fp)
    noise = 1 - precision
    # 错误率
    error = 1 - acc
    # F1度量
    f1_measure = 2*recall*precision/(precision + recall)
    return {"TP": tp,
            "TN": tn,
            "FP": fp,
            "FN": fn,
            "Acc": acc,
            "Recall": recall,
            "Silence": silence,
            "Precision": precision,
            "Noise": noise,
            "Error": error,
            "F1-measure": f1_measure}


def zhi_biao(predict, real):
    if predict.size == real.size:
        return zhi_biao_result(predict, real)
    else:
        return "预测与标签数量不一致"


if __name__ == "__main__":
    y_predict = np.array((1, 1, 1, 1, 0, 0))
    y_real = np.array((1, 1, 1, 0, 0, 0))
    print(zhi_biao(y_predict, y_real))

