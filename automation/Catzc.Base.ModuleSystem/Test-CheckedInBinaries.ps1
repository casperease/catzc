<#
---
catzc:
  derived:
    path: automation/Catzc.Base.ModuleSystem/Test-CheckedInBinaries.ps1
    kind: function
    subkind: gate
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.ModuleSystem
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: public
    relatives:
      test: automation/Catzc.Base.ModuleSystem/tests/Test-CheckedInBinaries.Tests.ps1
    adrs:
      - ADR-AUTO-TEST#35
  config:
    synopsis: 'Quality gate: every checked-in binary in the repository is stored byte-exact.'
    description: |-
      A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)) over every
      tracked file — the vendored modules (automation/.vendor/**) and the committed combined C# types assembly
      (automation/.compiled/**, see the caching ADR) as much as the diagrams and documents under docs/. A tracked file is
      a binary the way git decides — a NUL byte in its first 8000 bytes — so the gate follows the content, not an
      extension list, and a binary of a type .gitattributes does not name yet fails here instead of slipping by. For each
      binary it collects an issue when:

        - git stores it as text: `git ls-files --eol` reports its index EOL as lf, crlf, or mixed (git applied EOL
          conversion and corrupted the bytes) rather than -text;
        - no .gitattributes rule marks it binary: `git check-attr binary` reports `set` only when a rule applies (it
          never sniffs content), so this fails as soon as a rule is removed, before any corruption.

      It drives the git CLI over the repository's index and .gitattributes, which exist only in a git work tree.
    parameters:
      OutputFolder: The report base folder. Defaults to out/test-checked-in-binaries/ (Write-QualityGateReport).
      PassThru: Return the result ({ Subject; IssueCount; Issues; ReportPath; Binaries }) instead of throwing on issues.
    outputs: '[pscustomobject] With -PassThru only.'
    examples:
      - Test-CheckedInBinaries
---
#>

function Test-CheckedInBinaries {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    $repositoryRoot = Get-RepositoryRoot
    $listing = Invoke-Executable "git -C `"$repositoryRoot`" -c core.quotepath=off ls-files --eol" -PassThru -Silent

    $binaries = [System.Collections.Generic.List[object]]::new()
    foreach ($line in ($listing.Output -split "`r?`n")) {
        # The path follows the one TAB; the attr/ column may itself hold spaces (`attr/text eol=lf`).
        if ($line -notmatch '^i/(?<index>\S+)\s+w/\S*\s+attr/[^\t]*\t(?<path>.+)$') {
            continue
        }
        $indexEol = $Matches['index']
        $path = $Matches['path'].Trim()
        $full = Join-Path $repositoryRoot $path
        if (-not [System.IO.File]::Exists($full)) {
            continue
        }

        $stream = [System.IO.File]::OpenRead($full)
        try {
            $buffer = [byte[]]::new(8000)
            $read = $stream.Read($buffer, 0, $buffer.Length)
        }
        finally {
            $stream.Dispose()
        }
        if ([System.Array]::IndexOf($buffer, [byte]0, 0, $read) -ge 0) {
            $binaries.Add([pscustomobject]@{ Path = $path; IndexEol = $indexEol })
        }
    }

    $issues = [System.Collections.Generic.List[string]]::new()
    foreach ($binary in $binaries) {
        if ($binary.IndexEol -in 'lf', 'crlf', 'mixed') {
            $issues.Add("$($binary.Path): stored as text, not binary (git index eol = $($binary.IndexEol))")
        }
    }

    # Batches keep each command line short.
    for ($start = 0; $start -lt $binaries.Count; $start += 100) {
        $batch = $binaries[$start..([Math]::Min($start + 99, $binaries.Count - 1))]
        $quotedPaths = foreach ($binary in $batch) {
            "`"$($binary.Path)`""
        }
        $attributes = Invoke-Executable "git -C `"$repositoryRoot`" -c core.quotepath=off check-attr binary -- $($quotedPaths -join ' ')" -PassThru -Silent
        foreach ($line in ($attributes.Output -split "`r?`n")) {
            if ($line -and $line -notmatch ':\s*binary:\s*set$') {
                $issues.Add("$(($line -split ':\s*binary:')[0]): no explicit binary .gitattributes rule")
            }
        }
    }

    Write-QualityGateReport -Subject 'checked-in-binaries' -Title 'Test-CheckedInBinaries' -Issues $issues `
        -Facts ([ordered]@{ Binaries = $binaries.Count }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
