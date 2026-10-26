function Test-Markdownlint {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [Parameter(Position = 0)]
        [string[]] $Path = @(
            (Get-Config -Config globs).Get('markdown-scope').Include.Pattern | Where-Object { $_ -like '*.md' }
            (Get-Config -Config globs).Get('markdown-scope').Exclude.Pattern | ForEach-Object { "!$_" }
        ),

        [string] $OutputFolder,

        [switch] $PassThru
    )

    $root = Get-RepositoryRoot
    $configPath = [Catzc.Base.RootConfig.RootConfigFiles]::MarkdownlintConfigPath($root)
    Assert-PathExist $configPath

    Assert-Command 'markdownlint-cli2' -ErrorText (
        'markdownlint-cli2 is not installed. Install it with:  Install-Markdownlint   ' +
        '(or: npm install -g markdownlint-cli2), then re-run Test-Markdownlint.'
    )

    # Batches keep each command line short; every batch carries all the '!' exclusions so each one is scoped alike.
    $exclusions = @($Path | Where-Object { $_.StartsWith('!') } | ForEach-Object { "'$_'" })
    $targets = @($Path | Where-Object { -not $_.StartsWith('!') } | ForEach-Object {
            if ([System.IO.Directory]::Exists([System.IO.Path]::Combine($root, $_))) {
                "$($_.TrimEnd('/', '\'))/**/*.md"
            }
            else {
                $_
            }
        })
    $batchSize = (Get-Config -Config markdownlint).batch_size
    $exitCode = 0
    $outputs = [System.Collections.Generic.List[string]]::new()
    for ($start = 0; $start -lt $targets.Count; $start += $batchSize) {
        $batch = @($targets[$start..([Math]::Min($start + $batchSize, $targets.Count) - 1)])
        $quotedPaths = foreach ($p in $batch) {
            "'$p'"
        }
        $command = "markdownlint-cli2 $(@($quotedPaths) + $exclusions -join ' ')"

        # The output is captured, not streamed; the report prints the issues.
        $result = Invoke-Executable $command -PassThru -NoAssert -Silent

        # markdownlint-cli2 exit codes: 0 = clean, 1 = lint violations found, >1 = tool error.
        if ($result.ExitCode -gt 1) {
            throw "markdownlint-cli2 failed (exit $($result.ExitCode)): $($result.Full)"
        }
        $exitCode = [Math]::Max($exitCode, $result.ExitCode)
        $outputs.Add($result.Full)
    }
    $full = $outputs -join "`n"

    # Violation lines look like:  path/to/file.md:12:5 MD013/line-length Line length [Expected: 140; ...]
    $issues = @($full -split '\r?\n' | Where-Object { $_ -match ' MD\d{3}/' })
    if ($exitCode -ne 0 -and $issues.Count -eq 0) {
        # A failing exit with no parsable violation line: the wording changed — report the raw output, never pass.
        $issues = @("markdownlint-cli2 exited $exitCode with no parsable violation line: $full")
    }

    $facts = [ordered]@{
        FileCount = @($issues | ForEach-Object { ($_ -split ':')[0] } | Select-Object -Unique).Count
        ExitCode  = $exitCode
    }
    Write-QualityGateReport -Subject markdownlint -Title Test-Markdownlint -Issues $issues -Facts $facts `
        -OutputFolder $OutputFolder -PassThru:$PassThru
}
