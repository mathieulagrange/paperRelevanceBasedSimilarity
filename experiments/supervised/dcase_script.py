import collections
import datetime
import numpy as np
import pickle
import h5py
import scipy.stats
import sklearn.decomposition
import sklearn.ensemble
import sklearn.linear_model
import sklearn.metrics
import sklearn.preprocessing

np.set_printoptions(precision=2)

# Load
hdf5_time_file = h5py.File("memoized_features/dcase2013_timeQ8_test.mat")
X_time = hdf5_time_file["dcase2013_timeQ8_test"]["X_test"]
freqs_time = np.ravel(hdf5_time_file["dcase2013_timeQ8_test"]["freqs"])
Y = np.ravel(hdf5_time_file["dcase2013_timeQ8_test"][u'Y_test'])
hdf5_timefrequency_file = h5py.File(
    "memoized_features/dcase2013_timefrequencyQ8_test.mat")
freqs_timefrequency = np.ravel(
    hdf5_timefrequency_file["dcase2013_timefrequencyQ8_test"]["X_freqs"])
X_timefrequency = hdf5_timefrequency_file[
    "dcase2013_timefrequencyQ8_test"]["X_test"]

folds = np.mod(np.arange(100), 5)

fmin = 20.0 # in Herz

for octmin in [ 0, 1, 2, 3 ]:
    for octmax in [ 10, 9, 8, 7, 6, 5, 4 ]:
        for augmentation in [ True, False ]:
            for method in [ 'time', 'timefrequency' ]:
                for selection in [ False, True ]:
                    for integration in [ 'early', 'late' ]:
                        dcase_svm(octmin, octmax, augmentation,
                            method, selection, integration):
