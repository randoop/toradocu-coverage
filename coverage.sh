#!/bin/bash
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
echo java -jar $classpath --corpusDirectoryPath $corpuspath --jacocoAgentPath $agentpath --outputPath $outputpath --junitPath $junitpath --replacecallAgentPath $replacecallpath
java -jar $classpath --corpusDirectoryPath $corpuspath --jacocoAgentPath $agentpath --outputPath $outputpath --junitPath $junitpath --replacecallAgentPath $replacecallpath &> $logpath/coverage-log.txt
