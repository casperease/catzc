# pwsh/Catzc.Base.Timeouts/tests/Watch-Blocking.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Watch-Blocking'`, written with `#`.

```text
The contract these tests pin: ten evenly spaced ticks slept until each is due, a line per tick, one closing warning, the registry's
defaults, and a throw only for a bad argument.
```

## comment:2

Above `function Get-WaitLine {`, written with `#`.

```text
Runs Watch-Blocking with its sleeping replaced, and returns the written lines in order. -SleepMs 0 makes every
tick instant.
```

## comment:3

Above `Should -Invoke Start-Sleep -ModuleName Catzc.Base.Timeouts -Times 10 -Exactly...`, written with `#`.

```text
The mock sleeps nothing, so each request is what is left until the tick is due: the first one slice, the
last nearly all.
```
