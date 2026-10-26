# pwsh/.internal/tests/Enter-CatzcBurst.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `[System.IO.File]::WriteAllText($script:importer,`, written with `#`.

```text
The run shows a command's output through Write-Message, so the stand-in importer defines it as the real import
does.
```

## comment:2

Above `Start-Sleep -Milliseconds 1500`, written with `#`.

```text
Past the run's own 1 s wait it still waits, since the burst holds the lock, and runs only after the burst
ends.
```

## comment:3

Above `[System.IO.File]::WriteAllText($script:importer,` (occurrence 2), written with `#`.

```text
The run shows a command's output through Write-Message, so the stand-in importer defines it as the real import
does.
```
