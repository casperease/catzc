# automation/Catzc.Base.Timeouts/Assert-Wait.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$remainingMs = $dueMs - [long]$watch.ElapsedMilliseconds`, written with `#`.

```text
Sleep until the tick is due, not for the whole slice: a sleep overruns by a few ms, and a fixed slice would carry that
overrun into every later tick, so the last tick would read late with nothing blocked.
```
