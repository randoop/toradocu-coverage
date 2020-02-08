# Toradocu-coverage computations

This document describes how to setup and run an evaluation of Randoop test
coverage over the Toradocu corpus.


## Prerequisites

Ensure that Maven is installed (that is, the `mvn` binary is available), or
you will get obscure errors.


## Setup

This is the directory structure used for testing:
```
toradocu-coverage
├── coverage.sh
├── evaluation
│   ├── coverage
│   └── logs
├── extractcoverage
├── fetch_and_compile_corpus
├── libs
├── README.md (this file)
├── run_randoop_on_corpus
├── show-coverage.pl
└── toradocu
    ├── commons-collections
    ├── commons-math
    ├── commons-rng
    ├── freecol
    ├── guava
    ├── jgrapht
    ├── libs
    ├── logs
    └── plume-lib
```
It is somewhat historical and could be cleaned up.

To create this directory structure and build the coverage tool:
```
git clone git@gitlab.cs.washington.edu:randoop/toradocu-coverage.git
cd toradocu-coverage
mkdir -p evaluation/coverage
mkdir -p evaluation/logs
mkdir -p toradocu/logs
cd extractcoverage
./gradlew assemble
cd ..
```


## Controlling which Randoop is used

By default the scripts will run the Randoop that is located in the
`toradocu/libs` subdirectory.
To use a different Randoop, replace `toradocu/libs/randoop.jar` with a
symbolic link to the version you want to use, probably in
`build/libs/randoop-all-X.X.X.jar` of your clone of Randoop.  Example:
```
cd toradocu/libs
mv -f randoop.jar randoop.jar-ORIG
ln -s $HOME/randoop/build/libs/randoop-all-4.0.4.jar randoop.jar
mv -f replacecall.jar replacecall.jar-ORIG
ln -s $HOME/randoop/build/libs/replacecall-4.0.4.jar replacecall.jar
cd ../..
```


## Setting up the Toradocu test suites.

When you clone the toradocu-coverage repository it will create a subdirectory
for each of the test suites, but it does not download the tests themselves.
This is done by running the fetch_and_compile_corpus script:
```
./fetch_and_compile_corpus
```
This will download and compile each of the test suites and generate a log in
`toradocu/logs/<suite name>-fetch-log.txt`.  The test source will be found in
`toradocu/<suite name>/inputs/<suite-name>`.  Some auxiliary files needed for
the coverage process will be generated in `toradocu/<suite name>/resources`.
This will take about 1-3 minutes per test suite.

Currently, there are six test suites:
```
commons-collections
commons-math (which uses commons-rng)
freecol
guava
jgrapht
plume-lib
```

If you are only interested in testing a single suite, you may want to skip this
time consuming step and just:
```
cd toradocu/<test suite of interest>
./gradlew prepareForRandoop
```
This will not create the fetch log file; you can redirect standard out to do so.
If you are looking at commons-math, you must also run the command above in
commons-rng.

Note: The test org.apache.commons.rng.sampling.distribution.ContinuousSamplerParametricTest
might fail; if this is the only failure, it can be ignored.


## Running randoop to generate the coverage test cases.

The next step is to run Randoop over the test suites to generate a set of test
cases; then pass them to the java compiler.  This is done by running the
run_randoop_on_corpus script:
```
./run_randoop_on_corpus
```
This will generate a log file in `toradocu/logs/<suite name>-randoop-log.txt`.
The generated test source will be found in `toradocu/<suite name>/src/test/java`.
The corresponding class files in `toradocu/<suite name>/build/classes/test`.
This will take about 10-15 minutes per test suite.

If you are only interested in testing a single suite, you may:
```
cd toradocu/<test suite of interest>
./gradlew prepareForCoverage
```
This will not create the randoop log file; you can redirect standard out to do so.
If you are looking at commons-math, you need not run any commands in commons-rng
first.


## Running the randoop generated tests and collecting the coverage data.

The next step is to execute the Randoop generated tests under the control of the
JaCoCo coverage tool to collect the coverage data.  This is done by running the
coverage script:
```
./coverage.sh
```
This writes a single log file to `evaluation/logs/coverage-log.txt`.
The script uses the `extractcoverage` program to pull all of the coverage
information into the `evaluation/coverage` directory.  The files written here
include the
aggregate `report-<date>.csv` and a subdirectory for each test suite of
the form:
```
evaluation/coverage/<suite name>/test/
├── jacoco.exec
├── log.txt
└── report.csv
```
which has the JaCoCo exec file, an execution log file and a csv file with the
detailed coverage per method.  If a failure occurs during the coverage script
run, at least one of these files may be missing.
This will take about 5-6 minutes.


## Displaying the coverage data

The raw coverage data will be found at evaluation/coverage/report-<date>.csv.
You may display the coverage results by running the perl script:
```
./show-coverage.pl
```
This script will accept an optional argument of an alternative file location.
Invoke the script with -help for a full list of options.


## Caveat

Nothing in this process currently counts the number of generated tests.
