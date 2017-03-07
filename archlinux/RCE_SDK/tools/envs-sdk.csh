# Set up a minimal environment in tcsh for using the Cluster Computing
# Toolkit Software Development Kit (SDK) for Linux
#

# tcsh trickery to get the full path to the parent directory
# for a sourced file
set sourced=`/usr/sbin/lsof +p $$ | grep -oE /.\*envs-sdk.csh`
set _sdkroot=`dirname $sourced`
set _sdkroot=`cd ${_sdkroot}/.. >& /dev/null && pwd`

# Initialize path variables if not set
if (${?PATH} == 0)            then
  setenv PATH
endif

# Add the SDK compiler wrappers to the path
setenv PATH ${PATH}:${_sdkroot}/bin

#####################################################################
cleanup:

unset _sdkroot
unset sourced

