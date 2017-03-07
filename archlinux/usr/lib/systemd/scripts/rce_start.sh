#!/bin/sh

# method used at JLab to set hostnames, not used at SLAC
#SHELF=campshm01
CHOST=129.57.167.16
#GW=129.57.68.100

# route add default gw $GW # not needed for SLAC

# mount manually the nfs folders needed
# not needed at SLAC -> mount from fstab instead 
mount -t nfs -o nolock $CHOST:/vol/clas12/release/1.3.0/slac_svt/svtdaq /mnt/host
mount -t nfs -o nolock $CHOST:/vol/home                               /mnt/home
mount -t nfs -o nolock $CHOST:/vol/clas12                             /mnt/clas12

# Below is method to find RCE ID w/o hostname
RCEID=$((/usr/bin/sysinfo | grep "RCE ID")| tr "." " " | awk '{print $3}')
SHELF=$(awk -F/ '{print $1}' <<<"${RCEID}")

#wait for rced to set hostname
sleep 3


# Change Hostname
case $RCEID in 
   "$SHELF/4/0/0")
      hostname dpm0
      ;;
   "$SHELF/4/0/2")
      hostname dpm1
      ;;
   "$SHELF/4/1/0")
      hostname dpm2
      ;;
   "$SHELF/4/1/2")
      hostname dpm3
      ;;
   "$SHELF/4/2/0")
      hostname dpm4
      ;;
   "$SHELF/4/2/2")
      hostname dpm5
      ;;
   "$SHELF/4/3/0")
      hostname dpm6
      ;;
   "$SHELF/4/3/2")
      hostname dpm7
      ;;
   "$SHELF/4/4/0")
      hostname dtm0
      ;;
   "$SHELF/5/0/0")
      hostname dpm8
      ;;
   "$SHELF/5/0/2")
      hostname dpm9
      ;;
   "$SHELF/5/1/0")
      hostname dpm10
      ;;
   "$SHELF/5/1/2")
      hostname dpm11
      ;;
   "$SHELF/5/2/0")
      hostname dpm12
      ;;
   "$SHELF/5/2/2")
      hostname dpm13
      ;;
   "$SHELF/5/3/0")
      hostname dpm14
      ;;
   "$SHELF/5/3/2")
      hostname dpm15
      ;;
   "$SHELF/5/4/0")
      hostname dtm1
      ;;
esac

# load kernel module
# insmod /mnt/host/daq/AxiStreamDma/driverV3/AxiStreamDmaModule.ko cfgRxSize=1646592,4096,0,0 cfgRxCount=10,8,0,0 # used at JLab
insmod /mnt/host/daq/AxiStreamDma/driverV3_4.00/AxiStreamDmaModule.ko cfgRxSize=1646592,4096,0,0 cfgRxCount=10,8,0,0
chmod a+rw /dev/axi*


# Start DAQ server
/mnt/host/daq/rceScripts/start_server.csh

