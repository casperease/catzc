# pwsh/Base.Environment/tests/Set-PermanentEnvironmentVariable.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Set-PermanentEnvironmentVariable / Get-PermanentEnvironmentVariable...`, written with `#`.

```text
Vertical system test (L3): the persistent-environment seam against the REAL user environment — state outside the
repository that every process and every concurrent run on the machine shares, so it runs only in the
working folder itself, never in a snapshot location. It is the one test that proves the registry round trip; every caller's logic is covered at
L1 by mocking Get-/Set-PermanentEnvironmentVariable. It owns a scratch variable no tool uses, named per run so two
overlapping runs on the machine never share it, and removes it whatever happens.
```

## comment:2

Above `Describe 'Set-PermanentEnvironmentVariable / Get-PermanentEnvironmentVariable...`, written with `#`.

```text
The one test of the real round trip: a per-run scratch variable no tool uses, so overlapping runs never share it and
it is always removed.
```

## comment:3

Above `$script:isInUserEnvironment = {`, written with `#`.

```text
Removed means gone from the registry key — an empty value would read back as '' and pass a null-or-empty
check.
```
