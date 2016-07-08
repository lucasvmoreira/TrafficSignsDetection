import numpy as np
import matplotlib.pyplot as plt

# Make sure that caffe is on the python path:
caffe_root = '/dados/caffe/'  # this file is expected to be in {caffe_root}/examples
fname_model_from = 'R10pre-treinada/snapshot_iter_7215.caffemodel'
fname_deploy_from = 'R10pre-treinada/deploy.prototxt'
fname_model_to = 'R10pre-treinada/full_conv.caffemodel'
fname_deploy_to = 'full_conv_deploy.prototxt'
import sys
sys.path.insert(0, caffe_root + 'python')

import caffe

# configure plotting
plt.rcParams['figure.figsize'] = (10, 10)
plt.rcParams['image.interpolation'] = 'nearest'
plt.rcParams['image.cmap'] = 'gray'

# ========================================================================================================
# Load the original network and extract the fully connected layers' parameters.
net = caffe.Net(fname_deploy_from, fname_model_from, caffe.TEST)
params = ['fc6', 'fc7', 'fc8']
# fc_params = {name: (weights, biases)}
fc_params = {pr: (net.params[pr][0].data, net.params[pr][1].data) for pr in params}

for fc in params:
    print '{} weights are {} dimensional and biases are {} dimensional'.format(fc, fc_params[fc][0].shape, fc_params[fc][1].shape)

# ========================================================================================================
# Load the fully convolutional network to transplant the parameters.
net_full_conv = caffe.Net(fname_deploy_to, fname_model_from, caffe.TEST)
params_full_conv = ['fc6-conv', 'fc7-conv', 'fc8-conv']
# conv_params = {name: (weights, biases)}
conv_params = {pr: (net_full_conv.params[pr][0].data, net_full_conv.params[pr][1].data) for pr in params_full_conv}

for conv in params_full_conv:
    print '{} weights are {} dimensional and biases are {} dimensional'.format(conv, conv_params[conv][0].shape, conv_params[conv][1].shape)

# ========================================================================================================
# transplant!
for pr, pr_conv in zip(params, params_full_conv):
    conv_params[pr_conv][0].flat = fc_params[pr][0].flat  # flat unrolls the arrays
    conv_params[pr_conv][1][...] = fc_params[pr][1]

# save
net_full_conv.save(fname_model_to)
