#!/bin/sh
#
# Usage:  rce-firsrboot.sh <update_id> <dtm>
#
# First boot installation of the RCE target archlinux filesystem.
#
# If option [dtm] is present, this is a DTM, and additional
# items are installed (services, dhcp, minicomm nfsd)

# This is always true
sdkroot=/opt/RCE_SDK
dtm=0
zed=0
rce_type=0

#SSH server default is to disable root login, so enable it
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

systemctl restart sshd

updateId=$1; shift
[ $# -gt 0 ] && [ $1 -gt 0 ] && rce_type=$1

[ ${rce_type} -eq 1 ] && dtm=1
[ ${rce_type} -eq 2 ] && zed=1

#create SD mount points
mkdir -p /mnt/boot
mkdir -p /mnt/linux
mkdir -p /mnt/rtems
mkdir -p /mnt/rtemsapp
mkdir -p /mnt/scratch

# Install required system utilities
pacman -U --noconfirm $sdkroot/tgt/linux/packages/system/*.xz

# Install RCE libraries
/bin/cp --remove-destination ${sdkroot}/lib/*.so /lib/

# Install RCE binaries
/bin/cp --remove-destination ${sdkroot}/bin/* /bin/

# Install mount services
services="rced mnt-boot mnt-linux mnt-rtems mnt-rtemsapp mnt-scratch"

# Enable DTM fmd ASAP
[ ${dtm} -eq 1 ] && services="fmd ${services}"

for service in ${services}; do
    /bin/cp ${sdkroot}/tgt/linux/$service.service /etc/systemd/system
    systemctl enable $service.service
    systemctl start $service.service
done

# For DTMs dhcp, nfsd
if [ ${dtm} -eq 1 ] ; then
  /bin/cp --remove-destination ${sdkroot}/tgt/linux/dtm_dhcp.sh /bin
  /bin/cp --remove-destination ${sdkroot}/tgt/linux/dhcpd.dtm.conf /etc
  /bin/cp --remove-destination ${sdkroot}/tgt/linux/packages/system/minirc/* /etc
  
  #Now create the nfs dsl update directory
  mkdir -p /srv/nfs4/dsl

  #generate IP network for NFS server DSL dir
  ipAddr=`hostname -i`

  oct1=$(echo ${ipAddr} | tr "." " " | awk '{ print $1}')
  oct2=$(echo ${ipAddr} | tr "." " " | awk '{ print $2}')
  oct3=$(echo ${ipAddr} | tr "." " " | awk '{ print $3}')
  oct4=$(echo ${ipAddr} | tr "." " " | awk '{ print $4}')

  ipNet="/srv/nfs4 $oct1.$oct2.$oct3.0/24(rw,fsid=0,sync,no_subtree_check,nohide)"
  rm -f /etc/exports
  echo "$ipNet" > /etc/exports
  ipNet="/srv/nfs4/dsl $oct1.$oct2.$oct3.0/24(rw,no_subtree_check,nohide)"
  echo "$ipNet" >> /etc/exports
  
  #Support ancient NFS V2
  rm -f /etc/conf.d/nfs-server.conf
  echo 'NFSD_OPTS="-V 2"\nMOUNTD_OPTS=""\nSVCGSSD_OPTS=""' > /etc/conf.d/nfs-server.conf
  
  # For DTMs, add add dhcp to the service list.
  /bin/cp ${sdkroot}/tgt/linux/dtm_dhcp.service /etc/systemd/system
  /bin/cp ${sdkroot}/tgt/linux/dtm_dhcp.sh /bin
  systemctl enable dtm_dhcp; systemctl start dtm_dhcp
  systemctl enable nfs-server; systemctl start nfs-server
fi

sed -i 's/DHCP=yes/DHCP=no/' /etc/systemd/network/eth0.network

#For NFS client and RCE daemon
services="rpcbind nfs-client.target"

#Now enable and start remaining services
for service in ${services}; do
  systemctl enable $service
  systemctl start $service
done  

#restart the interface
ifconfig eth0 down
ifconfig eth0 up

#restart the dhcp client
if [ ${dtm} -eq 0 ] ; then
systemctl enable dhcpcd
systemctl start dhcpcd
fi

# Update bootloader and firmware
[ ${rce_type} -eq 0 ] && /bin/cp --remove-destination ${sdkroot}/tgt/boot/dpm/* /mnt/boot
[ ${rce_type} -eq 1 ] && /bin/cp --remove-destination ${sdkroot}/tgt/boot/dtm/* /mnt/boot
[ ${rce_type} -eq 2 ] && /bin/cp --remove-destination ${sdkroot}/tgt/boot/zed/* /mnt/boot

# Update the kernel
/bin/cp --remove-destination ${sdkroot}/tgt/linux/kernel/* /mnt/linux/

# Save the update ID and tag
rm -f /last_update
echo "${updateId}" "$(cat ${sdkroot}/TAG)" > /last_update

# Delete the firstboot service
[ ${rce_type} -eq 0 ] && rm /etc/systemd/system/multi-user.target.wants/rce-firstboot.service
[ ${rce_type} -eq 1 ] && rm /etc/systemd/system/multi-user.target.wants/dtm-firstboot.service
[ ${rce_type} -eq 2 ] && rm /etc/systemd/system/multi-user.target.wants/zed-firstboot.service

sync
