function Write-QualityGateReport {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-ParameterFillIn', '', Justification = 'Every gate forwards its own -OutputFolder here, empty when its caller gave none; an explicit empty argument would override a declared default (ADR-PWSH-PARAM#4)')]
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
        # The seam while the gates move to QualityGateResult (ADR-PRIN-ONELIVE#8): facts both flattened and under Facts.
        foreach ($key in $Facts.Keys) {
            $result[$key] = $Facts[$key]
        }
        $result['Facts'] = [Catzc.Base.Reports.QualityGateResult]::new($Subject, [string[]] @($Issues), $runDir, $Facts).Facts
        return [pscustomobject]$result
    }

    if ($Issues.Count -gt 0) {
        throw "$Title failed: $($Issues.Count) issue(s) — see $runDir`n$($Issues -join "`n")"
    }
}
