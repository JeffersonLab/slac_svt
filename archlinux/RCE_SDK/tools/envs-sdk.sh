# Set up a minimal environment in bash for using the Cluster Computing
# Toolkit Software Development Kit (SDK) for Linux
#
# This file is meant to be sourced from a shell


# bash trickery to get the full path to the parent directory
# for a sourced file
_sdkroot=$(dirname ${BASH_SOURCE})
_sdkroot=$(cd ${_sdkroot}/.. > /dev/null 2>&1 && pwd)

# Initialize path variables if not set
if test -z ${PATH};           then export PATH;               fi

# Add the _SDK compiler wrappers to the path
export PATH=${_sdkroot}/bin:${PATH}
  
#####################################################################
# cleanup

unset _sdkroot



