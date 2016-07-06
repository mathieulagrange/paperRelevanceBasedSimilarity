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
print(datetime.datetime.now().time().strftime('%H:%M:%S') + " Loading")
hdf5_file = h5py.File(
    "memoized_features/dcase2013_" + method + "Q8_test.mat")
X = hdf5_file[u'X_test']
Y = np.ravel(hdf5_file[u'Y_test'])

for augmentation in [True, False], method in ['time', 'timefrequency'],
    selection in [False, True], integration in ['early', 'true']:
        method_str = "Method: " + method
        if augmentation:
            method_str = method_str + " + augmentation"
        if selection:
            method_str = method_str + " + selection"
        method_str = method_str + " + " + integration + " integration"
        print method_str

        # Split folds
        X = np.reshape(X,
            (X.shape[0],       # ~1k features
             X.shape[1],       # 128 time
             X.shape[2],       #   5 azimuths
             X.shape[3] / 5,   #  20 scenes per fold
             5,                #   5 folds
            )

        for fold_id in range(5):
            Y_training = Y[[fold_id]]
            Y_test = Y[[np.range(5)!=fold_id]]

            # Concatenate azimuths as different training examples
            if augmentation:
                X_training = X[:, :, :, :, np.range(5)!=fold_id]
                Y_training = np.repeat(Y_training, 5)
            else:
                X_training = X[:, :, [2], :, np.range(5)!=fold_id]
            # Pick central azimuth at test time
            X_test = X[:, :, [2], :, [fold_id]]

            if integration == "early":
                X_training =
                    np.sum(X_training, 1)[:, np.newaxis, :, :, :]
                X_test =
                    np.sum(X_training, 1)[:, np.newaxis, :, :, :]
            if integration == "late":
                Y_training = np.repeat(Y_training, 128)
                Y_test = np.repeat(Y_test, 128)

            X_training = np.transpose(np.reshape(X_training,
                X_training.shape[0], np.prod(X_training.shape[1:4])))
            X_test = np.transpose(np.reshape(X_training,
                X_training.shape[0], np.prod(X_training.shape[1:4])))

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

            # Log transformation
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
            if integration == "early":
                Y_test_predicted = clf.predict(X_test)
            if integration == "late":
                logprobs_test = clf.predict_log_proba(X_test)
                logprobs_test = np.reshape(
                    logprobs_test.shape[0],
                    128,
                    logprobs_test.shape[1] / 128)
                sumlogprobs_test = np.sum(logprobs_test, axis=1)
                Y_test_predicted = np.argmax(sumlogprobs_test, axis=0)
            accuracy =\
                sklearn.metrics.accuracy_score(Y_test_predicted, Y_test)
            print "Accuracy = " + str(100 * accuracy)
            print ""
            dictionary = {
                'accuracy': accuracy,
                'augmentation': augmentation,
                'fold_id': fold_id,
                'integration': integration,
                'method': method,
                'method_str': method_str,
                'selection': selection,
                'Y_test': Y_test,
                'Y_test_predicted': Y_test_predicted}
            output_file = open(method_str + '.pkl', 'wb')
            pickle.dump(dictionary, output_file)
            output_file.close()
