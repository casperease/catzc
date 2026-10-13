<#
.SYNOPSIS
    Writes a quality gate's report, prints it, and ends the gate: throws once with every issue, or returns the result.
.DESCRIPTION
    The one implementation of a quality gate's output
    ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)), so every gate reports the same way:

      - a run folder <output root>/<folder>/<stamp>/ holding <report_file> — a markdown report naming the gate, its
        facts, and every issue — and <latest_file> beside the stamped folders, naming the latest run;
      - each issue printed, then the count (or "No <subject> issues found."), then the report path;
      - with -PassThru, a result object instead of a throw; otherwise, when there are issues, one throw that lists them
        all (a fail-fast, aggregated verdict).

    Folder and file names come from configs/reports.yml (Catzc.Base.Reports.ReportsConfig), whose defaults give
    out/test-<subject>/<yyyyMMdd-HHmmss>/<subject>.md and out/test-<subject>/latest.txt. A gate calls this last, with the
    issues it collected; it never writes its own report.
.PARAMETER Subject
    The gate's subject, kebab-case ('spelling', 'shipped-configs'); names the report folder and file.
.PARAMETER Title
    The gate's display name ('Test-Spelling'); heads the report and starts the failure message.
.PARAMETER Issues
    Every issue the gate found, one message each; empty when the repository passes.
.PARAMETER Facts
    Optional ordered facts about the run (e.g. @{ Terms = 412 }), listed in the report and added to the -PassThru object.
.PARAMETER OutputFolder
    The report base folder. Defaults to <output root>/<folder from reports.yml>.
.PARAMETER PassThru
    Return { Subject; IssueCount; Issues; ReportPath; <facts> } instead of throwing on issues.
.OUTPUTS
    [pscustomobject] With -PassThru only.
.EXAMPLE
    Write-QualityGateReport -Subject spelling -Title Test-Spelling -Issues $issues -Facts ([ordered]@{ Files = 812 }) -PassThru:$PassThru
#>
function Write-QualityGateReport {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-ParameterFillIn', '', Justification = 'Every gate forwards its own -OutputFolder here, empty when its caller gave none; an explicit empty argument would override a declared default (ADR-AUTO-PSPARAM#4)')]
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [ValidatePattern('^[a-z0-9]+(-[a-z0-9]+)*$')]
        [string] $Subject,

        [Parameter(Mandatory)]
        [string] $Title,

        [AllowEmptyCollection()]
        [string[]] $Issues = @(),

        [System.Collections.IDictionary] $Facts = [ordered]@{},

        [string] $OutputFolder,

        [switch] $PassThru
    )

    $settings = Get-Config -Config reports
    # A body fill-in on purpose: every gate forwards its own -OutputFolder here, empty when its caller gave none, and
    # an explicit empty argument would override a declared default
    # ([ADR-AUTO-PSPARAM#4](/docs/adr/automation/powershell/parameter-design.md#rule-adr-auto-psparam4)).
    if (-not $OutputFolder) {
        $OutputFolder = Join-Path (Get-OutputRoot -EnsureExists) $settings.FolderFor($Subject)
    }
    $stamp = Get-Date -Format $settings.stamp_format
    $runDir = Join-Path $OutputFolder $stamp
    $suffix = 2
    while ([System.IO.Directory]::Exists($runDir)) {
        $runDir = Join-Path $OutputFolder "$stamp-$suffix"
        $suffix++
    }
    [void][System.IO.Directory]::CreateDirectory($runDir)

    $lines = [System.Collections.Generic.List[string]]::new()
    $lines.Add("# $Title report")
    $lines.Add('')
    $lines.Add("- Generated: $stamp")
    foreach ($key in $Facts.Keys) {
        $lines.Add("- ${key}: $($Facts[$key])")
    }
    if ($Issues.Count -eq 0) {
        $lines.Add("- Result: no $Subject issues")
    }
    else {
        $lines.Add("- Issues: $($Issues.Count)")
        $lines.Add('')
        $lines.Add('## Issues')
        $lines.Add('')
        foreach ($issue in $Issues) {
            $lines.Add("- $issue")
        }
    }
    $utf8 = [System.Text.UTF8Encoding]::new($false)
    [System.IO.File]::WriteAllText((Join-Path $runDir $settings.ReportFileFor($Subject)), (($lines -join "`n") + "`n"), $utf8)
    [System.IO.File]::WriteAllText((Join-Path $OutputFolder $settings.latest_file), ((Split-Path $runDir -Leaf) + "`n"), $utf8)

    if ($Issues.Count -eq 0) {
        Write-Message "No $Subject issues found."
    }
    else {
        foreach ($issue in $Issues) {
            Write-Message $issue -NoHeader
        }
        Write-Message "$($Issues.Count) $Subject issue(s)."
    }
    Write-Message "$Title report: $runDir" -ForegroundColor Cyan -NoHeader

    if ($PassThru) {
        $result = [ordered]@{
            Subject    = $Subject
            IssueCount = $Issues.Count
            Issues     = [string[]] @($Issues)
            ReportPath = $runDir
        }
        foreach ($key in $Facts.Keys) {
            $result[$key] = $Facts[$key]
        }
        return [pscustomobject]$result
    }

    if ($Issues.Count -gt 0) {
        throw "$Title failed: $($Issues.Count) issue(s) — see $runDir`n$($Issues -join "`n")"
    }
}
