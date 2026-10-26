# pwsh/.internal/tests/Invoke-StagedBurst.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:lockName = "Local\catzc-test-$([guid]::NewGuid())"`, written with `#`.

```text
Each test has a repository root, a stand-in importer and a run lock of its own, so a real run on the machine
never touches them.
```

## comment:2

Above `$lines | Should -Contain '[Invoke-CatzcCommand] passed: Test-Swapped'`, written with `#`.

```text
The real Invoke-CatzcCommand.ps1 runs the one fixture command: its switches bind by name and are never taken
for commands.
```

## comment:3

Above `Remove-Item -LiteralPath (Join-Path $script:staged 'widgets/gadget.txt'),...` (occurrence 2), written with `#`.

```text
Only the marker is staged, so these tests delete without swapping, unless one stages the gadget back
itself.
```
