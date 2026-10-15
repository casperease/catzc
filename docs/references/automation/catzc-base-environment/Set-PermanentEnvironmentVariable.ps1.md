---
catzc:
  derived:
    path: docs/references/automation/catzc-base-environment/Set-PermanentEnvironmentVariable.ps1.md
    kind: comment-page
    body_sha: "2ac77b2dbffb"
    adrs:
      - ADR-AUTO-CONSOLE#11
    links: []
---

# automation/Catzc.Base.Environment/Set-PermanentEnvironmentVariable.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The single seam through which tooling WRITES a persistent environment variable other than PATH (PATH has its
own, Set-EnvironmentPath), so a logic test can Mock the registry boundary
(`Mock Set-PermanentEnvironmentVariable -ModuleName <module>`) instead of changing the real user environment,
which every other process and every concurrent test run on the machine shares. User/Machine scopes are a
Windows concept; callers guard Windows-only use with $IsWindows.

Because every such write passes through here, this is also where it is announced
([ADR-AUTO-CONSOLE#11](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console11)): one
line names the scope, the variable and the change. Writing the value the scope already holds — or removing a
variable that is not set — is a no-op, so it neither writes nor announces.

This is the thin I/O boundary itself, so its test is the vertical system test (L3): a real round trip through
the user environment.
```

## comment:2

Above `[System.Environment]::SetEnvironmentVariable($Name, [NullString]::Value, $Scope)`.

```text
PowerShell hands $null to a .NET string parameter as '', which the scopes the registry backs store as an empty value;
only a real null deletes it.
```
