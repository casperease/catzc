# automation/.scriptanalyzer/AnnounceStateChange.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Every lasting change a function makes to the state of the console session is announced on the information
stream, through the writer chokepoint
([ADR-AUTO-CONSOLE#11](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console11), in pwsh
[ADR-PWSH-ANNOUNCE#8](/docs/adr/pwsh/announce-state-changes.md#rule-adr-pwsh-announce8)). This
rule flags a state change in a function (or
in a script's top-level code) that never calls a writer. The changes it recognises:

  - environment variables: $env:<Name> = ..., [Environment]::SetEnvironmentVariable(...), and
    Set-Item / New-Item / Remove-Item / Clear-Item on an env: path (PATH and PSModulePath included);
  - loaded binaries: Add-Type (except -OutputAssembly, which writes a DLL without loading it),
    [Reflection.Assembly]::Load / LoadFrom / LoadFile / UnsafeLoadFrom, and LoadFromAssemblyPath /
    LoadFromStream on an AssemblyLoadContext;
  - loaded modules: Import-Module and Remove-Module;
  - global variables and preferences: $global:<Name> = ..., and Set-Variable / New-Variable /
    Remove-Variable with -Scope Global;
  - the working location: Push-Location and Pop-Location;
  - the line editor and type system: Set-PSReadLineOption, Set-PSReadLineKeyHandler,
    Remove-PSReadLineKeyHandler, Update-TypeData and Update-FormatData.

The writers that count as an announcement are Write-Message, Write-InformationColored (the chokepoint) and
Write-ImporterMessage (the bootstrap's chokepoint, used before Write-Message is loaded) — on the information
stream, so a Write-Message with -Verbose bound does not count. The one exception is Write-ImporterMessage
-StateChange, which counts: it is the importer's own load record, announced on the verbose stream
([ADR-PWSH-ANNOUNCE#6](/docs/adr/pwsh/announce-state-changes.md#rule-adr-pwsh-announce6)). A writer
announces a change only when it runs
whenever the change runs: it must sit in the change's own statement block or an enclosing one, so a writer
inside an unrelated branch (if ($diagnose) { Write-Message ... }) does not cover a change outside it. The
rule checks that the change is announced; what the line says is a review concern (it must name what changed).

These are not changes of this session and pass
([ADR-AUTO-CONSOLE#12](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console12), in pwsh
[ADR-PWSH-ANNOUNCE#9](/docs/adr/pwsh/announce-state-changes.md#rule-adr-pwsh-announce9)):

  - a change the function undoes before it returns: when a finally block in the same function changes the
    same target (the same env var or global, any Remove-Module for an Import-Module, Pop-Location for
    Push-Location), every change of that target in the function is temporary;
  - a change inside a scriptblock handed literally to Start-Job, Start-ThreadJob or ForEach-Object -Parallel,
    which runs in another runspace or process;
  - $global:LASTEXITCODE, the automatic variable PowerShell itself sets after every native call — mirroring it
    is not a change the automation makes;
  - a $global:__<Name> variable, the toolset's private bookkeeping across module scopes (a load registry, a
    timing collector, the test-run flag) — the state it records is announced where that state changes.

Test files (*.Tests.ps1) are skipped: tests change state on purpose, restore it in AfterEach/AfterAll, and
their output belongs to Pester. A change announced somewhere the rule cannot see (a caller, a delegate) is
suppressed for its function with SuppressMessageAttribute('Measure-AnnounceStateChange', '', Justification =
...), the justification naming where the announcement happens.

See ADR: [ADR-AUTO-CONSOLE](/docs/adr/automation/console-output-matters.md)
([ADR-AUTO-CONSOLE#11](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console11),
[ADR-AUTO-CONSOLE#12](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console12)) and its pwsh
mechanism [ADR-PWSH-ANNOUNCE](/docs/adr/pwsh/announce-state-changes.md)
([ADR-PWSH-ANNOUNCE#8](/docs/adr/pwsh/announce-state-changes.md#rule-adr-pwsh-announce8),
[ADR-PWSH-ANNOUNCE#9](/docs/adr/pwsh/announce-state-changes.md#rule-adr-pwsh-announce9)).
```

## comment:2

Above `function Get-CommandArgument {`.

```text
The argument of a command's named parameter (-Name value or -Name:value), else its first positional
argument — the element straight after the command name, when that is not a parameter.
```

## comment:3

Above `$isInOtherRunspace = {`.

```text
Whether a node sits in a scriptblock handed literally to a job or a parallel ForEach-Object, which runs in
another runspace or process.
```

## comment:4

Above `$isCandidate = {`.

```text
Predicates as locals, not inlined in FindAll's parens — dodges a cross-version indent skew
([ADR-PWSH-FORMAT#6](/docs/adr/pwsh/powershell-formatting.md#rule-adr-pwsh-format6)).
```

## comment:5

Above `$changesByScope = [ordered]@{}`.

```text
Group every change by its scope, and note per scope which targets a finally block restores and which
blocks an information-stream writer call covers.
```

## comment:6

Section `.DESCRIPTION` of the comment-based help.

```text
State outside the repository — the persistent (User/Machine) environment and the registry — is shared by every
process and every concurrent test run on the machine, so the code that changes it reaches it through one thin,
mockable seam: Set-PermanentEnvironmentVariable for a persistent variable, Set-EnvironmentPath for the
persistent PATH. A logic test mocks the seam, and only the seam's own vertical system test (L3) touches the real
state ([ADR-AUTO-TEST#33](/docs/adr/automation/test-automation.md#rule-adr-auto-test33)). A direct write elsewhere
cannot be mocked, so its test either changes the machine or
leaves the path untested. This rule reports, outside those two seam functions:

  - [Environment]::SetEnvironmentVariable(..., ..., <scope>) whose scope is not the literal Process scope —
    a 'User'/'Machine' literal, [EnvironmentVariableTarget]::User/Machine, or a variable (unknowable here);
  - Set-Item / New-Item / Remove-Item / Clear-Item / Set-ItemProperty / New-ItemProperty /
    Remove-ItemProperty / Clear-ItemProperty on a literal HKCU:, HKLM: or Registry:: path.

A registry path held in a variable is not seen; the seam rule is a guard, not a proof. Test files
(*.Tests.ps1) are skipped: the seams' own L3 tests write the real state on purpose. A deliberate exception is
suppressed for its function with SuppressMessageAttribute('Measure-PersistentWriteThroughSeam', '',
Justification = ...).

See ADR: [ADR-AUTO-TEST#33](/docs/adr/automation/test-automation.md#rule-adr-auto-test33).
```
