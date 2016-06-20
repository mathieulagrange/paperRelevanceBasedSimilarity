from keras.models import Sequential
from keras.layers import Dense, Dropout, Flatten
from keras.layers import Convolution2D, MaxPooling2D
from keras.layers.advanced_activations import LeakyReLU
from keras.optimizers import Adam

import h5py
import numpy as np

method = 'time'
hdf5_file = h5py.File("memoized_features/" + method + "_Q=08.mat")
hdf5_file.keys()
hdf5_group = hdf5_file[u'data']

X_training = hdf5_group[u'X_scattergrams_train']
X_test = hdf5_group[u'X_scattergrams_test']
Y_training = np.ravel(hdf5_group[u'Y_train'])
Y_test = np.ravel(hdf5_group[u'Y_test'])

scattering_channels = X_training.shape[2]
conv_height = 5
conv_width = 5
conv_channels = 16
pool_height = 2
pool_width = 3
dense_channels = 64

alpha = 0.3  # for LeakyReLU

init = "he_normal"
batch_size = 32
epoch_size = 8192
n_epochs = 20

model = Sequential()

conv1 = Convolution2D(conv_channels, conv_height, conv_width,
                      border_mode="valid", init=init,
                      input_shape=(scattering_channels, 88, 128))
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

model.add(Dropout(0.5))
model.add(Dense(10))

print(model.summary())
model.compile(loss="categorical_crossentropy", optimizer="adam")
