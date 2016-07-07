import collections
import datetime
import joblib
import numpy as np
import pickle
import h5py
import os.path
import scipy.stats
import sklearn.decomposition
import sklearn.ensemble
import sklearn.linear_model
import sklearn.metrics
import sklearn.preprocessing

from dcase_svm import cached_dcase_svm, dcase_svm

np.set_printoptions(precision=2)

delayed_dcase_svm = joblib.delayed(cached_dcase_svm)

for augmentation in [ True, False ]:
    for selection in [ False, True ]:
        for integration in [ "early", "late" ]:
            dcase_svm(1, 10, augmentation,
                "time", selection, integration)


for selection in [ False, True ]:
    for augmentation in [ False, True ]:
            dcase_svm(0, 9, augmentation,
                "timefrequency", selection, "late")


for selection in [ False, True ]:
    for augmentation in [ True, False ]:
        for octmin in [0, 1, 2, 3]:
                dcase_svm(octmin, 9, augmentation,
                    "timefrequency", selection, "early")


dictionaries = joblib.Parallel(n_jobs=-1, verbose=10)(
    delayed_dcase_svm(
        octmin,
        octmax,
        augmentation,
        method,
        selection,
        integration)
    for octmin in [ 1 ]
    for octmax in [ 10 ]
    for augmentation in [ False, True ]
    for method in [ 'time' ]
    for selection in [ False, True ]
    for integration in [ "early", "late"])
