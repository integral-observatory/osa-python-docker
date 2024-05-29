export HOME=${HOME_OVERRRIDE:-/home/integral}

export ISDC_REF_CAT=/data/user/isdc/cat/hec/gnrl_refr_cat_0043.fits #TODO: use a variable, substitute from build time
export ISDC_OMC_CAT=/data/user/isdc/cat/omc/omc_refr_cat_0005.fits
export REP_BASE_PROD=/data/user/isdc

export ISDC_ENV=/opt/osa

[ -s $ISDC_ENV/bin/isdc_init_env.sh ] && 
    source $ISDC_ENV/bin/isdc_init_env.sh

[ -s /opt/osa/root/bin/thisroot.sh ] && 
    source /opt/osa/root/bin/thisroot.sh


