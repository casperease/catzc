# automation/Catzc.Base.QualityGates/types/PesterRunner.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `namespace Catzc.Base.QualityGates;`, written with `//`.

```text
Runs N Pester worker processes (pwsh -NoProfile -File <script>) concurrently with pooled live output.
Each worker's stdout/stderr is captured on background reader threads (the CliRunner pattern); the first
unfinished worker in submission order is "live" and streams to the console in real time, while later
workers buffer and replay in order as they are promoted — so the console reads sequentially while the
wall clock runs in parallel. The instance is its own result: Run populates Results, one per script.
```

## comment:2

Above `public long StartOffsetMs { get; internal set; }`, written with `//`.

```text
Wall-clock timing relative to this Run call: when the worker process started (offset from the
pool's start) and how long it ran. Completion is observed by the reap loop, so DurationMs
carries up to one poll interval (~50ms) of slop.
```

## comment:3

Above `public static PesterRunner Run(string[] runnerScripts, string[] labels, int...`, written with `///`.

```text
<summary>
Runs every script as `pwsh -NoProfile -File &lt;script&gt;`, at most maxParallel at a time, started
in submission order. Blocks until every worker has exited; kills the whole pool and throws on
timeout. The environment dictionary (may be null) is added to each worker's process environment —
the caller's own environment is never touched. Pass silent=true to capture without echoing
anything to the console.
</summary>
```

## comment:4

Above `int running = 0;`, written with `//`.

```text
Reap: a worker completes when its process has exited and both readers drained to EOF
(EOF follows exit promptly once the child's pipe handles close, so the joins are brief).
```

## comment:5

Above `if (!silent)`, written with `//`.

```text
Advance the live token: flush every completed worker's remaining backlog in submission
order, then make the first unfinished worker write-through so its output streams live.
(The first unfinished worker is always already started, because starts go in order.)
```

## comment:6

Above `RedirectStandardInput = true`, written with `//`.

```text
A worker is never interactive. It gets an empty, closed stdin rather than the caller's: a child
that inherits a stdin pipe another thread is blocked reading hangs at startup (Git for Windows
probes its std handles), and a test's own `& git` would inherit the worker's stdin.
```

## comment:7

Above `psi.Environment[WorkerParentWatch.PidVariable] =...`, written with `//`.

```text
Who started this worker, so it can end itself if this process dies without reaping it
(WorkerParentWatch). Set after the caller's extras, so a caller can never point a worker elsewhere.
```
