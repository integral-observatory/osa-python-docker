set -ex

export PLATFORM=$(lsb_release -ds | tr \  _)_$(uname -m)

echo -e "\033[32mPLATFORM: $PLATFORM\033[0m"

export PACKAGE_ROOT=/opt/osa11

export BUILDER_VERSION=${CI_COMMIT_TAG:-${CI_COMMIT_SHA::8}}

COMMIT_TIME=$(date --utc +%Y%m%d-%H%M%S -d "$(git show -s --format=%ai | awk '{print $1" "$2}')")
export BUILDER_VERSION_LONG=$(git describe --abbrev=8 --dirty --always --tags)-$COMMIT_TIME

echo "osa-build builder version: $BUILDER_VERSION_LONG"

SOURCE_PLATFORM=CentOS_7.7.1908_x86_64


export VURL=https://www.isdc.unige.ch/~savchenk/gitlab-ci/integral/build/osa-build-tarball/${SOURCE_PLATFORM:?}/latest/latest/osa-version-ref.txt
export OSA_VERSION=$(wget -q -O- $VURL || curl $VURL)


echo "found OSA version from the tarball: $OSA_VERSION"

export OSA_DIRECTORY_TAG=osa-$OSA_VERSION/osa-build-$BUILDER_VERSION_LONG
export ISDC_ENV=${PACKAGE_ROOT:?}


mkdir -pv $ISDC_ENV

URL="https://www.isdc.unige.ch/~savchenk/gitlab-ci/integral/build/osa-build-tarball/${SOURCE_PLATFORM:?}/latest/latest/component-list-snapshot.txt"
wget --no-check-certificate $URL -O $ISDC_ENV/VERSION || curl $URL -o $ISDC_ENV/VERSION 

#`date +%Y%m%d_%H%M%S`

export PATH=$ISDC_ENV/bin:$PATH

builddir=${TMPDIR:-/tmp}/build

export F90=gfortran #f95
export F95=gfortran #f95
export F77=gfortran #f95
export CC="gcc" # -Df2cFortran"
export CXX="g++" # -Df2cFortran"
source $PACKAGE_ROOT/root/bin/thisroot.sh

export LDFLAGS=""

osa_builddir=$builddir/osa-current
mkdir -pv $osa_builddir 
cd $osa_builddir

(
    curl https://www.isdc.unige.ch/~savchenk/gitlab-ci/integral/build/osa-build-tarball/${SOURCE_PLATFORM:?}/${OSA_VERSION}/latest/osa-${SOURCE_PLATFORM}-src.tar.gz | tar xzf -
) || (
    wget -q -O- https://www.isdc.unige.ch/~savchenk/gitlab-ci/integral/build/osa-build-tarball/${SOURCE_PLATFORM:?}/${OSA_VERSION}/latest/osa-${SOURCE_PLATFORM}-src.tar.gz | tar xzf -
)



if echo "$PLATFORM" | grep CentOS_5 ; then
    export CC="gcc44 -fPIC"
    export CXX="g++44 -fPIC"
    export F90=gfortran44
    export FC=gfortran44
fi

if echo $PLATFORM | grep Ubuntu; then
    echo -e "\033[32mTUNING:\033[0m using gcc 4 at ubuntu"

    export CC="gcc-4.8"
    export CXX="g++-4.8"
    export F90=gfortran-4.8
    export FC=gfortran-4.8

    (
        cd osa/analysis-sw/jemx
        sed '890s/isnan(/isnan( (double)/' `find -name j_cor_gain_get_osm.c`  -i
    )
fi


cd osa

unset CFLAGS && unset LDFLAGS && unset CPPFLAGS && unset CXXFLAGS 


./support-sw/makefiles/ac_stuff/configure 
export CXXFLAGS="-fPIC"
export CFLAGS="-fPIC"
export LDFLAGS="-fPIC"
make install

cd /

rm -rf ${osa_builddir:?}
