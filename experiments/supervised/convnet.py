from keras.models import Sequential
from keras.layers import Dense, Dropout, Flatten
from keras.layers import Convolution2D, MaxPooling2D
from keras.layers.advanced_activations import LeakyReLU
from keras.optimizers import Adam

conv_height = 5
conv_width = 5
conv_channels = 32
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
                      input_shape=(32, 88, 80))
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
model.add(MaxPooling2D(pool_size=(1, pool_width)))

model.add(Dropout(0.5))
model.add(Flatten())
model.add(Dense(dense_channels))

model.add(Dropout(0.5))
model.add(Dense(10))

print(model.summary())
model.compile(loss="categorical_crossentropy", optimizer="adam")
