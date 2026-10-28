# pwsh/Base.QualityGates/tests/types/PesterRunner.Tests.ps1

The test of the `PesterRunner` type. Its `execution` context runs real pwsh worker pools of its own, so it is greedy: they stack on the
parallel pool, which oversubscribes the box (see the greedy tag in the test-automation record).

## Execution cases

Each worker's wall-clock timing is checked: it started at or after the pool's start and ran for a measured duration. Reap-loop granularity
means the values are small and never negative. The start time is checked through the watch's own tolerant comparison, not textually, because
on Linux it can differ by milliseconds between reads.

The concurrency case has each worker drop its own marker and then wait for the other's marker. Only a genuinely concurrent pool lets both
exit 0, because a serial pool would spin out and exit 9. The case has no timing assertions, so the proof cannot flake on a slow machine.

The ordering case has worker 0 live but slow, while worker 1 finishes first and must buffer. The pooled console output still reads in
submission order. The test redirects `Console.Out` to observe it, since `SetOut` redirection survives the runner's `OutputEncoding` save and
restore. A file handshake, not a sleep, makes worker 0 wait until worker 1 has written its output, and exits 9 on a stall.
