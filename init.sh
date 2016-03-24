#!/bin/sh 
DEMO="Cloud JBoss BRMS Install Demo"
AUTHORS="Andrew Block, Eric D. Schabell"
PROJECT="git@github.com:eschabell/rhcs-brms-install-demo.git"

# wipe screen.
clear 

echo
echo "##########################################################"
echo "##                                                      ##"   
echo "##  Setting up the ${DEMO}        ##"
echo "##                                                      ##"   
echo "##                                                      ##"   
echo "##     ####  ####  #   #  ####        ###   #### #####  ##"
echo "##     #   # #   # ## ## #       #   #   # #     #      ##"
echo "##     ####  ####  # # #  ###   ###  #   #  ###  ###    ##"
echo "##     #   # # #   #   #     #   #   #   #     # #      ##"
echo "##     ####  #  #  #   # ####         ###  ####  #####  ##"
echo "##                                                      ##"   
echo "##  brought to you by,                                  ##"   
echo "##             ${AUTHORS}           ##"
echo "##                                                      ##"   
echo "##  ${PROJECT} ##"
echo "##                                                      ##"   
echo "##########################################################"
echo

# make some checks first before proceeding.	
command -v oc -v >/dev/null 2>&1 || { echo >&2 "OpenShift command line tooling is required but not installed yet... download here:
https://developers.openshift.com/managing-your-applications/client-tools.html"; exit 1; }

echo "OpenShift commandline tooling is installed..."
echo 
echo "Loging into OSE..."
echo
oc login 10.1.2.2:8443 --password=admin --username=admin

if [ $? -ne 0 ]; then
	echo
	echo Error occurred during 'oc login' command!
	exit
fi

echo
echo "Creating a new project..."
echo
oc new-project rhcs-brms-install-demo 

echo
echo "Setting up a new build..."
echo
oc new-build "jbossdemocentral/developer" --name=rhcs-brms-install-demo --binary=true

if [ $? -ne 0 ]; then
	echo
	echo Error occurred during 'oc new-build' command!
	exit
fi

echo
echo "Importing developer image..."
echo
oc import-image developer

if [ $? -ne 0 ]; then
	echo
	echo Error occurred during 'oc import-image' command!
	exit
fi

echo
echo "Starting a build, this takes some time to upload all of the product sources for build..."
echo
oc start-build rhcs-brms-install-demo --from-dir=.

if [ $? -ne 0 ]; then
	echo
	echo Error occurred during 'oc start-build' command!
	exit
fi

echo
echo "Watch the build by running the following repeatedly until builds completes:"
echo
echo "    $ oc logs rhcs-brms-install-demo-1-build"
echo
echo
echo "===================================================================="
echo "=                                                                  ="
echo "=  When build finishes you need to run a few more commands to      ="
echo "=  complete the application deployment onto OpenShift Enterprise:  ="
echo "=                                                                  ="
echo "=  1. Create a new application:                                    ="
echo "=                                                                  ="
echo "=         $ oc new-app rhcs-brms-install-demo                      ="
echo "=                                                                  ="
echo "=                                                                  ="
echo "=  2. Expose the application as a service:                         ="
echo "=                                                                  ="
echo "=         $ oc expose service rhcs-brms-install-demo  \            ="
echo "= 	           --hostname=rhcs-brms-install-demo.10.1.2.2.xip.io   ="
echo "=                                                                  ="
echo "=                                                                  ="
echo "=  Login to JBoss BRMS to start developing rules projects:         ="
echo "=                                                                  ="
echo "=  http://rhcs-brms-install-demo.10.1.2.2.xip.io/business-central  ="
echo "=                                                                  ="
echo "=  [ u:erics / p:jbossbrms1! ]                                      ="
echo "=                                                                  ="
echo "===================================================================="

