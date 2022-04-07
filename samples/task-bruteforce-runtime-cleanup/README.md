# Task Runtime Data Cleanup

This is a script to cleanup task runtime data brute-force style. It works by simply deleting the first specified run Id, and continuing backwards until it reaches the last specified run Id.

## Description

This script is "brute force" because it does not examine task runs to ensure there are no unfinished tasks, it will simply delete the run and all associated relationships with the run, and continue to the next previous run until finished.

## Configuration File

A sample configuration file is provided that must be renamed or copied to `config.yaml` and updated with the environment information for the task server that will be cleaned up.

- *taskUrl* - the base Kinetic Task application URL. Example: <https://example.com:8080/kinetic-task>
- *username* - the username of a Task user account (admin account, or another user that has permission to delete runs)
- *password* - the password that corresponds to the user account
- *logLevel* - the log level used for the SDK (info, debug)

## Usage

### Running with Ruby

1. Install Ruby >= 2.3
2. ruby task-bruteforce-runtime-cleanup.rb START_TASK_ID [STOP_TASK_ID]

### Running with Java

1. Install Java 8 (either JRE or SDK)
2. Download [JRuby complete jar](https://repo1.maven.org/maven2/org/jruby/jruby-complete/9.2.13.0/jruby-complete-9.2.13.0.jar)
3. `java -jar jruby-complete-9.2.13.0.jar -S task-bruteforce-runtime-cleanup.rb START_TASK_ID [STOP_TASK_ID]`

### Arguments

The script takes two arguments, the START_TASK_ID which is required, and the STOP_TASK_ID which is optional.

- *START_TASK_ID* - ID of the first run to delete (integer)
- *STOP_TASK_ID* - ID of the last run to delete (integer), default 1
