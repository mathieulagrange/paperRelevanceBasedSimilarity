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

dictionaries = joblib.Parallel(barch_size=1, n_jobs=-1, verbose=10)(
    delayed_dcase_svm(
        octmin,
        octmax,
        augmentation,
        method,
        selection,
        integration)
    for octmin in [ 0, 1, 2, 3 ]
    for octmax in [ 10, 9, 8, 7, 6, 5, 4 ]
    for augmentation in [ False, True ]
    for method in [ 'time' ]
    for selection in [ False, True ]
    for integration in [ "early", "late"])
