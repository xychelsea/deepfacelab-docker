DeepFaceLab/TensorFlow GPU-enabled Docker Container
-----

Provides an [NVIDIA GPU-enabled](https://hub.docker.com/r/nvidia/cuda) container with [DeepFaceLab](https://github.com/iperov/DeepFaceLab) pre-installed on an [Anaconda](https://www.anaconda.com/) and [TensorFlow](https://hub.docker.com/r/tensorflow/tensorflow) container ```xychelsea/tensorflow:latest-gpu```.

DeepFaceLab with TensorFlow
-----

[DeepFaceLab](https://github.com/iperov/DeepFaceLab) is an open source research project, based on [TensorFlow](https://tensorflow.org) exploring the role of machine learning as a tool in the creative process. [TensorFlow](https://tensorflow.org/) is an open source platform for machine learning. It provides tools, libraries and community resources for researcher and developers to build and deploy machine learning applications. [Anaconda](https://anaconda.com/) is an open data science platform based on Python 3. This container installs TensorFlow through the ```conda``` command with a lightweight version of Anaconda (Miniconda) and the ```conda-forge``` [repository](https://conda-forge.org/) in the ```/usr/local/anaconda``` directory. The default user, ```anaconda``` runs a [Tini shell](https://github.com/krallin/tini/) ```/usr/bin/tini```, and comes preloaded with the ```conda``` command in the environment ```$PATH```. Additional versions with [NVIDIA/CUDA](https://hub.docker.com/r/nvidia/cuda/) support and [Jupyter Notebooks](https://jupyter.org/) tags are available.

### NVIDIA/CUDA GPU-enabled Containers

Two flavors provide an [NVIDIA GPU-enabled](https://hub.docker.com/r/nvidia/cuda) container with [TensorFlow](https://tensorflow.org) pre-installed through [Anaconda](https://anaconda.com/).

## Getting the containers

### Vanilla DeepFaceLab

The base container, based on the ```xychelsea/tensorflow:latest``` from the [Anaconda 3 container stack](https://hub.docker.com/r/xychelsea/anaconda3) (```xychelsea/anaconda3:latest```) running Tini shell. For the container with a ```/usr/bin/tini``` entry point, use:

```bash
docker pull xychelsea/deepfacelab:latest
```

With Jupyter Notebooks server pre-installed, pull with:

```bash
docker pull xychelsea/deepfacelab:latest-jupyter
```

### DeepFaceLab with NVIDIA/CUDA GPU support

Modified versions of ```nvidia/cuda:latest``` container, with support for NVIDIA/CUDA graphical processing units through the Tini shell. For the container with a ```/usr/bin/tini``` entry point:

```bash
docker pull xychelsea/deepfacelab:latest-gpu
```

With Jupyter Notebooks server pre-installed, pull with:

```bash
docker pull xychelsea/deepfacelab:latest-gpu-jupyter
```

## Running the containers

To run the containers with the generic Docker application or NVIDIA enabled Docker, use the ```docker run``` command with a bound volume directory ```workspace``` attached at mount point ```/usr/local/deepfacelab/workspace```.

### Vanilla DeepFaceLab

```bash
docker run --rm -it \
    -v workspace:/usr/local/deepfacelab/workspace \
    xychelsea/deepfacelab:latest
```

With Jupyter Notebooks server pre-installed, run with:

```bash
docker run --rm -it -d
     -v workspace:/usr/local/deepfacelab/workspace \
     -p 8888:8888 \
     xychelsea/deepfacelab:latest-jupyter
```
### DeepFaceLab with NVIDIA/CUDA GPU support

```bash
docker run --gpus all --rm -it
     -v workspace:/usr/local/deepface/workspace \
     xychelsea/deepfacelab:latest-gpu /bin/bash
```

With Jupyter Notebooks server pre-installed, run with:

```bash
docker run --gpus all --rm -it -d
     -v workspace:/usr/local/deepfacelab/workspace \
     -p 8888:8888 \
     xychelsea/deepfacelab:latest-gpu-jupyter
```

## Using DeepFaceLab

[TK]

## Building the containers

To build either a GPU-enabled container or without GPUs, use the [deepfacelab-docker](https://github.com/xychelsea/deepfacelab-docker) GitHub repository.

```bash
git clone git://github.com/iperov/DeepFaceLab.git
```

### Vanilla DeepFaceLab

The base container, based on the ```xychelsea/deepfacelab:latest``` from the [Anaconda 3 container stack](https://hub.docker.com/r/xychelsea/anaconda3) (```xychelsea/anaconda3:latest```) running Tini shell:

```bash
docker build -t deepfacelab:latest -f Dockerfile .
```

With Jupyter Notebooks server pre-installed, build with:

```bash
docker build -t deepfacelab:latest-jupyter -f Dockerfile.jupyter .
```

### DeepFaceLab with NVIDIA/CUDA GPU support

```bash
docker build -t deepfacelab:latest-gpu -f Dockerfile.nvidia .
```

With Jupyter Notebooks server pre-installed, build with:

```
docker build -t deepfacelab:latest-gpu-jupyter -f Dockerfile.nvidia-jupyter .
```

## Environment

The default environment uses the following configurable options:

```
ANACONDA_GID=100
ANACONDA_PATH=/usr/local/anaconda3
ANACONDA_UID=1000
ANACONDA_USER=anaconda
ANACONDA_ENV=magenta
DEEPFACELAB_PATH=/usr/local/deepfacelab
DEEPFACELAB_HOME=$HOME/deepfacelab
DEEPFACELAB_WORKSPACE=$DEEPFACELAB_PATH/workspace
DEEPFACELAB_SCRIPTS=$DEEPFACELAB_PATH/scripts
```

## References

- [DeepFaceLab](https://github.com/iperov/DeepFaceLab)
- [TensorFlow](https://tensorflow.org)
- [NVIDIA CUDA container](https://hub.docker.com/r/nvidia/cuda)
- [Anaconda 3](https://www.anaconda.com/blog/tensorflow-in-anaconda)
- [conda-forge](https://conda-forge.org/)
