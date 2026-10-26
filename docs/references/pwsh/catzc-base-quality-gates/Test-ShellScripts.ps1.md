# pwsh/Base.QualityGates/Test-ShellScripts.ps1

The quality gate for shell scripts: every shell script the repository holds must have LF line endings and the executable bit where it needs
one, and it must pass ShellCheck, or zsh's own syntax check for a zsh script.

## help

### synopsis

Checks every shell script the repository holds for LF line endings, the executable bit, and ShellCheck or zsh's syntax check on the
repository's own.

### description

The POSIX engines read a carriage return as part of the command, so a shell script with CRLF line endings does not run
([ADR-AUTO-ENGINE-DIFFERENCESDECLAREDONCE](../../../drs/automation/execution-engines.md#rule-adr-auto-engine-differencesdeclaredonce): the
POSIX engines require LF;
[ADR-AUTO-BASH-SHELLSCRIPTSCHECKED](../../../drs/automation/bash/bash-test-artifacts.md#rule-adr-auto-bash-shellscriptschecked): every shell
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

## Executable bit

A script with a shebang is meant to run directly, which on Unix needs the executable bit in git. A sourced file (`importer.sh`, which has a
shellcheck directive instead of a shebang) does not.

## ShellCheck

`--format=gcc` prints one `<file>:<line>:<column>: <severity>: <message> [SC<code>]` line per finding. Exit 1 means findings, and anything
above it means ShellCheck itself failed.

## zsh

ShellCheck does not read zsh, so a `*.zsh` file takes zsh's own syntax check. `-n` parses without running (`NO_EXEC`) and `-f` skips the
startup files. zsh checks one script per call. Exit 1 means a parse error, and anything above it means zsh could not check the file. zsh
names the file as it was given (`<file>:<line>: <message>`), and a line without it gets the file prefixed.
