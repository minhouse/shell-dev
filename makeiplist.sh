#!/bin/bash


i=20
while [ $i -le 150 ]
do
        echo "192.168.0.${i}"
        i=`expr $i + 1`
done
