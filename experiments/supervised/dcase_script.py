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

from dcase_svm import cached_dcase_svm

np.set_printoptions(precision=2)

delayed_dcase_svm = joblib.delayed(cached_dcase_svm)

octmin = 1
octmax = 10
augmentation = False
method = "time"
selection = True
integration = "late"

dictionaries = joblib.Parallel(n_jobs=-1, verbose=10)(
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
