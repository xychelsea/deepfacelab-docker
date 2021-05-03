# DeepFaceLab Dockerfile for Anaconda with TensorFlow stack
# Copyright (C) 2020, 2021  Chelsea E. Manning
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

FROM xychelsea/anaconda3:v0.3
LABEL description="DeepFaceLab Vanilla Container"

# $ docker build --network=host -t xychelsea/deepfacelab:latest -f Dockerfile .
# $ docker run --rm -it xychelsea/deepfacelab:latest /bin/bash
# $ docker push xychelsea/deepfacelab:latest

ENV ANACONDA_ENV=deepfacelab
ENV DEEPFACELAB_PATH=/usr/local/deepfacelab
ENV DEEPFACELAB_PYTHON=python3.7
ENV DEEPFACELAB_HOME=${HOME}/deepfacelab
ENV DEEPFACELAB_WORKSPACE=${DEEPFACELAB_PATH}/workspace
ENV DEEPFACELAB_SCRIPTS=${DEEPFACELAB_PATH}/scripts

# Start as root
USER root

# Update packages
RUN apt-get update --fix-missing \
    && apt-get -y upgrade \
    && apt-get -y dist-upgrade

# Install dependencies
RUN apt-get -y install \
    git \
    libglu1-mesa-dev

# Create DeepFaceLab directory
RUN mkdir -p ${DEEPFACELAB_PATH} \
    && fix-permissions ${DEEPFACELAB_PATH}

# Switch to user "anaconda"
USER ${ANACONDA_UID}
WORKDIR ${HOME}

# Update Anaconda
RUN conda update -c defaults conda

# Install DeepFaceLab
RUN conda create -c main -n deepfacelab python=3.7

RUN conda run -n deepfacelab pip3 install \
	tqdm \
	numpy==1.19.3 \
	h5py==2.10.0 \
	opencv-python==4.1.0.25 \
	ffmpeg-python==0.1.17 \
	scikit-image==0.14.2 \
	scipy==1.4.1 \
	colorama \
	tensorflow==2.4.0 \
	pyqt5

RUN git clone git://github.com/xychelsea/deepfacelab.git ${DEEPFACELAB_PATH} \
    && mkdir -p ${DEEPFACELAB_WORKSPACE} \
    && rm -rvf ${ANACONDA_PATH}/share/jupyter/lab/staging

# Switch back to root
USER root

RUN fix-permissions ${DEEPFACELAB_WORKSPACE} \
    && fix-permissions ${DEEPFACELAB_SCRIPTS} \
    && chmod +x ${DEEPFACELAB_SCRIPTS}/*.sh \
    && ln -s ${DEEPFACELAB_WORKSPACE} ${HOME}/workspace \
    && ln -s ${DEEPFACELAB_SCRIPTS} ${HOME}/scripts

# Clean Anaconda
RUN conda clean -afy

# Clean packages and caches
RUN apt-get --purge -y autoremove git \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* \
    && rm -rvf /home/${ANACONDA_PATH}/.cache/yarn \
    && fix-permissions ${HOME} \
    && fix-permissions ${ANACONDA_PATH}

# Re-activate user "anaconda"
USER $ANACONDA_UID
WORKDIR $HOME
