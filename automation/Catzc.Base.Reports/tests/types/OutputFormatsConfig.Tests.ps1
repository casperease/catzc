<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Reports/tests/types/OutputFormatsConfig.Tests.ps1
    kind: test
---
#>

Describe 'Catzc.Base.Reports.OutputFormatsConfig' -Tag 'L0', 'logic' {
    BeforeAll {
        function script:New-Format {
            param([hashtable] $Extra = @{})
            $format = @{
                patterns  = @('widgets/*.png')
                producer  = 'New-Widget'
                audience  = 'a person, in any image viewer'
                validator = @{ kind = 'png' }
            }
            foreach ($key in $Extra.Keys) {
                $format[$key] = $Extra[$key]
            }
            $format
        }
        function script:Get-LoadError {
            param([hashtable] $Raw)
            try {
                $null = [Catzc.Base.Reports.OutputFormatsConfig]::new($Raw)
            }
            catch {
                return $_.Exception.InnerException.Message
            }
            throw 'expected the catalogue to be rejected'
        }
    }

    It 'maps a well-formed catalogue, defaulting the target to file' -Tag 'ADR-REPO-OUTFMT#1' {
        $config = [Catzc.Base.Reports.OutputFormatsConfig]::new(@{ formats = [ordered]@{
                    'widget-png'    = (New-Format @{ limits = @{ width = 480; height = 300 } })
                    'gadget-bundle' = (New-Format @{ patterns = @('gadgets/*'); target = 'folder'; validator = @{ kind = 'delegate'; command = 'Assert-Gadget' } })
                }
            })
        @($config.formats.Keys) | Should -Be @('widget-png', 'gadget-bundle')
        $widget = $config.formats['widget-png']
        $widget.target | Should -Be 'file'
        $widget.validator_kind | Should -Be 'png'
        $widget.limits['width'] | Should -Be 480
        $config.formats['gadget-bundle'].validator_parameters['command'] | Should -Be 'Assert-Gadget'
    }

    It 'keeps a list parameter as a list' -Tag 'ADR-REPO-OUTFMT#3' {
        $config = [Catzc.Base.Reports.OutputFormatsConfig]::new(@{ formats = @{
                    'widget-index' = (New-Format @{ patterns = @('widgets/_index.json'); validator = @{ kind = 'json'; required_keys = @('id', 'name') } })
                }
            })
        @($config.formats['widget-index'].validator_parameters['required_keys']) | Should -Be @('id', 'name')
    }

    It 'requires a non-empty formats map and rejects any other top-level key' -Tag 'ADR-REPO-OUTFMT#1' {
        $message = Get-LoadError @{ gadgets = @{} }
        $message | Should -Match "unknown top-level key 'gadgets'"
        $message | Should -Match "'formats' is required"
    }

    It 'reports every malformed entry in one throw' -Tag 'ADR-REPO-OUTFMT#1' {
        $message = Get-LoadError @{ formats = @{
                'Widget_PNG' = (New-Format @{ colour = 'blue' })
                'gadget-doc' = @{ patterns = @(); validator = @{ kind = 'png' } }
                'gadget-log' = (New-Format @{ patterns = @('../escape/*.log', 'C:/rooted.log'); target = 'tree' })
            }
        }
        $message | Should -Match "format 'Widget_PNG': the id must be kebab-case"
        $message | Should -Match "format 'Widget_PNG': unknown key 'colour'"
        $message | Should -Match "format 'gadget-doc': patterns must list at least one"
        $message | Should -Match "format 'gadget-doc': producer is required"
        $message | Should -Match "format 'gadget-doc': audience is required"
        $message | Should -Match "pattern '\.\./escape/\*\.log' must be relative to the output root"
        $message | Should -Match "pattern 'C:/rooted\.log' must be relative to the output root"
        $message | Should -Match "target 'tree' must be 'file' or 'folder'"
    }

    It 'rejects an unknown validator kind, a stray parameter, and a missing required one' -Tag 'ADR-REPO-OUTFMT#3' {
        $message = Get-LoadError @{ formats = @{
                'widget-a' = (New-Format @{ validator = @{ kind = 'gif' } })
                'widget-b' = (New-Format @{ patterns = @('b/*'); validator = @{ kind = 'png'; columns = @('x') } })
                'widget-c' = (New-Format @{ patterns = @('c/*'); validator = @{ kind = 'delegate' } })
                'widget-d' = (New-Format @{ patterns = @('d/*'); validator = @{ kind = 'delegate'; command = 'check widgets' } })
                'widget-e' = (New-Format @{ patterns = @('e/*'); validator = @{ kind = 'md'; statuses = @('ok') } })
                'widget-f' = (New-Format @{ patterns = @('f/*'); validator = $null })
            }
        }
        $message | Should -Match "format 'widget-a': validator kind 'gif' is unknown"
        $message | Should -Match "format 'widget-b': validator kind 'png' takes no parameter 'columns'"
        $message | Should -Match "format 'widget-c': validator kind 'delegate' requires 'command'"
        $message | Should -Match "format 'widget-d': validator command 'check widgets' must be a Verb-Noun command name"
        $message | Should -Match "format 'widget-e': validator kind 'md' takes 'statuses' and 'status_column' together"
        $message | Should -Match "format 'widget-f': validator is required"
    }

    It 'rejects an unknown limit and a limit that is not a positive whole number' -Tag 'ADR-REPO-OUTFMT#5' {
        $message = Get-LoadError @{ formats = @{
                'widget-png' = (New-Format @{ limits = @{ depth = 3; width = 0; height = 'tall' } })
            }
        }
        $message | Should -Match "unknown limit 'depth'"
        $message | Should -Match "limit 'width' must be a positive whole number"
        $message | Should -Match "limit 'height' must be a positive whole number"
    }

    It 'rejects two formats whose patterns can match the same path' -Tag 'ADR-REPO-OUTFMT#1' {
        $message = Get-LoadError @{ formats = [ordered]@{
                'widget-png'   = (New-Format)
                'gadget-png'   = (New-Format)
                'widget-any'   = (New-Format @{ patterns = @('widgets/**') })
                'widget-run'   = (New-Format @{ patterns = @('runs/{stamp}/report.md') })
                'widget-fixed' = (New-Format @{ patterns = @('runs/20261014-170757/*.md') })
            }
        }
        $message | Should -Match "pattern 'widgets/\*\.png' of 'widget-png' and pattern 'widgets/\*\.png' of 'gadget-png' can match the same path"
        $message | Should -Match "of 'widget-png' and pattern 'widgets/\*\*' of 'widget-any' can match the same path"
        $message | Should -Match "pattern 'runs/\{stamp\}/report\.md' of 'widget-run' and pattern 'runs/20261014-170757/\*\.md' of 'widget-fixed'"
    }

    It 'accepts patterns no path can match together' -Tag 'ADR-REPO-OUTFMT#1' {
        $config = [Catzc.Base.Reports.OutputFormatsConfig]::new(@{ formats = [ordered]@{
                    'widget-drawing' = (New-Format @{ patterns = @('widgets/**/*.drawio.png') })
                    'widget-sheet'   = (New-Format @{ patterns = @('widgets/**/*.sheet.png') })
                    'widget-run'     = (New-Format @{ patterns = @('runs/{stamp}/report.md') })
                    'widget-latest'  = (New-Format @{ patterns = @('runs/latest.txt') })
                    'widget-pointer' = (New-Format @{ patterns = @('runs/latest/report.md') })
                }
            })
        $config.formats.Count | Should -Be 5
    }

    It 'rejects a malformed pattern' -Tag 'ADR-REPO-OUTFMT#1' {
        $message = Get-LoadError @{ formats = @{
                'widget-png' = (New-Format @{ patterns = @('widgets/a**/*.png', 'widgets/{run}/*.png', 'widgets//x.png') })
            }
        }
        $message | Should -Match "'\*\*' must be a whole segment"
        $message | Should -Match "braces appear only in a whole '\{stamp\}' segment"
        $message | Should -Match 'has an empty segment'
    }
}

Describe 'Catzc.Base.Reports.OutputPattern' -Tag 'L0', 'logic' {
    It 'matches <Path> against <Pattern>: <Expected>' -Tag 'ADR-REPO-OUTFMT#1' -ForEach @(
        @{ Pattern = 'widgets/*.png'; Path = 'widgets/a.png'; Expected = $true }
        @{ Pattern = 'widgets/*.png'; Path = 'widgets/deep/a.png'; Expected = $false }
        @{ Pattern = 'widgets/**/*.png'; Path = 'widgets/a.png'; Expected = $true }
        @{ Pattern = 'widgets/**/*.png'; Path = 'widgets/x/y/a.png'; Expected = $true }
        @{ Pattern = 'widgets/?.png'; Path = 'widgets/ab.png'; Expected = $false }
        @{ Pattern = 'runs/{stamp}/r.md'; Path = 'runs/20261014-181454/r.md'; Expected = $true }
        @{ Pattern = 'runs/{stamp}/r.md'; Path = 'runs/20261014-181454-2350ee/r.md'; Expected = $true }
        @{ Pattern = 'runs/{stamp}/r.md'; Path = 'runs/latest/r.md'; Expected = $false }
        @{ Pattern = 'runs/{stamp}/r.md'; Path = 'runs\20261014-181454\r.md'; Expected = $true }
    ) {
        [Catzc.Base.Reports.OutputPattern]::Parse($Pattern).Matches($Path) | Should -Be $Expected
    }

    It 'overlap of <A> and <B>: <Expected>' -Tag 'ADR-REPO-OUTFMT#1' -ForEach @(
        @{ A = 'widgets/*.png'; B = 'widgets/a.png'; Expected = $true }
        @{ A = 'widgets/*.drawio.png'; B = 'widgets/*.sheet.png'; Expected = $false }
        @{ A = 'widgets/**/*.png'; B = 'widgets/x/y/*.sheet.png'; Expected = $true }
        @{ A = '**'; B = 'gadgets/a.json'; Expected = $true }
        @{ A = 'widgets/a*'; B = 'widgets/*b'; Expected = $true }
        @{ A = 'widgets/a?'; B = 'widgets/?b'; Expected = $true }
        @{ A = 'widgets/ab'; B = 'widgets/a?c'; Expected = $false }
        @{ A = 'runs/{stamp}/r.md'; B = 'runs/latest/r.md'; Expected = $false }
        @{ A = 'runs/{stamp}/r.md'; B = 'runs/*/r.md'; Expected = $true }
        @{ A = 'runs/{stamp}/*.md'; B = 'runs/{stamp}/r.json'; Expected = $false }
    ) {
        $first = [Catzc.Base.Reports.OutputPattern]::Parse($A)
        $second = [Catzc.Base.Reports.OutputPattern]::Parse($B)
        $first.Overlaps($second) | Should -Be $Expected
        $second.Overlaps($first) | Should -Be $Expected
    }
}
