## original: https://gitlab.astro.unige.ch/savchenk/osa-docker-python/-/blob/master/Dockerfile

#ARG JL_BASE_VERSION=stable
#ARG REGISTRY=scidockreg.esac.esa.int:62530
#FROM ${REGISTRY}/datalabs/jl_base:${JL_BASE_VERSION}-20.4
#ARG DEBIAN_FRONTEND=noninteractive

FROM ubuntu:20.04

ARG   DEBIAN_FRONTEND=noninteractive
RUN   apt-get update \
&&  apt-get install -y gosu libnss-ldapd build-essential libssl-dev curl
RUN   curl -LO https://github.com/krallin/tini/releases/download/v0.18.0/tini
RUN   mv tini /sbin/tini
RUN   chmod +x /sbin/tini
RUN apt-get update \
&& DEBIAN_FRONTEND=noninteractive \
&& apt-get install --no-install-recommends -y \
        python3-pip 
RUN pip install xvfbwrapper
RUN apt-get update \
&& DEBIAN_FRONTEND=noninteractive \
&& apt-get install --no-install-recommends -y \
  gcc g++ make sudo \
  build-essential --no-install-recommends apt-utils \
  zip unzip curl man wget make emacs vim \
  libffi-dev libzbar-dev libzbar0 libxml2-dev libxslt-dev python3-dev python3-lxml \
  nodejs yarn\
  software-properties-common coreutils \
  python3-pytest-xvfb python3-xvfbwrapper xvfb \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*
RUN apt-get update \
&& apt-add-repository ppa:git-core/ppa \
&& apt-get update \
&& apt-get install --no-install-recommends git -y \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*
 
WORKDIR /opt/
RUN curl -fsSL -o Miniconda3-Linux-x86_64.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
&& bash Miniconda3-Linux-x86_64.sh -b -p /opt/miniconda \
&& rm -rf Miniconda3-Linux-x86_64.sh
ENV PATH /opt/miniconda/bin:$PATH
RUN conda init \
&& conda update --all \
&& conda config --append channels conda-forge \
&& conda install -y nodejs


RUN python -m pip --no-cache-dir install \
  jupyterlab==3.6.5 \
  jupyter_client==7.1.1 \
  terminado==0.12.1 \
  jupyterlab-git==0.42.0 \
  jupyterlab_theme_solarized_dark==2.0.1 \
  qtconsole==5.2.2 \
  IPython==8.15.0 \
  nbclient==0.8.0 \
  notebook==6.4.7 \
  matplotlib==3.5.1 \
  pandas==1.4.0 \
  ipykernel==6.25.2 \
  ipyleaflet==0.17.3 \
  qtpy==2.0.0 \
  ipywidgets==8.1.0 \
  jupyterlab_widgets==3.0.8 \
  lxml==4.9.3 \
  flask-cors==3.0.10 \
  beautifulsoup4==4.10.0 \
  configparser==5.2.0 \
  ipyevents==2.0.1 \
  astroquery==0.4.5 \
  astropy==6.0.0 \
&& jupyter labextension install jupyter-matplotlib --no-build \
&& jupyter labextension install jupyter-leaflet --no-build \
&& jupyter labextension disable "@jupyterlab/apputils-extension:announcements" \
&& jupyter lab build --minimize=False \
&& python -m pip --no-cache-dir install pyesasky==1.9.5 \
&& jupyter labextension install pyesasky --no-build \
&& jupyter lab build --minimize=False \
&& jupyter nbextension install --py pyesasky --sys-prefix \
&& jupyter nbextension enable --py pyesasky --sys-prefix \
&& jupyter lab build --minimize=False \
&& ln -s /opt/miniconda/etc/profile.d/conda.sh /etc/profile.d/conda.sh



RUN apt-get update -y

RUN apt-get install --no-install-recommends --assume-yes -y \
    libssl-dev=1.1.1f-1ubuntu2.22 \
    devscripts=2.20.2ubuntu2 \
    libglu1-mesa-dev=9.0.1-1build1 \
    libfftw3-dev=3.3.8-2ubuntu1 \
    libgraphviz-dev=2.42.2-3build2 \
    libldap2-dev=2.4.49+dfsg-2ubuntu1.10 \
    python3-dev=3.8.2-0ubuntu2 \
    python3-tk=3.8.10-0ubuntu1~20.04 \
    cabal-install=2.4.0.0-2build3

# missing packages (needed??):
# fpm compat-gcc-44 compat-gcc-44-c++ compat-gcc-44-c++.gfortran

## from jl_base:
RUN apt-get install --no-install-recommends --assume-yes -y \
    gcc=4:9.3.0-1ubuntu2 \
    g++=4:9.3.0-1ubuntu2 \
    make=4.2.1-1.2 \
    build-essential=12.8ubuntu1.1 \
    apt-utils=2.0.10 \
    curl=7.68.0-1ubuntu2.22 \
    wget=1.20.3-1ubuntu2 \
    libffi-dev=3.3-4 \
    software-properties-common=0.99.9.12 \
    coreutils=8.30-3ubuntu2 

# additional packages installed for OSA Integral (needed to find APT equivalents for CentOS yum packages)
RUN apt-get install --no-install-recommends -y \
    bzip2=1.0.8-2 \
    checkinstall=1.6.2+git20170426.d24a630-2ubuntu1 \
    cmake=3.16.3-1ubuntu1.20.04.1 \
    curlftpfs=0.9.2-9build1 \
    fftw-dev=2.1.5-4.2build2 \
    file=1:5.38-4 \
    gfortran=4:9.3.0-1ubuntu2 \
   iptables=1.8.4-3ubuntu2.1 \
    libgfortran5=10.5.0-1ubuntu1~20.04 \
    libjpeg-dev=8c-2ubuntu8 \
    libncurses-dev=6.2-0ubuntu2.1 \
    libpng-dev=1.6.37-2 \
    libreadline-dev=8.0-4 \
    libyaml-dev=0.2.2-1 \
    libx11-dev=2:1.6.9-2ubuntu1.6 \
    libbz2-dev=1.0.8-2 \
    libxpm4=1:3.5.12-1ubuntu0.20.04.2 \
    libxpm-dev=1:3.5.12-1ubuntu0.20.04.2 \
    libpcre3-dev=2:8.39-12ubuntu0.1 \
    libcfitsio-dev=3.470-3 \
    libcfitsio8=3.470-3 \
    libgsl-dev=2.5+dfsg-6+deb10u1build0.20.04.1 \
    libxml2-dev=2.9.10+dfsg-5ubuntu0.20.04.7 \
    libsqlite3-dev=3.31.1-4ubuntu0.6 \
    libmysqlclient-dev=8.0.36-0ubuntu0.20.04.1 \
    libglew-dev=2.1.0-4 \
    libavahi-compat-libdnssd1=0.7-4ubuntu7.3 \
    net-tools=1.60+git20180626.aebd88e-1ubuntu1 \
    openssl=1.1.1f-1ubuntu2.22 \
    patch=2.7.6-6 \
    python3-pip=20.0.2-5ubuntu1.10 \
    readline-common=8.0-4 \
    ruby=1:2.7+1 \
    ruby-dev=1:2.7+1 \
    sqlite=2.8.17-15fakesync1build1 \
    sqlite3=3.31.1-4ubuntu0.6 \
    strace=5.5-3ubuntu1 \
    sshfs=3.6.0+repack+really2.10-0ubuntu1 \
    sudo=1.8.31-1ubuntu1.5 \
    zlib1g-dev=1:1.2.11.dfsg-2ubuntu1.5 \
    zlib1g=1:1.2.11.dfsg-2ubuntu1.5 \
    libxslt1-dev=1.1.34-4ubuntu0.20.04.1

RUN apt-get install --no-install-recommends -y --allow-downgrades \
    bison=2:3.5.1+dfsg-1 \
    libgl1-mesa-glx=21.2.6-0ubuntu0.1~20.04.2 \
    git-man=1:2.25.1-1ubuntu3.12 \
    git=1:2.25.1-1ubuntu3.12 \
    git-lfs=2.9.2-1 \
    libncurses5-dev=6.2-0ubuntu2.1 \
    less=551-1ubuntu0.3

RUN apt-get install --no-install-recommends -y \
    libxext6=2:1.3.4-0ubuntu1 \
    libxext-dev=2:1.3.4-0ubuntu1 \
    rpm=4.14.2.1+dfsg1-1build2 \
    libxt-dev=1:1.1.5-1 \
    libxft-dev=2.3.3-0ubuntu1 \
    libftgl-dev=2.4.0-2ubuntu1 \
    perl=5.30.0-9ubuntu0.5 

# some extra
RUN apt-get install --no-install-recommends -y \
    openbox=3.6.1-9ubuntu0.20.04.1 \
    xorg=1:7.7+19ubuntu14 \
    vim=2:8.1.2269-1ubuntu5.22

RUN apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/lib64/libpcre.so.1 /usr/lib64/libpcre.so.0

# OSA
WORKDIR /opt/
ARG OSA_VERSION=11.2-2-g667521a3-20220403-190332
ARG OSA_PLATFORM=Ubuntu_20.04_x86_64
RUN cd /opt/ && \
    if [ ${OSA_VERSION} == "10.2" ]; then \
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

ARG python_version=3.10.2

RUN echo 'export PYENV_ROOT=/pyenv; export PATH="/pyenv/bin:$PATH"' >> /etc/pyenvrc && \
    echo 'eval "$(pyenv init -)"' >> /etc/pyenvrc

RUN source /etc/pyenvrc && PYTHON_CONFIGURE_OPTS="--enable-shared"  CFLAGS="-fPIC" CXXFLAGS="-fPIC" pyenv install $python_version && pyenv versions
RUN source /etc/pyenvrc && pyenv shell $python_version && pyenv global $python_version && pyenv versions && pyenv rehash

RUN echo 'source /etc/pyenvrc' >> /init.sh

RUN apt-get update && apt-get install -y \
    wcslib-dev=7.1+ds-2 \
    swig=4.0.1-5build1\
    swig3.0=3.0.12-2.2ubuntu1

#RUN wget -q https://github.com/evo-cloud/hmake/releases/download/v1.3.1/hmake-linux-amd64.tar.gz && \
#    tar -zxvf hmake-linux-amd64.tar.gz && \
#    rm -rf hmake-linux-amd64.tar.gz

RUN pip install --no-cache-dir --upgrade pip==23.3.2 && \
    pip install --no-cache-dir --upgrade setuptools==69.0.3

RUN export HOME_OVERRRIDE=/tmp/home && mkdir -pv /tmp/home/pfiles && \
    source /init.sh && \
    pip install --no-cache-dir \
    numpy==1.26.3 \
    scipy==1.11.4 \
    ipython==8.19.0 \
    jupyter==1.0.0 \
    matplotlib==3.8.2 \
    pandas==2.1.4 \
    astropy==6.0.0

#ARG heasoft_version=6.25

#COPY build-heasoft.sh /build-heasoft.sh

#RUN export HOME_OVERRRIDE=/tmp/home && mkdir -pv /tmp/home/pfiles && \
#    source /init.sh && \
#    rm -rf /opt/heasoft && \
#    bash build-heasoft.sh build

WORKDIR /opt
RUN wget http://www.isdc.unige.ch/download/osa/sw/heasoft/heasoft-Ubuntu_20.04_x86_6.tar.gz && \
    tar xfz heasoft_Ubuntu_20.04_x86_6.tar.gz && \
    rm heasoft_Ubuntu_20.04_x86_6.tar.gz

WORKDIR /
RUN p=$(ls -d /opt/heasoft/x86*/); echo "found HEADAS: $p"; echo 'export HEADAS="'$p'"; source $HEADAS/headas-init.sh' >> /init.sh

RUN export HOME_OVERRRIDE=/tmp/home && mkdir -pv /tmp/home/pfiles && \
    source /init.sh && \
    git clone https://github.com/volodymyrss/heasoft-heasp.git /heasoft-heasp


#WORKDIR /heasoft-heasp/python 
#RUN export HOME_OVERRRIDE=/tmp/home && mkdir -pv /tmp/home/pfiles && \
#    source /init.sh && \
#    swig -python -c++ heasp.i && \
#    hmake install

#WORKDIR /heasoft-heasp
#RUN export HOME_OVERRRIDE=/tmp/home && mkdir -pv /tmp/home/pfiles && \
#    source /init.sh && \
#    hmake install

    #pip install --no-cache-dir -r https://raw.githubusercontent.com/volodymyrss/data-analysis/py3/requirements.txt && \
#WORKDIR /



RUN export HOME_OVERRRIDE=/tmp/home && mkdir -pv /tmp/home/pfiles && \
    source /init.sh && \
    pip install --no-cache-dir git+https://github.com/volodymyrss/data-analysis@py3 && \
    pip install --no-cache-dir git+https://github.com/volodymyrss/pilton@e1ac14d6a2dce7ec96f7ca72fc80d376941eacba && \
    pip install --no-cache-dir git+https://github.com/volodymyrss/dda-ddosa@3492b6a17c850b0c743451ebd12888fac4c561b6

RUN export HOME_OVERRRIDE=/tmp/home && mkdir -pv /tmp/home/pfiles && \
    source /init.sh && \
    pip install --no-cache-dir  git+https://github.com/volodymyrss/dqueue.git@5b7e6a1b4cea280a843f0f38b65ef91cedf95320


COPY activate.sh /activate.sh


# 3ml


RUN ls -lta  /opt/heasoft/x86_64-pc-linux-gnu-libc2.31

RUN export HOME_OVERRRIDE=/tmp/home && mkdir -pv /tmp/home/pfiles && \
    source /init.sh && \
    pip install --no-cache-dir \
    pymysql==1.1.0 \
    peewee==3.17.0

COPY tests /tests

#COPY xstartup.sh /etc/

#ENTRYPOINT bash -c 'export HOME_OVERRRIDE=/media/home; cd /media/home; source /init.sh; jupyter lab --ip 0.0.0.0 --no-browser'


CMD [ "sh", "-c", "/opt/miniconda/bin/jupyter lab --ip 0.0.0.0 --port=1234 --ServerApp.password='' --ServerApp.token=''"]
