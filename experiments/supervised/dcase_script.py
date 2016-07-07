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

dictionaries = [
    cached_dcase_svm(
        octmin,
        octmax,
        augmentation,
        method,
        selection,
        integration)
    for augmentation in [ False, True ]
    for method in [ 'time' ]
    for selection in [ False, True ]
    for integration in [ "early", "late"] ]
