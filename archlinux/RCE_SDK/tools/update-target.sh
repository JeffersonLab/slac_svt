#!/bin/sh
#
# Usage:  update-target.sh <update_id> <dtm>
#
# Upgrades the target's archlinux system to what's in the tarball.
# 
# If option [dtm] is present, this is a DTM, and additional
# items are installed (services, dhcp, minicom stuff)

mkdir -p /mnt/scratch/.dslupdate
cp -r /mnt/dslupdate/* /mnt/scratch/.dslupdate

# This is always true
sdkroot=/mnt/scratch/.dslupdate
dtm=0

updateId=$1; shift
[ $# -gt 0 ] && [ $1 -gt 0 ] && dtm=1

# Install libraries
/bin/cp --remove-destination ${sdkroot}/lib/*.so /lib/

#must rename rced before it can be overwritten
mv /usr/bin/rced /tmp

/bin/cp --remove-destination ${sdkroot}/tgt/linux/*.service /etc/systemd/system/

#For NFS client and RCE daemon
services="rpcbind rced"

# For DTMs dhcpd, nfsd
if [ ${dtm} -eq 1 ] ; then
  #must rename fmd before it can be overwritten
  mv /usr/bin/fmd /tmp

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

  ipNet="/srv/nfs4 $oct1.$oct2.$oct3.0/24(rw,fsid=0,no_subtree_check,nohide)"
  rm -f /etc/exports
  echo "$ipNet" > /etc/exports
  ipNet="/srv/nfs4/dsl $oct1.$oct2.$oct3.0/24(rw,no_subtree_check,nohide)"
  echo "$ipNet" >> /etc/exports

  #Support ancient NFS V2
  rm -f /etc/conf.d/nfs-server.conf
  echo 'NFSD_OPTS="-V 2"\nMOUNTD_OPTS=""\nSVCGSSD_OPTS=""' > /etc/conf.d/nfs-server.conf
fi

# Install binaries
/bin/cp --remove-destination ${sdkroot}/bin/* /bin/

#remove duplicate dhcp request - already handled by dhcpcd
sed -i 's/DHCP=yes/DHCP=no/' /etc/systemd/network/eth0.network

#Now enable remaining services
for service in ${services}; do
  systemctl enable $service.service
done  

# Update bootloader and firmware
[ ${dtm} -eq 1 ] && /bin/cp --remove-destination ${sdkroot}/tgt/boot/dtm/* /mnt/boot
[ ${dtm} -eq 0 ] && /bin/cp --remove-destination ${sdkroot}/tgt/boot/dpm/* /mnt/boot

# Update the kernel
/bin/cp --remove-destination ${sdkroot}/tgt/linux/kernel/* /mnt/linux/

# Save the update ID and tag
rm -f /last_update
echo "${updateId}" "$(cat ${sdkroot}/TAG)" > /last_update

umount -l /mnt/dslupdate
rm -rf $sdkroot
sync

reboot_rce
