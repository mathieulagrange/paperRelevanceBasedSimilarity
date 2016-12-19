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



C = 1
exp1.append(dcase_svm(0, 12, False, "time", "logmedian", "early", C))
exp1.append(dcase_svm(0, 12, True, "time", "logmedian", "early", C))
exp1.append(dcase_svm(0, 12, False, "timefrequency", "logmedian", "early", C))
exp1.append(dcase_svm(0, 12, True, "timefrequency", "logmedian", "early", C))


exp1.append(dcase_svm(0, 11, True, "timefrequency", "logmedian", "early", C))
exp1.append(dcase_svm(0, 10, True, "timefrequency", "logmedian", "early", C))
exp1.append(dcase_svm(0,  9, True, "timefrequency", "logmedian", "early", C))
exp1.append(dcase_svm(0,  8, True, "timefrequency", "logmedian", "early", C))
