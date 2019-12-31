#!/bin/bash

set +e
set +x

root=`pwd`
tools=$root/libs
evalpath=$root/evaluation
projectpath=$root/toradocu
projectlibs=$projectpath/libs
classpath=$root/extractcoverage/build/libs/extractcoverage-all.jar
corpuspath=$projectpath
coveragepath=$evalpath/coverage
logpath=$evalpath/logs
agentpath=$tools/jacocoagent.jar
outputpath=$coveragepath/
junitpath=$projectlibs/junit-4.12.jar
replacecallpath=$projectlibs/replacecall.jar

COMMAND="java -jar $classpath --corpusDirectoryPath $corpuspath --jacocoAgentPath $agentpath --outputPath $outputpath --junitPath $junitpath --replacecallAgentPath $replacecallpath"
echo $COMMAND
$COMMAND 2>&1 | tee $logpath/coverage-log.txt
