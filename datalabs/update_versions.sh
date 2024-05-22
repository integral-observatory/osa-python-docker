#!/bin/bash

#These lines should be uncommented at need. Some versions of packages might be outdated

# Get the packages from Dockerfile
#grep -E '^[ ]{4}[a-z,-]+=[0-9]+*' Dockerfile | grep -v "==" | awk -F "=" '{print $1}' > apt-packages.txt

# Get the packages from dockerfile with version
grep -E '^[ ]{4}[a-z,-]+=[0-9]+*' Dockerfile | grep -v "==" > apt-packages_complete.txt

# Get the versions from a local installation of Ubuntu
#apt list | grep focal | grep amd > local.txt
#for a in `cat apt-packages.txt`; do grep -E "^${a}/" local.txt; done | awk '{print $2}' > new_versions.txt

#Update the Dockerfile (then check and copy it over to Dockerfile)
cp Dockerfile tmp_dockerfile.txt
for p in `cat apt-packages_complete.txt`; do 
	a=`echo ${p} | awk -F "=" '{print $1}'`
	b=`grep -E "^${a}/" local.txt | awk '{print $2}'`
	if [ ! -z ${b} ]; 
	then 
		sed "s/${p}/${a}=${b}/" tmp_dockerfile.txt > tmp_dockerfile_2.txt
		mv tmp_dockerfile_2.txt tmp_dockerfile.txt
	fi; 
done


