from keras.models import Sequential
from keras.layers import Activation, Dense, Dropout, Flatten
from keras.layers import Convolution2D, MaxPooling2D
from keras.layers.advanced_activations import LeakyReLU
from keras.optimizers import Adam

import h5py
import numpy as np
import sklearn.preprocessing

method = 'time'
hdf5_file = h5py.File("memoized_features/" + method + "_Q=08.mat")
hdf5_file.keys()
hdf5_group = hdf5_file[u'data']

X_training = hdf5_group[u'X_scattergrams_train']
X_test = hdf5_group[u'X_scattergrams_test']

X_training = np.transpose(X_training, (1, 0, 2, 4, 3))
X_training = np.reshape(X_training,
    (X_training.shape[0]*X_training.shape[1], X_training.shape[2],
    X_training.shape[3], X_training.shape[4]))
X_test = np.transpose(X_test, (1, 0, 2, 4, 3))
X_test = np.reshape(X_test,
    (X_test.shape[0]*X_test.shape[1], X_test.shape[2],
    X_test.shape[3], X_test.shape[4]))

X_training = np.log(X_training[:, 0, :, :] + 10.0)
X_test = np.log(X_test[:, 0, :, :] + 10.0)

# offset = - np.min(X_training[:])
# X_training = X_training + offset + 0.1
# X_test = X_test + offset + 0.1
# _, lambda_ = scipy.stats.boxcox(np.ravel(X_training))
# X_training = (X_training ** lambda_ - 1.0) / lambda_
# X_test = (X_test ** lambda_ - 1.0) / lambda_

X_mean = np.mean(X_training)
X_std = np.std(X_training)
X_training = ((X_training - X_mean) / (1e-6 + X_std))
X_test = ((X_test - X_mean) / (1e-6 + X_std))

Y_training = np.repeat(hdf5_group[u'Y_train'], 5)
Y_training = np.eye(10)[Y_training.astype('int')]
Y_test = np.repeat(hdf5_group[u'Y_test'], 5)
Y_test = np.eye(10)[Y_test.astype('int')]

scattering_channels = 1
conv_height = 5
conv_width = 5
conv_channels = 16
pool_height = 2
pool_width = 3
dense_channels = 32

alpha = 0.3  # for LeakyReLU

init = "he_normal"
batch_size = 32
epoch_size = 8192
n_epochs = 20

model = Sequential()

conv1 = Convolution2D(conv_channels, conv_height, conv_width,
                      border_mode="valid", init=init,
                      input_shape=(1, 88, 128))
model.add(conv1)
model.add(LeakyReLU(alpha=alpha))
model.add(MaxPooling2D(pool_size=(pool_height, pool_width)))

conv2 = Convolution2D(conv_channels, conv_height, conv_width,
                      border_mode="valid", init=init)
model.add(conv2)
model.add(LeakyReLU(alpha=alpha))
model.add(MaxPooling2D(pool_size=(pool_height, pool_width)))

conv3 = Convolution2D(conv_channels, conv_height, conv_width,
                      border_mode="valid", init=init)
model.add(conv3)
model.add(LeakyReLU(alpha=alpha))
model.add(MaxPooling2D(pool_size=(1, 6)))

model.add(Dropout(0.5))
model.add(Flatten())
model.add(Dense(dense_channels))
model.add(Activation('softmax'))

model.add(Dropout(0.5))
model.add(Dense(10))
model.add(Activation('softmax'))

print(model.summary())
model.compile(loss="categorical_crossentropy", optimizer="adam")

model.fit(X_training, Y_training, batch_size=1, nb_epoch=100)


##
import librosa
for n in range(100):
    print n
    librosa.display.specshow(np.squeeze(X_training[n, :, :]))
    plt.savefig("figs/" + str(n).zfill(2) + ".png")
