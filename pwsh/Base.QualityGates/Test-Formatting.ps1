function Test-Formatting {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [ArgumentCompleter({ Get-FileLanguage | ForEach-Object name })]
        [string[]] $Language,

        [Catzc.Base.Asserts.ValidatePathGiven()]
        [string[]] $Path,

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
        $scope = @{ Language = $formatted }
        if ($Path) {
            $scope['Path'] = $Path
        }
        foreach ($result in @(Format-Code @scope -DryRun -PassThru)) {
            foreach ($file in $result.ChangedFiles) {
                & $addIssue $file "not formatted — run Format-Code -Language $($result.Language)"
            }
            # What an imprint step found wrong but cannot repair needs a hand edit.
            foreach ($file in $result.Unfixable.Keys) {
                & $addIssue $file $result.Unfixable[$file]
            }
        }
    }

    # Unless a language narrows the run, a file no formatter, no_formatter reason or carrier class covers is a finding.
    if (-not $Language) {
        $resolver = [Catzc.Base.Languages.FileCarrierResolver]::new((Get-Config -Config file-carriers), $config)
        # Get-FormatScope returns its paths as one array: assign it, so foreach walks the paths, not the array.
        $scope = Get-FormatScope -RepositoryRoot (Get-RepositoryRoot) -Path $Path
        foreach ($file in $scope) {
            $fileLanguage = $config.ForPath($file)
            if ($null -eq $fileLanguage) {
                if ($null -eq $resolver.For((ConvertTo-RepoRelativePath $file))) {
                    & $addIssue $file 'no Format-* command covers it — neither a file language in languages.yml nor a file class in file-carriers.yml claims it'
                }
            }
            elseif (-not $fileLanguage.formatter -and -not $fileLanguage.no_formatter) {
                & $addIssue $file "no Format-* command covers it — its language '$($fileLanguage.name)' has no formatter and states no no_formatter reason"
            }
        }
    }

    Write-QualityGateReport -Subject formatting -Title Test-Formatting -Issues $issues.ToArray() `
        -Facts ([ordered]@{ Languages = $selected.Count; Paths = @($Path).Count }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
