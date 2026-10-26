# pwsh/Base.Timeouts/tests/types/PipelineWatchdog.Tests.ps1

The tests of `PipelineWatchdog`, the timer that stops a pipeline that outlives its limit.

## The race

The limit is set to land around the moment each short pipeline returns, so across the runs the timer fires before, during and after the caller
disposes the watchdog and then the pipeline. A stop that reached a disposed pipeline would throw on a thread-pool thread and end the test
process, not just fail the test.
