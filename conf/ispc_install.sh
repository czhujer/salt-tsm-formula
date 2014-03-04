#/bin/sh
#
# ispc_inst.sh <NODE_NAME> <PASSWORD>
#
# T.Jindra, 7.2013, AG COM a.s.

# BEGIN EDITABLE GLOBAL VARIABLES


# BEGIN SCRIPT VARIABLES
if [ -e /etc/redhat-release ]
 then
  OSLEVEL=`cat /etc/redhat-release`
  INITDEFAULT=`cat /etc/inittab | grep initdefault | grep -v ^# | cut -d : -f 2`
fi
if [ -e /usr/bin/lsb_release ]
 then
  OSLEVEL=`/usr/bin/lsb_release -d | sed -e 's/Description:[\t]//g' | cut -b 1-12`
  INITDEFAULT=`cat /etc/init/rc-sysinit.conf | grep "env DEFAULT_RUNLEVEL" | cut -d "=" -f 2`
fi
DSMSYS=dsm_gen.sys
COMMON_INSTALL=com64
ARCH_X64=`uname -a | grep -c x86_64`
CS_LOCALE=`env | grep LANG | grep -c cs`
WORK_DIR=`pwd`

# BEGIN GLOBAL FUNCTIONS
# Install TSMC on Centos 6.x
InstCentOS6()
{
if [ $ARCH_X64 -eq 1 ]
 then
   yum localinstall -y ./CentOS_6.5/* ./com64/*
   if [ $CS_LOCALE -eq 1 ]
    then
     yum localinstall -y ./com64/CSY/*
   fi
 else
   yum localinstall -y ./Linux86/*
   if [ $CS_LOCALE -eq 1 ]
    then
     yum localinstall -y ./Linux86/CSY/*
   fi
fi
}

# Install TSMC on Ubuntu 12
InstUbnt12()
{
/usr/bin/aptitude update
/usr/bin/aptitude full-upgrade
/usr/bin/aptitude install alien libstdc++6 ksh ia32-libs
/usr/bin/dpkg -i ./Ubnt_12.4_x64/gskcrypt64-8.0.deb
/usr/bin/dpkg -i ./Ubnt_12.4_x64/gskssl64-8.0.deb
/usr/bin/dpkg -i ./Ubnt_12.4_x64/TIVsm-API64-6.3.1.deb
/usr/bin/dpkg -i ./Ubnt_12.4_x64/TIVsm-BA-6.3.1.deb
mkdir /var/lock/subsys
echo "/opt/tivoli/tsm/client/api/bin64" > /etc/ld.so.conf.d/tivoli.conf
echo "/usr/local/ibm/gsk8_64/lib64" >> /etc/ld.so.conf.d/tivoli.conf
#cd /usr/lib
ln -s /opt/tivoli/tsm/client/api/bin64/libgpfs.so /usr/lib/libgpfs.so
ln -s /opt/tivoli/tsm/client/api/bin64/libdmapi.so /usr/lib/libdmapi.so
ln -s /usr/local/ibm/gsk8_64/lib64/libgsk8ssl_64.so  /usr/lib/libgsk8ssl_64.so
ln -s /usr/local/ibm/gsk8_64/lib64/libgsk8iccs_64.so /usr/lib/libgsk8iccs_64.so
ln -s /usr/local/ibm/gsk8_64/lib64/libgsk8cms_64.so  /usr/lib/libgsk8cms_64.so
ln -s /usr/local/ibm/gsk8_64/lib64/libgsk8sys_64.so /usr/lib/libgsk8sys_64.so
ldconfig

}

ConfTSMC()
{
echo "SErvername $NODE_NAME " > /opt/tivoli/tsm/client/ba/bin/dsm.opt
echo "SErvername $NODE_NAME " > /opt/tivoli/tsm/client/ba/bin/dsm.sys
echo "NODEname $NODE_NAME " >> /opt/tivoli/tsm/client/ba/bin/dsm.sys
cat dsm_gen.sys >> /opt/tivoli/tsm/client/ba/bin/dsm.sys
}

StartTSMC()
{
cp ./tivoli.sh /etc/init.d/tivoli.sh
cd /etc/rc$INITDEFAULT.d
ln -s /etc/init.d/tivoli.sh ./S99tivoli

cd /opt/tivoli/tsm/client/ba/bin/
./dsmc q ses

/etc/init.d/tivoli.sh start

}

# BEGIN CHECKING INPUT PARAMETERS
if [ $# -lt 1 ]
 then
   echo "usage: $0 <NODE_NAME>"
   exit 1
fi

NODE_NAME=$1

case $OSLEVEL in
 "CentOS release 6.5 (Final)") OS_DEP_INSTALL=CentOS_6.5

 ;;
 "CentOS release 6.4 (Final)") OS_DEP_INSTALL=CentOS_6.4

 ;;
 "CentOS release 6.3 (Final)") OS_DEP_INSTALL=CentOS_6.3

 ;;
 "Ubuntu 12.04") OS_DEP_INSTALL=UbuntuOS_12.4.2

 ;;
                            *) echo "Unsuported OS: $OSLEVEL"
                               exit 1
 ;;
esac

echo "TSM client will be installed on OS: $OSLEVEL"
if [ $ARCH_X64 -eq 1 ]
 then
  echo "OS architecture: x64"
 else
  echo "OS architecture: x32"
fi

TCPSERVER_ADDRESS=`grep TCPServeraddress $DSMSYS | cut -d " " -f 2`
echo "TSM server address: $TCPSERVER_ADDRESS"
echo "TSM node name: $NODE_NAME"
echo 
#echo -n "Install TSM clinet? (y/n): "
#read -e AGREE_INST
#if [ $AGREE_INST != "y" ]
# then
#   echo "Install refused."
#   exit 1
#fi

echo "Install begin:"
case $OS_DEP_INSTALL in
"CentOS_6.5")
# echo "install section CentOS_6.5"
 InstCentOS6
 ConfTSMC
 StartTSMC
 ;;
"CentOS_6.4")
# echo "install section CentOS_6.4"
 InstCentOS6
 ConfTSMC
 StartTSMC
 ;;
"CentOS_6.3")
# echo "install section CentOS_6.3"
 InstCentOS6
 ConfTSMC
 StartTSMC
 ;;
"UbuntuOS_12.4.2")
#echo "install section Ubnt12"
 InstUbnt12
 ConfTSMC
 StartTSMC
 ;;

esac

# END OF INSTALL SCRIPT 

