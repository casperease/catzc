<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/tests/Test-LinkDirections.Tests.ps1.md"
  header: "generated"
---
#>

Describe 'Test-LinkDirections' -Tag 'L0', 'logic', 'ADR-REPO-LINKS-CHECKEDBYONEGATE', 'ADR-REPO-LINKS-DIRECTIONSAREROWS', 'ADR-AUTO-TEST-QUALITYGATE' {
    BeforeAll {
        $script:writeFile = {
            param([string] $Root, [string] $Relative, [string] $Text)
            $full = Join-Path $Root $Relative
            [System.IO.Directory]::CreateDirectory((Split-Path $full -Parent)) | Out-Null
            [System.IO.File]::WriteAllText($full, $Text)
        }
    }

    BeforeEach {
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
        $script:root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $script:reportBase = Join-Path $TestDrive "reports-$([guid]::NewGuid().ToString('N'))"
        & $writeFile $root 'docs/drs/index.md' "| Code | ADR |`n| ---- | --- |`n| ``ADR-TST-WIDGET`` | [widget-rules](widget/widget-rules.md) |`n"
        & $writeFile $root 'docs/drs/widget/widget-rules.md' "# Widget rules`n`n### Rule ADR-TST-WIDGET-SPIN`n`nOne.`n`n### Rule ADR-TST-WIDGET-AWAY`n`nTwo.`n"
        & $writeFile $root 'docs/gadget.md' "# Gadget`n"
        & $writeFile $root 'mods/gizmo.ps1' "function Get-Gizmo { }`n"
        InModuleScope Catzc.Base.QualityGates {
            # The class follows the path: an ADR, a how-to, code; every other facet is empty.
            Mock Get-LinkEndpoint {
                $table = [System.Collections.Generic.Dictionary[string, Catzc.Base.QualityGates.LinkEndpoint]]::new([System.StringComparer]::Ordinal)
                foreach ($p in $Path) {
                    $class = if ($p -like 'docs/drs/*') {
                        'adr'
                    }
                    elseif ($p -like 'docs/*') {
                        'how-to'
                    }
                    else {
                        'code'
                    }
                    $table[$p] = [Catzc.Base.QualityGates.LinkEndpoint]::new($p, $class, '', '', '', '')
                }
                , $table
            }
        }
        $script:rows = {
            param([hashtable] $Exempt = @{})
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Exempt = $Exempt } {
                param($Exempt)
                $config = [Catzc.Base.QualityGates.LinkDirectionsConfig]::new([ordered]@{
                        rows   = @(
                            @{ relations = @('code_link'); from = @{ classes = @('code') }; to = @{ classes = @('adr') }; verdict = 'allow'; because = 'ADR-TST-WIDGET-SPIN' }
                            @{ relations = @('code_link'); verdict = 'deny'; because = 'ADR-TST-WIDGET-AWAY' }
                        )
                        exempt = $Exempt
                    })
                Mock Get-Config -ParameterFilter { $Config -eq 'link-directions' } { $config }.GetNewClosure()
            }
        }
        # Each case scans only the tree it judges; the fixture index links the ADR and is no part of any case.
        $script:gate = {
            param([string] $Scope = 'mods', [switch] $PassThru)
            Test-LinkDirections -RepositoryRoot $root -Path (Join-Path $root $Scope) -OutputFolder $reportBase -PassThru:$PassThru
        }
    }

    It 'passes when every relation is allowed by its first matching row' {
        & $rows
        & $writeFile $root 'mods/widget.ps1' "# Spins as [ADR-TST-WIDGET-SPIN](/docs/drs/widget/widget-rules.md#rule-adr-tst-widget-spin) says.`n"
        $result = & $gate -PassThru
        $result.IssueCount | Should -Be 0
        $result.Facts.EdgeCount | Should -Be 1
    }

    It 'throws on a relation a row denies, naming the file, line, both classes, the row and its rule' {
        & $rows
        & $writeFile $root 'mods/widget.ps1' "`$x = 1`n# Read [gadget](/docs/gadget.md) first.`n"
        { & $gate } |
            Should -Throw '*mods/widget.ps1:2 `[CodeLink`] code -> how-to denied by row 2: ADR-TST-WIDGET-AWAY*'
    }

    It 'throws on a relation no row allows' {
        & $rows
        & $writeFile $root 'docs/drs/widget/widget-rules.md' "# Widget rules`n`n### Rule ADR-TST-WIDGET-SPIN`n`nSee [gadget](../../gadget.md).`n`n### Rule ADR-TST-WIDGET-AWAY`n`nTwo.`n"
        { & $gate 'docs/drs/widget' } |
            Should -Throw '*docs/drs/widget/widget-rules.md:5 `[MarkdownLink`] adr -> how-to no row allows it*'
    }

    It 'skips every relation of an exempt file and judges the rest' {
        & $rows @{ 'mods/widget.ps1' = 'a fixture that links a how-to on purpose' }
        & $writeFile $root 'mods/widget.ps1' "# Read [gadget](/docs/gadget.md) first.`n"
        & $writeFile $root 'mods/sprocket.ps1' "# Spins as [ADR-TST-WIDGET-SPIN](/docs/drs/widget/widget-rules.md#rule-adr-tst-widget-spin) says.`n"
        (& $gate -PassThru).IssueCount | Should -Be 0
    }

    It 'fails a run that found no relation, never passes it' {
        & $rows
        { & $gate } | Should -Throw '*no relation found*'
    }
}
