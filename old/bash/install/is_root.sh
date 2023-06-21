#!/bin/bash

if [ "$UID" -ne 0 ]
then
echo "Please run this script with sudo"
exit 1
fi