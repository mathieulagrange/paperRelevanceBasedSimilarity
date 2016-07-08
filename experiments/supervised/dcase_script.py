import collections
import datetime
import joblib
import numpy as np
import pickle
import h5py
import numpy as np
import os.path
import scipy.stats
import sklearn.decomposition
import sklearn.ensemble
import sklearn.linear_model
import sklearn.metrics
import sklearn.preprocessing

from dcase_svm import cached_dcase_svm, dcase_svm

np.set_printoptions(precision=2)



# Evaluate role of compression
exp1 = []
for C in 2**np.arange(-1, 4).astype(np.float):
    exp1.append(dcase_svm(0, 12, False, "time", "none", "early", C))
    exp1.append(dcase_svm(0, 12, False, "time", "log", "early", C))
    exp1.append(dcase_svm(0, 12, False, "time", "logmedian", "early", C))

# Evaluate role of data augmentation
exp2 = []
for C in 2**np.arange(-1, 4).astype(np.float):
    exp2.append(dcase_svm(0, 12, False, "time", "log", "early", C))
    exp2.append(dcase_svm(0, 12, False, "time", "logmedian", "late", C))
    exp2.append(dcase_svm(0, 12, True, "time", "log", "early", C))
    exp2.append(dcase_svm(0, 12, True, "time", "logm", "late", C))
