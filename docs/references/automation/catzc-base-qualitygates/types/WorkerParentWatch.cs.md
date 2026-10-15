---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/types/WorkerParentWatch.cs.md
    kind: reference
    body_sha: e7555955a7f5
    adrs: []
---

# automation/Catzc.Base.QualityGates/types/WorkerParentWatch.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `namespace Catzc.Base.QualityGates;`.

```text
Ends a test worker process when the process that started it is gone. PesterRunner hands every worker its own
PID and start time (CATZC_TEST_PARENT_PID / CATZC_TEST_PARENT_START); the generated shard script calls Start,
and a background thread polls the parent. When the parent has exited — or its PID now belongs to a different
process (PID reuse, told apart by start time) — the worker kills itself, so a run whose parent died (a closed
terminal, a killed console) never leaves workers behind holding files and running unobserved.
```

## comment:2

Above `private static readonly TimeSpan StartTolerance = TimeSpan.FromSeconds(1);`.

```text
Start times are compared with slack: on Linux, Process.StartTime is derived from the boot time and can
differ by a few milliseconds between reads of the same process. A reused PID starts far later than that.
```

## comment:3

Above `public static bool IsAlive(int pid, long startTicksUtc)`.

```text
<summary>
True when the process with this PID exists and started at this time (UTC ticks, within tolerance).
</summary>
```

## comment:4

Above `public static bool Start(int intervalMilliseconds)`.

```text
<summary>
Starts watching the parent named by the environment variables. Returns false — and watches nothing — when
they are absent (the script was not started by PesterRunner) or malformed. Idempotent: a second call while
a watch runs returns true without starting another.
</summary>
```

## comment:5

Above `using var self = Process.GetCurrentProcess();`.

```text
Kill, not Environment.Exit: exit handlers can block behind a main thread stuck writing to a pipe nobody
reads any more, which is exactly the state an orphaned worker is in.
```
