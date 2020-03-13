# Toradocu-coverage computations

### Note: This branch is for experimentation purposes only.

This document describes how to setup and run an evaluation of Randoop test
coverage over the Toradocu corpus.

Currently, there are six test projects:
```
commons-collections
commons-math (which uses commons-rng)
freecol
guava
jgrapht
plume-lib
```


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
    ├── freecol
    ├── guava
    ├── jgrapht
    ├── plume-lib
    ├── commons-rng (used by commons-math)
    ├── libs (support files)
    └── logs (support files)
```
It is somewhat historical and could be cleaned up.

To create this directory structure and build the coverage tool:
```
git clone git@gitlab.cs.washington.edu:randoop/toradocu-coverage.git
cd toradocu-coverage
(cd extractcoverage && ./gradlew assemble)
```


## Controlling which Randoop is used

By default the scripts will run the Randoop that is located in the
`toradocu/libs` subdirectory.
To use a different version, run
```
(cd toradocu/libs && MY_RANDOOP/scripts/replace-randoop-jars.sh)
```


## Setting up the Toradocu test projects.

When you clone the toradocu-coverage repository it will create a subdirectory
for each of the test projects, but it does not download the test projects themselves.
This is done by running the fetch_and_compile_corpus script:
```
./fetch_and_compile_corpus
```
This will download and compile each of the test projects and generate a log in
`toradocu/logs/<projectname>-fetch-log.txt`.  The test source will be found in
`toradocu/<projectname>/inputs/<suite-name>`.  Some auxiliary files needed for
the coverage process will be generated in `toradocu/<projectname>/resources`.
This will take about 1-3 minutes per test project.


If you are only interested in testing a single suite, just run:
```
cd toradocu/<projectname>
./gradlew prepareForRandoop
```
This will not create the fetch log file; you can redirect standard out to do so.
If you are looking at commons-math, you must also run the command above in
commons-rng.


Note: The test org.apache.commons.rng.sampling.distribution.ContinuousSamplerParametricTest
might fail; if this is the only failure, it can be ignored.


## Running randoop to generate the coverage test cases.

The next step is to run Randoop over the test projects to generate a set of test
cases; then pass them to the java compiler.  This is done by running the
run_randoop_on_corpus script:
```
./run_randoop_on_corpus
```
This will generate a log file in `toradocu/logs/<projectname>-randoop-log.txt`.
The generated test source will be found in `toradocu/<projectname>/src/test/java`.
The corresponding class files in `toradocu/<projectname>/build/classes/test`.
This will take about 10-15 minutes per test project.

If you are only interested in testing a single suite, you may:
```
cd toradocu/<projectname>
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
aggregate `report-<date>.csv` and a subdirectory for each test project of
the form:
```
evaluation/coverage/<projectname>/test/
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
