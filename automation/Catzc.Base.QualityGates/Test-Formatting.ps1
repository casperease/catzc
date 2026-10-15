<#
.SYNOPSIS
    Quality gate: checks that formatting would leave the repository unchanged.
.DESCRIPTION
    No formatter list lives here: Format-Code -DryRun runs whichever engines languages.yml names.
    [ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35),
    [ADR-PRIN-CONFIG#1](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config1)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/Test-Formatting.ps1.md#comment1)
.PARAMETER Language
    Check only these file languages (default: every one).
.PARAMETER OutputFolder
    The report base folder. Defaults to Write-QualityGateReport's (out/test-formatting).
.PARAMETER PassThru
    Return the gate result { Subject; IssueCount; Issues; ReportPath; Languages } instead of throwing on issues.
.OUTPUTS
    [pscustomobject] With -PassThru only.
.EXAMPLE
    Test-Formatting
.EXAMPLE
    (Test-Formatting -Language pipeline-yaml -PassThru).Issues
#>
function Test-Formatting {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [ArgumentCompleter({ Get-FileLanguage | ForEach-Object name })]
        [string[]] $Language,

        [string] $OutputFolder,

        [switch] $PassThru
    )

    Assert-SourceTree

    $config = Get-Config -Config languages
    $selected = @(if ($Language) {
            foreach ($name in $Language) {
                $match = @($config.languages | Where-Object { $_.name -ceq $name })
                Assert-True ($match.Count -eq 1) -ErrorText "Test-Formatting: unknown file language '$name' (languages.yml declares: $(@($config.languages | ForEach-Object name) -join ', '))."
                $match[0]
            }
        }
        else {
            $config.languages
        })

    $issues = [System.Collections.Generic.List[string]]::new()
    $addIssue = {
        param([string] $Path, [string] $Problem)
        $issues.Add("$(ConvertTo-RepoRelativePath $Path): $Problem")
    }

    $formatted = @($selected | Where-Object { $_.formatter } | ForEach-Object name)
    if ($formatted.Count -gt 0) {
        foreach ($result in @(Format-Code -Language $formatted -DryRun -PassThru)) {
            foreach ($file in $result.ChangedFiles) {
                & $addIssue $file "not formatted — run Format-Code -Language $($result.Language)"
            }
        }
    }

    if ('csharp' -in @($selected | ForEach-Object name)) {
        $types = Format-Types -DryRun -PassThru
        foreach ($file in @($types.ChangedFiles)) {
            & $addIssue $file 'namespace not set from its module folder — run Format-Types'
        }
        # A block-scoped namespace is the one drift Format-Types leaves alone: it needs a hand edit.
        foreach ($file in @($types.BlockScopedFiles)) {
            & $addIssue $file "block-scoped namespace — rewrite it as the file-scoped 'namespace <Module>;'"
        }
    }

    Write-QualityGateReport -Subject formatting -Title Test-Formatting -Issues $issues.ToArray() `
        -Facts ([ordered]@{ Languages = $selected.Count }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
