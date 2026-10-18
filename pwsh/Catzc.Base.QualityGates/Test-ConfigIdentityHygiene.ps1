function Test-ConfigIdentityHygiene {
    [CmdletBinding()]
    param(
        [string[]] $Path,

        [string] $OutputFolder,

        [switch] $PassThru
    )

    # The forbidden set comes from the test fixtures, which exist only in the catzc source tree.
    Assert-SourceTree

    $fixture = [System.Collections.Generic.HashSet[string]]::new(
        [string[]] (Get-FixtureIdentityTokens), [System.StringComparer]::OrdinalIgnoreCase)

    $root = Get-RepositoryRoot
    if (-not $Path) {
        $terminology = 'configs/terminology.yml'
        # A module's configs sit three levels below pwsh/ (module, configs, file); infrastructure ymls reach five.
        $moduleConfigs = Get-ChildPath (Join-Path $root (Get-CatzcModulesFolder)) -File -Filter '*.yml' -Depth 3 -PruneVendor $true |
            Where-Object { $_ -match '[\\/]configs[\\/][^\\/]+\.yml$' -and ($_ -replace '\\', '/') -notlike "*$terminology" }
        $infrastructureRoot = Join-Path $root 'infrastructure'
        $infrastructureConfigs = if ([System.IO.Directory]::Exists($infrastructureRoot)) {
            Get-ChildPath $infrastructureRoot -File -Filter '*.yml' -Depth 5
        }
        else {
            @()
        }
        $Path = @($moduleConfigs) + @($infrastructureConfigs) | Sort-Object
    }

    $findings = [System.Collections.Generic.List[object]]::new()
    foreach ($file in $Path) {
        $parsed = [System.IO.File]::ReadAllText($file) | ConvertFrom-Yaml -Ordered

        # Iterative walk of the parsed structure — keys and scalar values only, so comments never enter.
        $stack = [System.Collections.Generic.Stack[object]]::new()
        $stack.Push([System.Tuple]::Create([object] $parsed, ''))
        while ($stack.Count -gt 0) {
            $current = $stack.Pop()
            $node = $current.Item1
            $nodePath = $current.Item2

            if ($node -is [System.Collections.IDictionary]) {
                foreach ($key in @($node.Keys)) {
                    $keyText = "$key"
                    if ($fixture.Contains($keyText)) {
                        $findings.Add([pscustomobject]@{ File = $file; Token = $keyText; Location = "$nodePath/$keyText (key)" })
                    }
                    $stack.Push([System.Tuple]::Create([object] $node[$key], "$nodePath/$keyText"))
                }
            }
            elseif ($node -is [string]) {
                if ($fixture.Contains($node)) {
                    $findings.Add([pscustomobject]@{ File = $file; Token = $node; Location = $nodePath })
                }
            }
            elseif ($node -is [System.Collections.IEnumerable]) {
                $index = 0
                foreach ($item in $node) {
                    $stack.Push([System.Tuple]::Create([object] $item, "$nodePath[$index]"))
                    $index++
                }
            }
        }
    }

    $issues = [System.Collections.Generic.List[string]]::new()

    # The two identity sets are disjoint: a fixture token that is also a live identity is no fixture at all.
    $liveTokens = @(Get-LiveIdentityTokens)
    foreach ($live in $liveTokens) {
        if ($fixture.Contains($live.Token)) {
            $issues.Add("fixture identity '$($live.Token)' is also a live identity ($($live.Kind) in $($live.Source)) — a test fixture must be distinct from every live identity")
        }
    }

    foreach ($finding in $findings) {
        $issues.Add("$(ConvertTo-RepoRelativePath $finding.File): fixture identity '$($finding.Token)' at $($finding.Location) — a shipped config must name a live identity")
    }

    Write-QualityGateReport -Subject config-identity-hygiene -Title Test-ConfigIdentityHygiene -Issues $issues `
        -Facts ([ordered]@{ FileCount = @($Path).Count; LiveTokens = $liveTokens.Count }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
