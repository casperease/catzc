# pwsh/Base.Timeouts/tests/Watch-Blocking.Tests.ps1

The tests of `Watch-Blocking`: they run it with its sleeping replaced and read the lines it writes.

## The contract

The tests pin ten evenly spaced ticks slept until each is due, a line per tick, one closing warning, the registry's defaults, and a throw
only for a bad argument.

## The sleep mock

`Get-WaitLine` runs `Watch-Blocking` with its sleeping replaced and returns the written lines in order; `-SleepMs 0` makes every tick
instant. The mock sleeps nothing, so each sleep request is what is left until the tick is due: the first one slice, the last nearly all.
