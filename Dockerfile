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

FROM xychelsea/anaconda3:v0.2
LABEL description="DeepFaceLab Vanilla Container"

# $ docker build --network=host -t xychelsea/deepfacelab:latest -f Dockerfile .
# $ docker run --rm -it xychelsea/deepfacelab:latest /bin/bash
# $ docker push xychelsea/deepfacelab:latest

ENV ANACONDA_ENV=deepfacelab
ENV DEEPFACELAB_PATH=/usr/local/deepfacelab
ENV DEEPFACELAB_PYTHON=python3.8
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
RUN conda create -c conda-forge -n deepfacelab \
        ca-certificates==2020.12.5 \
        chardet==3.0.4 \
        colorama==0.4.4 \
        ffmpeg==4.3.1 \
        ffmpeg-python==0.2.0 \
        idna==2.10 \
        numpy==1.19.5 \
        pyqt==5.12.3 \
        python==3.8.6 \
        py-opencv==4.5.0 \
        setuptools==49.6.0 \
        scipy==1.6.0 \
        six==1.15.0 \
        tensorboard==2.4.1 \
        tensorboard-plugin-wit==1.8.0 \
        tqdm==4.56.0 \
        werkzeug==1.0.1 \
        wheel==0.36.2 \
    && PATH=${ANACONDA_PATH}/envs/${ANACONDA_ENV}/bin/:$PATH \
    && pip install \
        tensorflow==2.4.0 \
    && git clone git://github.com/xychelsea/deepfacelab.git ${DEEPFACELAB_PATH} \
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
