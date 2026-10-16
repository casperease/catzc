<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Docs/tests/Get-GlossarySourceViolations.Tests.ps1
    folder: tests
    name: get-glossary-source-violations-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-docs/tests/Get-GlossarySourceViolations.Tests.ps1.md
    cites:
      - ADR-AUTO-TEST#3
      - ADR-PWSH-PESTER#4
      - ADR-REPO-VOCAB#{1,3-5}
---
#>

Describe 'Get-GlossarySourceViolations' -Tag 'L0', 'logic' {
    BeforeAll {
        Mock Get-Config -ModuleName Catzc.Base.Docs -ParameterFilter { $Config -eq 'adrs' } -MockWith {
            [pscustomobject]@{ Domains = @([pscustomobject]@{ Name = 'automation' }, [pscustomobject]@{ Name = 'repository' }) }
        }
        # A well-formed concept body; a test adds or changes one field.
        $script:concept = {
            param([string] $key, [System.Collections.IDictionary] $extra = @{})
            $body = [ordered]@{
                key         = $key
                domain      = 'automation'
                defined_by  = 'ADR-COG-GADGET#30'
                short       = "The $key."
                realized_by = [ordered]@{ kind = 'prose-only' }
            }
            foreach ($name in $extra.Keys) {
                $body[$name] = $extra[$name]
            }
            $body
        }
        # One source: an owner label and its term -> body map; tracked unless said otherwise.
        $script:source = {
            param([string] $label, [System.Collections.IDictionary] $concepts, [bool] $tracked = $true)
            [pscustomobject]@{
                Owner   = "Catzc.$label"
                Path    = "automation/Catzc.$label/configs/glossary.yml"
                Config  = [Catzc.Base.Docs.GlossaryConfig]::new([ordered]@{ concepts = $concepts })
                Tracked = $tracked
            }
        }
        $script:violations = {
            param([object[]] $sources)
            $found = @(InModuleScope Catzc.Base.Docs -Parameters @{ Sources = $sources } { Get-GlossarySourceViolations -Source $Sources })
            Write-Output -NoEnumerate $found   # keep a single violation an array, so .Count and [0] mean what they say
        }
    }

    It 'reports nothing when the sources agree, contrasts included' -Tag 'ADR-REPO-VOCAB#4' {
        $widget = & $script:source 'Widget' ([ordered]@{
                'widget suite' = (& $script:concept 'widget_suite' @{
                        contrasts = @{ 'gadget run' = 'A gadget run executes; a widget suite is files at rest.' }
                        relations = @{ selected_by = @('gadget run') }
                    })
            })
        $gadget = & $script:source 'Gadget' ([ordered]@{
                'gadget run' = (& $script:concept 'gadget_run' @{ contrasts = @{ 'widget suite' = 'A widget suite is files at rest; a gadget run executes.' } })
            })
        & $script:violations @($gadget, $widget) | Should -BeNullOrEmpty
    }

    It 'reports a term defined by two sources, against the later source' -Tag 'ADR-REPO-VOCAB#1' {
        $first = & $script:source 'Gadget' ([ordered]@{ 'widget suite' = (& $script:concept 'widget_suite') })
        $second = & $script:source 'Widget' ([ordered]@{ 'widget suite' = (& $script:concept 'widget_bundle') })
        $found = & $script:violations @($first, $second)
        $found.Count | Should -Be 1
        $found[0] | Should -BeLike "automation/Catzc.Widget/configs/glossary.yml: term 'widget suite' is already defined by automation/Catzc.Gadget/configs/glossary.yml*"
    }

    It 'reports a machine key used by two sources' -Tag 'ADR-REPO-VOCAB#1' {
        $first = & $script:source 'Gadget' ([ordered]@{ 'gadget run' = (& $script:concept 'widget_suite') })
        $second = & $script:source 'Widget' ([ordered]@{ 'widget suite' = (& $script:concept 'widget_suite') })
        $found = & $script:violations @($first, $second)
        $found.Count | Should -Be 1
        $found[0] | Should -BeLike "automation/Catzc.Widget/configs/glossary.yml: concept 'widget suite': key 'widget_suite' is already used by 'gadget run' in automation/Catzc.Gadget/*"
    }

    It 'reports a domain that adrs.yml does not declare' -Tag 'ADR-REPO-VOCAB#1' {
        $widget = & $script:source 'Widget' ([ordered]@{ 'widget suite' = (& $script:concept 'widget_suite' @{ domain = 'gadgetry' }) })
        $found = & $script:violations @($widget)
        $found.Count | Should -Be 1
        $found[0] | Should -BeLike "*concept 'widget suite': domain 'gadgetry' is not an adrs.yml domain*"
    }

    It 'reports an avoided phrase that is another source''s term' -Tag 'ADR-REPO-VOCAB#5' {
        $gadget = & $script:source 'Gadget' ([ordered]@{ 'gadget run' = (& $script:concept 'gadget_run') })
        $widget = & $script:source 'Widget' ([ordered]@{
                'widget suite' = (& $script:concept 'widget_suite' @{ avoid = @(@{ phrase = 'Gadget Run'; say = 'widget suite' }) })
            })
        $found = & $script:violations @($gadget, $widget)
        $found.Count | Should -Be 1
        $found[0] | Should -BeLike "automation/Catzc.Widget/*: concept 'widget suite': avoided phrase 'gadget run' is the term defined by automation/Catzc.Gadget/*"
    }

    It 'reports a contrast or relation target that no source defines' -Tag 'ADR-REPO-VOCAB#3' {
        $widget = & $script:source 'Widget' ([ordered]@{
                'widget suite' = (& $script:concept 'widget_suite' @{
                        contrasts = @{ 'gadget run' = 'A gadget run executes; a widget suite is files at rest.' }
                        relations = @{ part_of = @('widget module') }
                    })
            })
        $found = & $script:violations @($widget)
        $found | Should -HaveCount 2
        $found | Should -Contain "automation/Catzc.Widget/configs/glossary.yml: concept 'widget suite': contrast target 'gadget run' is not a defined term (ADR-REPO-VOCAB#3)"
        $found | Should -Contain "automation/Catzc.Widget/configs/glossary.yml: concept 'widget suite': part_of target 'widget module' is not a defined term (ADR-REPO-VOCAB#3)"
    }

    It 'reports a contrast that is not reciprocal, against the side that has it' -Tag 'ADR-REPO-VOCAB#4' {
        $widget = & $script:source 'Widget' ([ordered]@{
                'widget suite' = (& $script:concept 'widget_suite' @{ contrasts = @{ 'gadget run' = 'A gadget run executes; a widget suite is files at rest.' } })
            })
        $gadget = & $script:source 'Gadget' ([ordered]@{ 'gadget run' = (& $script:concept 'gadget_run') })
        $found = & $script:violations @($gadget, $widget)
        $found.Count | Should -Be 1
        $found[0] | Should -BeLike "automation/Catzc.Widget/*: concept 'widget suite': contrasts 'gadget run', but 'gadget run' (automation/Catzc.Gadget/configs/glossary.yml) does not contrast 'widget suite' back*"
    }

    It 'reports a source that git does not track' -Tag 'ADR-REPO-VOCAB#3' {
        $widget = & $script:source 'Widget' ([ordered]@{ 'widget suite' = (& $script:concept 'widget_suite') }) $false
        $found = & $script:violations @($widget)
        $found.Count | Should -Be 1
        $found[0] | Should -BeLike 'automation/Catzc.Widget/configs/glossary.yml: the glossary source is not tracked by git*'
    }

    It 'reports nothing for no sources' {
        & $script:violations @() | Should -BeNullOrEmpty
    }
}
