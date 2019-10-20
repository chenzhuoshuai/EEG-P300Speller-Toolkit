# EEG-P300Speller_Model-util
This repository contains 3 part.

# Part One: EEG Signal Classificatrion with Deep Learning Model (Stacked CNN and RNN)-Keras
P300_CNN_1_GRU_A.py: A Python File in which is the model of a combination of CNN and GRU to determine if the EEG signal sequence contains P300 wave.

The brief of the model-1 (Stacked CNN & RNN): 
1, A CNN is responsbile for spatial domain feature extraction.
2, A GRU is repsonsible for temporal domain feature extraction.
3, Dropout is introduced to prevent overfitting and to improve the accuracy. 

![Stacked RNN and CNN Model](/images/Model.png)

The brief of model-2 (Stacked CNN)-not contained in repository:
1, A CNN is responsbile for spatial domain feature extraction.
2, A CNN is repsonsible for temporal domain feature extraction.
3, Dropout is introduced to prevent overfitting and to improve the accuracy. 


![The Perfromance of Several Models](/images/Model_Identification.png)


# Part Two: A Toolkit package for EEG Signals preprocessing.
List and brief description:
1, EEG_Preprocessor.py: A python file where the code for a series of EEG Signals preprocessing procedure is included. 
   Including: load_data, extract_eegdata, extract_feature, etc.
   
   Operations before classification: 
       
       1) band-pass butter-6 filter to remove the noises irrelevant to classification;          
       2) using sliding averaging window to downsample signal data;
       
  (the file below please see in the common folder)     
2, classifier.py: A python file where the code for several simple classifiers for P300 classification is included.
   Including: 
   1) Fisher's Linear Discirminant Analysis;
   2) Logistic Regression (Iterative reweighted least square (IRLS) by Newton-Raphson);
   3) Logistic regression for binary classification using SGD algorithm;
   4) Softmax Regression using SGD;
   
3, optimizer.py: A python file where the code for some classic optimizers is included.
  Including:
  1) AdamOptimizer;
  2) LbfgsOptimizaer;
  
4, regressor.py: A python file where the code for Ridge Regression is included.

5, standard.py: A python file where the code for some criterions for ML model evaluation is included.

6, CSP(Spatial_Filter).py: A python file where the code for Common Spatial Pattern, a powerful tool to realize signal data feature extraction, is included.
  For more about the CSP, please consult: 
  https://blog.csdn.net/missxy_/article/details/81264953
  
 7, ButterWorth(temporalfilter).py: A python file where the code for Common Spatial Pattern, a powerful tool to remove noises, is included.
 
 8, utils.py: includes several machine learning gears.
 
 # Part Three: A Bagging Ensemble SVM to classify EEG Signals
 (the file below please see in the Part Three folder)     
 It is all written in Matlab.
 Consult the main.m file for the code logics.
 
  
   
