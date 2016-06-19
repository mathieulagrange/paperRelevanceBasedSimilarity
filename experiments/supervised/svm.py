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

for method in ['time']:
    for selection in [False, True]:
        for compression in [False, True]:
            method_str = "Method: " + method
            if selection:
                method_str + " + feature selection"
            if compression:
                method_str + " + compression"
            print method_str

            # Load
            print(datetime.datetime.now().time().strftime('%H:%M:%S') +
                " Loading")
            hdf5_file = h5py.File("memoized_features/" + method + "_Q=08.mat")
            hdf5_file.keys()
            hdf5_group = f[u'data']

            X_training = hdf5_group[u'X_features_train']
            X_test = hdf5_group[u'X_features_test']
            Y_training = np.ravel(hdf5_group[u'Y_train'])
            Y_test = np.ravel(hdf5_group[u'Y_test'])

            # Pick azimuth zero, sum along time
            X_training = np.squeeze(np.sum(X_training[:, 2, :, :], 1))
            X_test = np.squeeze(np.sum(X_test[:, 2, :, :], 1))

            # Discard features with less than 1% of the energy
            if selection:
                print(datetime.datetime.now().time().strftime('%H:%M:%S') +
                    " Selection")
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

            # Log transformation
            if compression:
                print(
                    datetime.datetime.now().time().strftime('%H:%M:%S') +
                    " Compression")
                X_training = np.log(1e-16 + X_training)
                X_test = np.log(1e-16 + X_test)

            # Standardize features
            print(datetime.datetime.now().time().strftime('%H:%M:%S') +
                " Standardization")
            scaler = sklearn.preprocessing.StandardScaler().fit(X_training)
            X_training = scaler.transform(X_training)
            X_test = scaler.transform(X_test)
            report = []
            output_file = open('mdb' + method + 'svm_y.pkl', 'wb')
            pickle.dump(report, output_file)
            output_file.close()

            # Train linear SVM
            print(datetime.datetime.now().time().strftime('%H:%M:%S') +
                " Training")
            clf = sklearn.svm.LinearSVC(class_weight="balanced")
            clf.fit(X_training, Y_training)

            # Predict and evaluate average miss rate
            print(datetime.datetime.now().time().strftime('%H:%M:%S') +
                " Evaluation")
            Y_training_predicted = clf.predict(X_training)
            Y_test_predicted = clf.predict(X_test)
            average_recall = sklearn.metrics.recall_score(
                Y_test, Y_test_predicted, average="macro")
            average_miss_rate = 1.0 - average_recall
            print "Average miss rate = " + str(100 * average_miss_rate)
            print ""
            dictionary = {
                'average_miss_rate': average_miss_rate,
                'compression': compression,
                'method': method,
                'method_str': method_str,
                'selection': selection,
                'Y_test': Y_test,
                'Y_test_predicted': Y_test_predicted,
                'Y_training': Y_training,
                'Y_training_predicted': Y_training_predicted}
            output_file = open(method_str + '.pkl', 'wb')
            pickle.dump(dictionary, output_file)
            output_file.close()
