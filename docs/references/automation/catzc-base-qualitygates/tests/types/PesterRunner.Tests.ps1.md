---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/types/PesterRunner.Tests.ps1.md
    kind: test-asset
    body_sha: "16e43d720ae8"
---

# automation/Catzc.Base.QualityGates/tests/types/PesterRunner.Tests.ps1

<!-- cspell:ignore nexit -->

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Context 'execution (real pwsh workers)' -Tag 'L2', 'greedy' {`.

```text
greedy: runs real pwsh worker pools of its own — stacked on the parallel pool that
oversubscribes the box (see the test-automation ADR's greedy tag).
```

## comment:2

Above `foreach ($result in $runner.Results) {`.

```text
Wall-clock timing per worker: started at/after the pool's start, ran for a measured duration
(reap-loop granularity means small, never negative, values).
```

## comment:3

Above `$firstMarker = Join-Path $TestDrive 'first.marker'`.

```text
Each worker drops its own marker, then waits for the OTHER's marker: only a genuinely
concurrent pool lets both exit 0 — a serial pool would spin out and exit 9. No timing
assertions, so the proof cannot flake on a slow machine.
```

## comment:4

Above `$fastDone = Join-Path $TestDrive 'fast-done.marker'`.

```text
Worker 0 is live but slow; worker 1 finishes first and must buffer. The pooled console
output still reads in submission order. Console.Out is redirected to observe it —
SetOut redirection survives the runner's OutputEncoding save/restore. A file handshake,
not a sleep, makes worker 0 wait until worker 1 has written its output (exit 9 on a stall).
```

## comment:5

Above `$runner.Results[0].Stdout -match "pid=$PID start=(\d+)" | Should -BeTrue...`.

```text
The start time is checked through the watch's own tolerant comparison, not textually — on Linux it
can differ by milliseconds between reads.
```
