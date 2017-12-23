
# Command line test suite



 This test check that illegal command lines cause archicheck to
 exit with a non null return code.
 - Note that normal use is overly tested in other tests,
   so here mainly error situations are tested.
 - Note also that quiet and verbose mode (-q / -v) are also tested
   in other tests.


##  Command line test suite / Help options


  Test that the -h, --help or no command line will output :

```

ArchiCheck normal use :
   archicheck rules_file -I directory [-I directory]*

General form :
   archicheck [Options] [rules_file] [-I directory]*

Options :
   -lf | --list_files        : list sources files analyzed
   -ld | --list_dependencies : list identified units and dependencies in analyzed sources files
   -lr | --list_rules        : list rules in a rules file
   -r  | --recursive         : all following -I are recursive
   -v  | --verbose
   -q  | --quiet             : no message unless error. Warning are also ignored.
         --version           : archicheck version
   -h  | --help              : this message

Examples:
   archicheck rules.txt -I ./src
   archicheck -lf -I ./src
   archicheck -lr rules.txt

```


 Command line test suite / Help options [Successful]("tests-status#successful")

##  Command line test suite / Version option


  Test that the --version will put :

```
0.4.2
```


 Command line test suite / Version option [Successful]("tests-status#successful")

##  Command line test suite / -I option without src dir


  When running:
  > archicheck -I

  Expecting:

```
Error : Sources directory expected after -I
```


 Command line test suite / -I option without src dir [Successful]("tests-status#successful")

##  Command line test suite / -I option with an unknow dir


  When running:
  > archicheck -I qsdqjh

  Expecting:

```
Error : No qsdqjh directory
```


 Command line test suite / -I option with an unknow dir [Successful]("tests-status#successful")

##  Command line test suite / unknown -xyz option


  When running:
  > archicheck -xzy

  Expecting:

```
Error : Unknown rules file or unknow option -xzy

ArchiCheck normal use :
   archicheck rules_file -I directory [-I directory]*

General form :
   archicheck [Options] [rules_file] [-I directory]*

Options :
   -lf | --list_files        : list sources files analyzed
   -ld | --list_dependencies : list identified units and dependencies in analyzed sources files
   -lr | --list_rules        : list rules in a rules file
   -r  | --recursive         : all following -I are recursive
   -v  | --verbose
   -q  | --quiet             : no message unless error. Warning are also ignored.
         --version           : archicheck version
   -h  | --help              : this message

Examples:
   archicheck rules.txt -I ./src
   archicheck -lf -I ./src
   archicheck -lr rules.txt

```


 Command line test suite / unknown -xyz option [Successful]("tests-status#successful")

##  Command line test suite / -I option with... nothing to do

  (no rules file, no -ld or -lf, etc.)

  When running:
  > mkdir -p dir6
  > touch dir6/src.adb
  > archicheck -I dir6

  Expecting:

```
Error : Nothing to do with those sources

ArchiCheck normal use :
   archicheck rules_file -I directory [-I directory]*

General form :
   archicheck [Options] [rules_file] [-I directory]*

Options :
   -lf | --list_files        : list sources files analyzed
   -ld | --list_dependencies : list identified units and dependencies in analyzed sources files
   -lr | --list_rules        : list rules in a rules file
   -r  | --recursive         : all following -I are recursive
   -v  | --verbose
   -q  | --quiet             : no message unless error. Warning are also ignored.
         --version           : archicheck version
   -h  | --help              : this message

Examples:
   archicheck rules.txt -I ./src
   archicheck -lf -I ./src
   archicheck -lr rules.txt

```


 Command line test suite / -I option with... nothing to do [Successful]("tests-status#successful")

##  Command line test suite / -lr option without rules file


  When running:
  > archicheck -lr

  Expecting:

```
Error : No rules file given

ArchiCheck normal use :
   archicheck rules_file -I directory [-I directory]*

General form :
   archicheck [Options] [rules_file] [-I directory]*

Options :
   -lf | --list_files        : list sources files analyzed
   -ld | --list_dependencies : list identified units and dependencies in analyzed sources files
   -lr | --list_rules        : list rules in a rules file
   -r  | --recursive         : all following -I are recursive
   -v  | --verbose
   -q  | --quiet             : no message unless error. Warning are also ignored.
         --version           : archicheck version
   -h  | --help              : this message

Examples:
   archicheck rules.txt -I ./src
   archicheck -lf -I ./src
   archicheck -lr rules.txt

```


 Command line test suite / -lr option without rules file [Successful]("tests-status#successful")

##  Command line test suite / Legal line, but no src file in the given (existing) directory


  When running:
  > mkdir dir9
  > archicheck -lf -I dir9

  Expecting:

```
Warning : Cannot list files, no sources found to analyze
```


 Command line test suite / Legal line, but no src file in the given (existing) directory [Successful]("tests-status#successful")

##  Command line test suite / file given to -I, instead of a directory


  When running:
  > touch rules.txt src.adb
  > archicheck rules.txt -I src.adb

  Expecting:

```
Error : src.adb is not a directory
```


 Command line test suite / file given to -I, instead of a directory [Successful]("tests-status#successful")

##  Command line test suite / -ld given, but no source found


  When running:
  > mkdir -p dir11
  > echo Interfaces use is forbidden > rules.txt
  > archicheck rules.txt -ld -I dir11

  Expecting:

```
Warning : Cannot list dependencies, no sources found
```


 Command line test suite / -ld given, but no source found [Successful]("tests-status#successful")

##  Command line test suite / src found, but nothing to do whith it


  When running:
  > mkdir -p dir12
  > touch dir12/src.adb
  > archicheck -I dir12

  Expecting:

```
Error : Nothing to do with those sources

ArchiCheck normal use :
   archicheck rules_file -I directory [-I directory]*

General form :
   archicheck [Options] [rules_file] [-I directory]*

Options :
   -lf | --list_files        : list sources files analyzed
   -ld | --list_dependencies : list identified units and dependencies in analyzed sources files
   -lr | --list_rules        : list rules in a rules file
   -r  | --recursive         : all following -I are recursive
   -v  | --verbose
   -q  | --quiet             : no message unless error. Warning are also ignored.
         --version           : archicheck version
   -h  | --help              : this message

Examples:
   archicheck rules.txt -I ./src
   archicheck -lf -I ./src
   archicheck -lr rules.txt

```


 Command line test suite / src found, but nothing to do whith it [Successful]("tests-status#successful")

##  Command line test suite / rules file found, but nothing to do whith it


  When running:
  > archicheck rules.txt

  Expecting:

```
Error : Nothing to do with this rules file

ArchiCheck normal use :
   archicheck rules_file -I directory [-I directory]*

General form :
   archicheck [Options] [rules_file] [-I directory]*

Options :
   -lf | --list_files        : list sources files analyzed
   -ld | --list_dependencies : list identified units and dependencies in analyzed sources files
   -lr | --list_rules        : list rules in a rules file
   -r  | --recursive         : all following -I are recursive
   -v  | --verbose
   -q  | --quiet             : no message unless error. Warning are also ignored.
         --version           : archicheck version
   -h  | --help              : this message

Examples:
   archicheck rules.txt -I ./src
   archicheck -lf -I ./src
   archicheck -lr rules.txt

```


 Command line test suite / rules file found, but nothing to do whith it [Successful]("tests-status#successful")