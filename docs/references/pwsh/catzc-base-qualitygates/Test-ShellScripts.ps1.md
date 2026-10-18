# pwsh/Catzc.Base.QualityGates/Test-ShellScripts.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Quality gate: checks every shell script the repository holds — LF line endings, the executable bit, and ShellCheck or zsh's syntax check on
the repository's own.

### description

The POSIX engines read a carriage return as part of the command, so a shell script with CRLF line endings does not run
([ADR-AUTO-ENGINE-DIFFERENCESDECLAREDONCE](../../../adr/automation/execution-engines.md#rule-adr-auto-engine-differencesdeclaredonce): the
POSIX engines require LF;
[ADR-AUTO-BASH-SHELLSCRIPTSCHECKED](../../../adr/automation/bash/bash-test-artifacts.md#rule-adr-auto-bash-shellscriptschecked): every shell
script takes these checks). The scope is every tracked `*.sh`, `*.bats` and `*.zsh` file plus the root importer.sh (a committed root-config
copy that is regenerated on import). The vendored bats-core runner (`<Bash root>/.vendor/bats-core/`, BashConfig.BatsFolder) is mostly Bash
scripts without an extension; every tracked file in it takes the LF check only, since it is third-party code the repository runs but does
not own (upstream ships its sourced `lib/*.bash` with a shebang and mode 100644). Four checks:

```text
LF          every file in scope: a carriage return anywhere is one issue (.gitattributes pins the shell scripts to
            eol=lf, so a re-checkout fixes a stale working copy; a CRLF file in the index needs re-adding);
executable  every tracked file in scope that starts with a shebang must be stored executable (git mode 100755,
            Get-GitTrackedPath -ExecutableOnly), since it is meant to run directly; a sourced file has no shebang;
ShellCheck  every *.sh, *.bats and importer.sh except -ShellCheckExclude (vendored third-party scripts): each finding
            is one issue, '<file>:<line>:<column>: <severity>: <message> [SC<code>]', from the pinned ShellCheck
            (tools.yml `shellcheck`, Install-Shellcheck), run by its path;
zsh -n      every *.zsh, in place of ShellCheck, which does not read zsh: zsh parses the file without running it
            (-n, NO_EXEC; -f, no startup files), and each line it reports is one issue, from the pinned zsh
            (tools.yml `zsh`, Install-Zsh), run by its path.
```

Ends with Write-QualityGateReport: the report lands in out/test-shell-scripts/, and the gate throws once listing every issue (or returns the
result with -PassThru). Throws with "Run Install-Shellcheck" when ShellCheck at the pin is missing and there is a script for it, and with
"Run Install-Zsh" when zsh at the pin is missing and there is a `*.zsh` file. Needs the source tree (Assert-SourceTree).

### parameter `ShellCheckExclude`

Repository-relative wildcard paths ShellCheck skips: vendored third-party scripts, which are LF-checked but not analysed. Default: the
vendored dotnet-install.sh. A `*.zsh` file never goes to ShellCheck.

### parameter `OutputFolder`

The report base folder. Defaults to Write-QualityGateReport's (out/test-shell-scripts).

### parameter `PassThru`

Return the gate result { Subject; IssueCount; Issues; ReportPath; Scripts } instead of throwing on issues.

### outputs

`[Catzc.Base.Reports.QualityGateResult]` With -PassThru only.

### example 1

```powershell
Test-ShellScripts
```

### example 2

```powershell
(Test-ShellScripts -PassThru).Issues
```

## comment:1

Above `$shebang = $bytes.Length -ge 2 -and $bytes[0] -eq 35 -and $bytes[1] -eq 33`, written with `#`.

```text
A script with a shebang is meant to run directly, which on Unix needs the executable bit in git; a sourced file
(importer.sh, a shellcheck directive instead of a shebang) does not.
```

## comment:2

Above ``$check = Invoke-Executable "`"$($shellcheck.Path)`" --format=gcc...``, written with `#`.

```text
--format=gcc prints one '<file>:<line>:<column>: <severity>: <message> [SC<code>]' line per finding; exit 1
means findings, anything above it means ShellCheck itself failed.
```

## comment:3

Above `if ($zshScripts.Count -gt 0) {`, written with `#`.

```text
ShellCheck does not read zsh, so a *.zsh file takes zsh's own syntax check: -n parses without running (NO_EXEC), -f
skips the startup files. zsh checks one script per call; exit 1 means a parse error, anything above it means zsh
could not check the file.
```
