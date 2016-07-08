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

def dcase_svm(octmin, octmax, augmentation, scattering, compression, integration, C=C):
    if scattering == "time":
        hdf5_file = h5py.File("memoized_features/dcase2013_timeQ8_test.mat")
        X = hdf5_file["dcase2013_timeQ8_test"]["X_test"]
        freqs = np.ravel(hdf5_file["dcase2013_timeQ8_test"]["freqs"])
        Y = np.ravel(hdf5_file["dcase2013_timeQ8_test"][u'Y_test'])
    if scattering == "timefrequency":
        hdf5_file = h5py.File(
            "memoized_features/dcase2013_timefrequencyQ8_test.mat")
        X = hdf5_file["dcase2013_timefrequencyQ8_test"]["X_test"]
        freqs = np.ravel(hdf5_file["dcase2013_timefrequencyQ8_test"]["X_freqs"])
        Y = np.ravel(hdf5_file["dcase2013_timefrequencyQ8_test"][u'Y_test'])

    method_str = scattering + "_oct" + str(octmin) + "to" + str(octmax)
    method_str = method_str + "_" + compression
    if augmentation:
        method_str = method_str + "_augmentation"
    method_str = method_str + "_" + integration
    method_str = method_str + "_C" + str(C)

    fmin = 10.0 * (2**octmin) # in Hz
    fmax = 10.0 * (2**octmax) # in Hz
    freq_indices = (freqs > fmin) & (freqs < fmax)
    X = X[:, :, :, freq_indices]

    # Rectify
    X = np.maximum(0.0, X)

    # Split folds
    X = np.reshape(X,
        (X.shape[0] / 5,   #  20 scenes per fold
         5,                #   5 folds
         X.shape[1],       #   5 azimuths
         X.shape[2],       # 128 time
         X.shape[3]))      # ~1k features
    folds = np.mod(np.arange(100), 5)

    # Early integration
    if integration == "early":
        X = np.sum(X, 3)[:, :, :, np.newaxis, :]

    accuracies = []
    for fold_id in range(5):
        Y_training = Y[folds != fold_id]
        Y_test = Y[folds == fold_id]

        if integration == "late":
            Y_training = np.repeat(Y_training, 128)

        # Concatenate azimuths as different training examples
        if augmentation:
            X_training = X[:, np.arange(5)!=fold_id, :, :, :]
            Y_training = np.repeat(Y_training, 5)
        else:
            X_training = X[:, np.arange(5)!=fold_id, 2, :, :]
        # Pick central azimuth at test time
        X_test = X[:, fold_id, 2, :, :]

        X_training = np.reshape(X_training,
            (np.prod(X_training.shape[0:-1]), X_training.shape[-1]))
        X_test = np.reshape(X_test,
            (np.prod(X_test.shape[0:-1]), X_test.shape[-1]))

        # Discard features with less than 1% of the energy
        if selection:
            energies = X_training * X_training
            feature_energies = np.mean(X_training, axis=0)
            feature_energies /= np.sum(feature_energies)
            sorting_indices = np.argsort(feature_energies)
            sorted_feature_energies = feature_energies[sorting_indices]
            cumulative = np.cumsum(sorted_feature_energies)
            start_feature = np.where(cumulative > 0.01)[0][0]
            dominant_indices = sorting_indices[start_feature:]
            X_training = X_training[:, dominant_indices]
            X_test = X_test[:, dominant_indices]

        # Log transformation (1e2 is what yields the lowest skewness)
        if compression == "logmedian":
            medians = np.median(X_training, axis=0)[np.newaxis, :]
            X_training = np.log1p(1e2 * X_training / medians)
            X_test = np.log1p(1e2 * X_test / medians)
        if compression == "log"
            X_training = np.log(X_training)
            X_test = np.log1p(X_test)

        # Standardize features
        scaler = sklearn.preprocessing.StandardScaler().fit(X_training)
        X_training = scaler.transform(X_training)
        X_test = scaler.transform(X_test)

        # Train linear SVM
        clf = sklearn.svm.LinearSVC(class_weight="balanced", C=C)
        clf.fit(X_training, Y_training)

        # Predict and evaluate average miss rate
        if integration == "early":
            Y_test_predicted = clf.predict(X_test)
        if integration == "late":
            vote_test = clf.predict(X_test)
            vote_test = np.reshape(vote_test,
                (vote_test.shape[0] / 128, 128))
            votes = [vote_test[n, :] for n in range(20)]
            counters = map(collections.Counter, votes)
            Y_test_predicted = np.hstack(
                [ counter.most_common(1)[0][0] for counter in counters ])

        accuracy =\
            sklearn.metrics.accuracy_score(Y_test_predicted, Y_test)
        accuracies.append(accuracy)
        Y_predicted.append(Y_test_predicted)

    mean_accuracy = np.mean(accuracies)
    std_accuracy = np.std(accuracies)
    print method_str + ": " + str(100 * mean_accuracy) +\
        " +/- " + str(100 * std_accuracy)
    dictionary = {
        'accuracies': accuracies,
        'accuracy_mean' : mean_accuracy,
        'accuracy_std': std_accuracy,
        'augmentation': augmentation,
        'C': C,
        'fmin': fmin,
        'fmax': fmax,
        'integration': integration,
        'method_str': method_str,
        'octmin': octmin,
        'octmax': octmax,
        'scattering': scattering,
        'selection': selection,
        'Y': Y,
        'Y_predicted': Y_predicted}
    return dictionary

cachedir = os.path.expanduser('~/joblib')
memory = joblib.Memory(cachedir=cachedir, verbose=0)
cached_dcase_svm = memory.cache(dcase_svm)
