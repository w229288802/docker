#!/bin/bash
export TIME=`date --date="-1 day" +"%Y-%m-%d %H:%M:%S"`
export TIMESTAMP=`date -d "${TIME}" +%s`000
export DATE=`date -d "${TIME}" +%"%Y-%m-%d"`
java -jar gmall2020-mock-log-2021-01-22.jar -Dhostname=`hostname`