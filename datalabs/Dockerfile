## original: https://gitlab.astro.unige.ch/savchenk/osa-docker-python/-/blob/master/Dockerfile

ARG X_BASE_VERSION=stable
ARG REGISTRY=scidockreg.esac.esa.int:62510
FROM ${REGISTRY}/datalabs/x_base:${X_BASE_VERSION}-20.4
ARG DEBIAN_FRONTEND=noninteractive


RUN echo 'deb http://dk.archive.ubuntu.com/ubuntu/ trusty main universe' >> /etc/apt/sources.list && \
    echo 'deb http://dk.archive.ubuntu.com/ubuntu/ trusty-updates main universe' >> /etc/apt/sources.list && \
    apt-get update -y

COPY list_packages.txt /media/list_packages.txt
COPY requirements.txt /media/requirements.txt 
COPY environment.yml /media/environment.yml

RUN apt-get install -y $(cat /media/list_packages.txt) \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
  
RUN cp -fv /usr/bin/gfortran-4.4 /usr/bin/g95 \
    ln -s /usr/lib64/libpcre.so.1 /usr/lib64/libpcre.so.0

# OSA
WORKDIR /opt/
ARG OSA_VERSION=11.2-2-g667521a3-20220403-190332
ARG OSA_PLATFORM=Ubuntu_20.04_x86_64
RUN if [ ${OSA_VERSION} == "10.2" ]; then \
        echo "with OSA11, we will always install OSA10.2 for compatibility"; \
    else \
        wget -q https://www.isdc.unige.ch/~savchenk/gitlab-ci/integral/build/osa-build-binary-tarball/${OSA_PLATFORM}/${OSA_VERSION}/build-latest/osa-${OSA_VERSION}-${OSA_PLATFORM}.tar.gz && \
        tar xzf osa-${OSA_VERSION}-*.tar.gz && \
        rm -fv osa-${OSA_VERSION}-*.tar.gz && \
        mv osa11 osa; \
    fi && \
    wget -q https://www.isdc.unige.ch/integral/download/osa/sw/10.2/osa10.2-bin-ubuntu.tar.gz && \
    tar xzf osa10.2-bin-ubuntu.tar.gz && \
    rm -fv osa10.2-bin-ubuntu.tar.gz

WORKDIR /

### isda ref cat
ARG isdc_ref_cat_version=44.0

RUN wget -q https://www.isdc.unige.ch/integral/download/osa/cat/osa_cat-${isdc_ref_cat_version}.tar.gz && \
    tar xvzf osa_cat-${isdc_ref_cat_version}.tar.gz && \
    mkdir -pv /data/ && \
    mv osa_cat-${isdc_ref_cat_version}/cat /data/ && \
    rm -rf osa_cat-${isdc_ref_cat_version} osa_cat-${isdc_ref_cat_version}.tar.gz

ARG OS_VERSION=ubuntu20
ARG DS9_VERSION=ds9.ubuntu20.8.5.tar.gz

RUN wget -q -O ds9.tar.gz https://ds9.si.edu/download/${OS_VERSION}/${DS9_VERSION} \
  && tar xzvf ds9.tar.gz \
  && mv ds9 /usr/local/bin/ds9 \
  && chmod +x /usr/local/bin/ds9 \
  && rm -f ds9.tar.gz

COPY init.sh /init.sh

####

# python

RUN git clone https://github.com/pyenv/pyenv.git /pyenv

ARG python_version=3.10.14

RUN echo 'export PYENV_ROOT=/pyenv; export PATH="/pyenv/bin:$PATH"' >> /etc/pyenvrc && \
    echo 'eval "$(pyenv init -)"' >> /etc/pyenvrc && \
    source /etc/pyenvrc && PYTHON_CONFIGURE_OPTS="--enable-shared"  CFLAGS="-fPIC" CXXFLAGS="-fPIC" pyenv install $python_version && pyenv versions
RUN source /etc/pyenvrc && pyenv shell $python_version && pyenv global $python_version && pyenv versions && pyenv rehash

RUN echo 'source /etc/pyenvrc' >> /init.sh

RUN pip install --no-cache-dir --upgrade pip==24.0 && \
    pip install --no-cache-dir --upgrade setuptools==69.0.3

RUN export HOME_OVERRRIDE=/tmp/home && mkdir -pv /tmp/home/pfiles && \
    source /init.sh \
    && conda env update -q -f /media/environment.yml || echo "Conda did not work!" \
    && pip install --no-cache-dir --upgrade -r /media/requirements.txt || echo "Issues with requirements" \
    && conda clean -y --all


WORKDIR /opt
RUN wget --progress=dot:giga http://www.isdc.unige.ch/integral/download/osa/sw/heasoft/heasoft-Ubuntu_20.04_x86_6.tar.gz && \
    tar xfz heasoft-Ubuntu_20.04_x86_6.tar.gz && \
    rm heasoft-Ubuntu_20.04_x86_6.tar.gz

WORKDIR /
RUN p=$(ls -d /opt/heasoft/x86*/); echo "found HEADAS: $p"; echo 'export HEADAS="'$p'"; source $HEADAS/headas-init.sh' >> /init.sh

RUN export HOME_OVERRRIDE=/tmp/home && mkdir -pv /tmp/home/pfiles && \
    source /init.sh && \
    git clone https://github.com/volodymyrss/heasoft-heasp.git /heasoft-heasp



RUN export HOME_OVERRRIDE=/tmp/home && mkdir -pv /tmp/home/pfiles && \
    source /init.sh && \
    pip install --no-cache-dir git+https://github.com/volodymyrss/data-analysis@py3 && \
    pip install --no-cache-dir git+https://github.com/volodymyrss/pilton@e1ac14d6a2dce7ec96f7ca72fc80d376941eacba && \
    pip install --no-cache-dir git+https://github.com/volodymyrss/dda-ddosa@3492b6a17c850b0c743451ebd12888fac4c561b6

RUN export HOME_OVERRRIDE=/tmp/home && mkdir -pv /tmp/home/pfiles && \
    source /init.sh && \
    pip install --no-cache-dir  git+https://github.com/volodymyrss/dqueue.git@5b7e6a1b4cea280a843f0f38b65ef91cedf95320


COPY activate.sh /activate.sh

RUN ls -lta  /opt/heasoft/x86_64-pc-linux-gnu-libc2.31

COPY tests /tests
COPY xstartup.sh /etc/

