<#
.SYNOPSIS
    Gate: no shipped config may carry a TEST-fixture identity in its data — the reverse of
    Test-LogicTestIdentity, closing the other half of the domain-language separation (ADR-LANG).
.DESCRIPTION
    A shipped `configs/*.yml` or `infrastructure/**` file is the config/live domain: it names real identities.
    A fixture identity (acme/globex, tst, alpha, core_lower, widget, …) appearing in one is a leak — a test
    fixture committed as production data. The forbidden set is DERIVED from the fixture configs
    (Get-FixtureIdentityTokens), so it is always current.

    The scan parses each config with the YAML reader and inspects the parsed KEYS and scalar VALUES — never the
    raw text — so it is comment-blind by construction: a config comment illustrating `[acme, globex]` is not
    data and is not flagged, while a real `have_customers: [acme]` value is. The terminology registry (which
    DEFINES the fixture tokens) is excluded.

    Mirrors the Test-Spelling / Test-Terminology / Test-LogicTestIdentity gate shape (ADR-VERBS:7): throws on
    findings, returns a result object under -PassThru. It reads the shipped config, so a Pester test wrapping
    it is `integrity`.
.PARAMETER Path
    Config files to check. Defaults to every module `configs/*.yml` (except the terminology registry) and every
    `infrastructure/**` yml.
.PARAMETER PassThru
    Return a result object ({ FindingCount; Findings }) instead of throwing.
.OUTPUTS
    None (throws on findings), or the result object with -PassThru.
#>
function Test-ConfigIdentityHygiene {
    [CmdletBinding()]
    param(
        [string[]] $Path,

        [switch] $PassThru
    )

    $fixture = [System.Collections.Generic.HashSet[string]]::new(
        [string[]] (Get-FixtureIdentityTokens), [System.StringComparer]::OrdinalIgnoreCase)

    $root = Get-RepositoryRoot
    if (-not $Path) {
        $terminology = 'configs/terminology.yml'
        $moduleConfigs = [System.IO.Directory]::EnumerateFiles((Join-Path $root 'automation'), '*.yml', [System.IO.SearchOption]::AllDirectories) |
            Where-Object { $_ -match '[\\/]configs[\\/][^\\/]+\.yml$' -and ($_ -replace '\\', '/') -notlike "*$terminology" }
        $infrastructureRoot = Join-Path $root 'infrastructure'
        $infrastructureConfigs = if ([System.IO.Directory]::Exists($infrastructureRoot)) {
            [System.IO.Directory]::EnumerateFiles($infrastructureRoot, '*.yml', [System.IO.SearchOption]::AllDirectories)
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

    if ($PassThru) {
        return [pscustomobject]@{
            FindingCount = $findings.Count
            Findings     = @($findings)
        }
    }

    if ($findings.Count -eq 0) {
        Write-Message "No test-fixture identities in shipped config across $($Path.Count) file(s)."
        return
    }

    foreach ($finding in $findings) {
        $relative = ConvertTo-RepoRelativePath $finding.File
        Write-Message "${relative}: fixture identity '$($finding.Token)' at $($finding.Location) — a shipped config must name a live identity" -NoHeader -ForegroundColor Red
    }

    $preview = @($findings | Select-Object -First 5 | ForEach-Object { "$($_.Token) ($([System.IO.Path]::GetFileName($_.File)))" })
    throw "Test-ConfigIdentityHygiene failed: $($findings.Count) fixture identity value(s) in shipped config — $($preview -join ', ')"
}
