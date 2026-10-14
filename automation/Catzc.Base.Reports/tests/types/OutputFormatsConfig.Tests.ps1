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

    It 'rejects a pattern declared by two formats' -Tag 'ADR-REPO-OUTFMT#1' {
        $message = Get-LoadError @{ formats = [ordered]@{
                'widget-png' = (New-Format)
                'gadget-png' = (New-Format)
            }
        }
        $message | Should -Match "pattern 'widgets/\*\.png' is declared by both 'widget-png' and 'gadget-png'"
    }
}
