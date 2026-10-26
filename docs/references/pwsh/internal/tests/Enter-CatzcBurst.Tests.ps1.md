# pwsh/.internal/tests/Enter-CatzcBurst.Tests.ps1

The tests of `Enter-CatzcBurst`, the burst that holds the run lock while its steps run, at L0 with a stand-in importer and at L2 in a child
pwsh process.

## The stand-in importer

The run shows a command's output through `Write-Message`, so the stand-in importer defines it as the real import does.

## Waiting on the lock

A run that starts during a burst waits past its own 1 s wait, since the burst holds the lock, and runs only after the burst ends.
