# pwsh/Base.QualityGates/types/PesterRunner.cs

Runs N Pester worker processes (`pwsh -NoProfile -File <script>`) concurrently with pooled live output. Each worker's stdout and stderr are
captured on background reader threads (the `CliRunner` pattern). The first unfinished worker in submission order is live and streams to the
console in real time, while later workers buffer and replay in order as they are promoted, so the console reads sequentially while the wall
clock runs in parallel. The instance is its own result: `Run` populates `Results`, one per script.

## Run

`Run` starts every script as a worker, at most `maxParallel` at a time, in submission order. It blocks until every worker has exited, and on
timeout it kills the whole pool and throws. The environment dictionary, which may be null, is added to each worker's process environment,
and the caller's own environment is never touched. `silent=true` captures without echoing anything to the console.

A second overload is one pool with named limits. A worker starts, in submission order, once a slot is free and each of its caps
(`workerCaps[i]`, names into `capLimits`) runs fewer workers than its limit. A worker held only by a cap never holds back the ones after it.

## Timing

Each result carries wall-clock timing relative to the `Run` call: when the worker process started (offset from the pool's start) and how
long it ran. The reap loop observes completion, so the duration carries up to one poll interval (about 50 ms) of slop.

## Reaping and live output

A worker completes when its process has exited and both readers have drained to end of file. End of file follows exit promptly once the
child's pipe handles close, so the joins are brief.

To advance the live token, the loop flushes every completed worker's remaining backlog in submission order, then makes the first unfinished
worker write through so its output streams live. That worker is always already started, because starts go in order.

## Worker environment

A worker is never interactive. It gets an empty, closed stdin rather than the caller's: a child that inherits a stdin pipe another thread is
blocked reading hangs at startup (Git for Windows probes its std handles), and a test's own `& git` would inherit the worker's stdin.

Each worker also gets who started it, so it can end itself if this process dies without reaping it (`WorkerParentWatch`). That variable is
set after the caller's extras, so a caller can never point a worker elsewhere.

## comment:1

Above `public static PesterRunner Run(string[] runnerScripts, string[] labels, int...`, written with `//`.

```text
Blocks until every worker exits; a failure kills the whole pool. A PowerShell caller waits through Wait-PesterRunner instead,
since one blocking .NET call holds a Ctrl-C until it returns.
```
