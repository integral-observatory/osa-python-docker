exec 2> >(awk '{print "\033[90m", strftime("%Y-%m-%dT%H:%M:%S"), "\033[31m", $0, "\033[0m"}')
exec > >(awk '{print "\033[90m", strftime("%Y-%m-%dT%H:%M:%S"), "\033[0m", $0}')


for t in $(ls $PWD/test_*.sh); do 
    echo -e "\n\n=================================="
    echo -e "= \033[33mrunning test\033[0m $t"
    (
        TESTDIR=${TMPDIR:-/tmp}/${t//\//_}
        mkdir -p $TESTDIR
        cd $TESTDIR

        export HOME_OVERRRIDE=/tmp
        if bash $t > log 2>&1; then
            echo -e "\033[32m SUCCESS \033[0m"
            [ "$DEBUG" == "yes" ] && cat log | awk '{print "\033[35m"$0"\033[0m"}'
        else
            echo -e "\033[31m FAILED \033[0m"
            cat log
        fi
    )
done
