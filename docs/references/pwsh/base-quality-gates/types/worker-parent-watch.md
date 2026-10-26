# pwsh/Base.QualityGates/types/WorkerParentWatch.cs

Ends a test worker process when the process that started it is gone. `PesterRunner` hands every worker its parent's PID and start time
(`CATZC_TEST_PARENT_PID`, `CATZC_TEST_PARENT_START`). The generated shard script calls `Start`, and a background thread polls the parent.
When the parent has exited, or its PID now belongs to a different process (PID reuse, told apart by start time), the worker kills itself. So
a run whose parent died, such as a closed terminal or a killed console, never leaves workers behind holding files and running unobserved.

## Start

`Start` begins watching the parent named by the environment variables. It returns false, and watches nothing, when they are absent (the
script was not started by `PesterRunner`) or malformed. It is idempotent: a second call while a watch runs returns true without starting
another.

## Liveness

`IsAlive` is true when the process with the given PID exists and started at the given time (UTC ticks, within tolerance). Start times are
compared with a one-second slack: on Linux, `Process.StartTime` is derived from the boot time and can differ by a few milliseconds between
reads of the same process, while a reused PID starts far later than that.

## Kill

The worker ends itself with `Kill`, not `Environment.Exit`: exit handlers can block behind a main thread stuck writing to a pipe nobody
reads any more, which is exactly the state an orphaned worker is in.
