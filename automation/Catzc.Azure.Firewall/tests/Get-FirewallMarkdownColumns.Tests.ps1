# Get-FirewallMarkdownColumns is a private (non-exported) function, so it is invoked via InModuleScope.
Describe 'Get-FirewallMarkdownColumns' -Tag 'L0', 'logic' {
    BeforeAll {
        # @(...) re-arrayifies: InModuleScope (a pipeline boundary) unrolls a single-element array to a scalar.
        $script:build = {
            param($Splat)
            @(InModuleScope Catzc.Azure.Firewall -Parameters @{ S = $Splat } {
                    param($S)
                    @(Get-FirewallMarkdownColumns @S)
                })
        }

        $script:composites = [ordered]@{
            Source          = @('SourceIpGroups', 'SourceAddresses')
            'Protocol/Port' = @('Protocols', 'DestinationPorts')
            Destination     = @('DestinationAddresses')
        }
        $script:present = @(
            'Name', 'SourceIpGroups', 'SourceAddresses', 'Protocols',
            'DestinationPorts', 'DestinationAddresses', 'RuleCollectionGroup'
        )
    }

    It 'orders columns rule-name, composites, then extras' {
        $cols = & $script:build @{
            RuleNameColumn         = 'Name'
            CompositeColumns       = $script:composites
            ProtocolPortColumnName = 'Protocol/Port'
            AdditionalColumns      = @('RuleCollectionGroup')
            Present                = $script:present
        }
        @($cols | ForEach-Object { $_.Name }) | Should -Be @('Name', 'Source', 'Protocol/Port', 'Destination', 'RuleCollectionGroup')
    }

    It 'marks the protocol/port column protoport+unsorted and other composites list+sorted' {
        $cols = & $script:build @{
            RuleNameColumn         = 'Name'
            CompositeColumns       = $script:composites
            ProtocolPortColumnName = 'Protocol/Port'
            AdditionalColumns      = @()
            Present                = $script:present
        }
        $protoPort = $cols | Where-Object { $_.Name -eq 'Protocol/Port' }
        $protoPort.Render | Should -Be 'protoport'
        $protoPort.Sort | Should -BeFalse
        $source = $cols | Where-Object { $_.Name -eq 'Source' }
        $source.Render | Should -Be 'list'
        $source.Sort | Should -BeTrue
    }

    It 'de-duplicates column names case-insensitively' {
        $cols = & $script:build @{
            RuleNameColumn         = 'Name'
            CompositeColumns       = ([ordered]@{ Source = @('SourceAddresses') })
            ProtocolPortColumnName = 'Protocol/Port'
            AdditionalColumns      = @('name', 'RuleCollectionGroup')   # 'name' duplicates the rule-name column
            Present                = @('Name', 'SourceAddresses', 'RuleCollectionGroup')
        }
        @($cols | ForEach-Object { $_.Name }) | Should -Be @('Name', 'Source', 'RuleCollectionGroup')
    }

    It 'trims candidates to the present CSV headers' {
        $cols = & $script:build @{
            RuleNameColumn         = 'Name'
            CompositeColumns       = ([ordered]@{ Source = @('SourceIpGroups', 'SourceAddresses') })
            ProtocolPortColumnName = 'Protocol/Port'
            AdditionalColumns      = @()
            Present                = @('Name', 'SourceAddresses')   # SourceIpGroups absent
        }
        $source = $cols | Where-Object { $_.Name -eq 'Source' }
        $source.Candidates | Should -Be @('SourceAddresses')
    }

    It 'throws a schema mismatch when a column has no backing present field' {
        {
            & $script:build @{
                RuleNameColumn         = 'Name'
                CompositeColumns       = ([ordered]@{ Source = @('SourceIpGroups', 'SourceAddresses') })
                ProtocolPortColumnName = 'Protocol/Port'
                AdditionalColumns      = @()
                Present                = @('Name')   # nothing backs Source
            }
        } | Should -Throw '*No matching CSV fields*'
    }

    It 'skips trimming and validation when present headers are empty (no rows)' {
        $cols = & $script:build @{
            RuleNameColumn         = 'Name'
            CompositeColumns       = ([ordered]@{ Source = @('SourceIpGroups') })
            ProtocolPortColumnName = 'Protocol/Port'
            AdditionalColumns      = @()
            Present                = @()
        }
        # Candidates are kept verbatim (no header set to trim against), and nothing throws.
        ($cols | Where-Object { $_.Name -eq 'Source' }).Candidates | Should -Be @('SourceIpGroups')
    }
}
