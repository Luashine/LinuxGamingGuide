#!/bin/bash

echo "mounting the cpuset filesystem"
if ! [ -d /dev/cpuset ]; then
  mkdir /dev/cpuset
  mount -t cpuset cpuset /dev/cpuset
fi

echo "Creating theUgly"
if ! [ -d /dev/cpuset/theUgly ]; then
  mkdir /dev/cpuset/theUgly
fi

echo "Setting 0-7 as the ugly cpu set"
/bin/echo 0-7 > /dev/cpuset/theUgly/cpuset.cpus

echo "Giving the Ugly memory node 0"
/bin/echo 0 > /dev/cpuset/theUgly/cpuset.mems

echo "Making the Ugly cpu exlusive"
/bin/echo 1 > /dev/cpuset/theUgly/cpuset.cpu_exclusive

echo "Redirecting Processes"
while read p; do
  echo "Redirecting PID $p"
  /bin/echo $p > /dev/cpuset/theUgly/tasks
done < /dev/cpuset/tasks


echo "Creating theGood"
if ! [ -d /dev/cpuset/theGood ]; then
  mkdir /dev/cpuset/theGood
fi

echo "Setting 8-15 as the Good cpu set"
/bin/echo 8-15 > /dev/cpuset/theGood/cpuset.cpus

echo "Giving the Good memory node 0"
/bin/echo 0 > /dev/cpuset/theGood/cpuset.mems

echo "Making the Good cpu exlusive"
/bin/echo 1 > /dev/cpuset/theUgly/cpuset.cpu_exclusive

read -p "Redirect Lutris to theGood ? y/n: "
if [ "$REPLY" = "y" ];then
  echo "Redirecting Lutris to theGood"
  /bin/echo `pgrep lutris` > /dev/cpuset/theGood/tasks
fi

