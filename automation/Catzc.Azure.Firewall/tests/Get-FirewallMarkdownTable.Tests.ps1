# Get-FirewallMarkdownTable is a private (non-exported) function, so it is invoked via InModuleScope.
Describe 'Get-FirewallMarkdownTable' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:render = {
            param($Splat)
            InModuleScope Catzc.Azure.Firewall -Parameters @{ S = $Splat } {
                param($S)
                Get-FirewallMarkdownTable @S
            }
        }

        # A minimal list column descriptor (Name/Candidates/Sort/Render), as Get-FirewallMarkdownColumns emits.
        function New-Column {
            param($Name, $Candidates, [switch]$Sort, $Render = 'list')
            [pscustomobject]@{ Name = $Name; Candidates = @($Candidates); Sort = [bool]$Sort; Render = $Render }
        }
    }

    It 'renders a header row, the separator, and one row per record' {
        $out = & $script:render @{
            Rows             = @([pscustomobject]@{ Name = 'r1'; Source = '10.0.0.1' })
            Columns          = @((New-Column 'Name' 'Name'), (New-Column 'Source' 'Source'))
            MultiValueFields = @()
            IpGroupColumns   = @()
        }
        $lines = $out -split '\r?\n'
        $lines[0] | Should -Be '| Name | Source |'
        $lines[1] | Should -Be '| --- | --- |'
        $lines[2] | Should -Be '| r1 | 10.0.0.1 |'
    }

    It 'splits a multi-value field, trims IP-group IDs, and sorts within the cell' {
        $out = & $script:render @{
            Rows             = @([pscustomobject]@{ Name = 'r1'; SourceIpGroups = '/subscriptions/x/ipg-b,/subscriptions/y/ipg-a' })
            Columns          = @((New-Column 'Name' 'Name'), (New-Column 'Source' 'SourceIpGroups' -Sort))
            MultiValueFields = @('SourceIpGroups')
            IpGroupColumns   = @('SourceIpGroups')
        }
        ($out -split '\r?\n')[2] | Should -Be '| r1 | ipg-a, ipg-b |'
    }

    It 'keeps full IP-group resource IDs when -DoNotCutIpgNames is set' {
        $out = & $script:render @{
            Rows             = @([pscustomobject]@{ Name = 'r1'; SourceIpGroups = '/subscriptions/x/ipg-a' })
            Columns          = @((New-Column 'Name' 'Name'), (New-Column 'Source' 'SourceIpGroups'))
            MultiValueFields = @('SourceIpGroups')
            IpGroupColumns   = @('SourceIpGroups')
            DoNotCutIpgNames = $true
        }
        # The full resource id contains slashes, so the cell is just the untrimmed value.
        ($out -split '\r?\n')[2] | Should -Be '| r1 | /subscriptions/x/ipg-a |'
    }

    It 'pairs protocols with ports for the protoport column' {
        $out = & $script:render @{
            Rows             = @([pscustomobject]@{ Name = 'r1'; Protocols = 'TCP'; DestinationPorts = '443' })
            Columns          = @((New-Column 'Name' 'Name'), (New-Column 'Protocol/Port' @('Protocols', 'DestinationPorts') -Render 'protoport'))
            MultiValueFields = @('Protocols', 'DestinationPorts')
            IpGroupColumns   = @()
        }
        ($out -split '\r?\n')[2] | Should -Be '| r1 | TCP:443 |'
    }

    It 'wraps an FQDN-shaped cell in a code span (markdownlint MD034)' {
        $out = & $script:render @{
            Rows             = @([pscustomobject]@{ Name = 'r1'; Dest = 'example.com' })
            Columns          = @((New-Column 'Name' 'Name'), (New-Column 'Destination' 'Dest'))
            MultiValueFields = @()
            IpGroupColumns   = @()
        }
        ($out -split '\r?\n')[2] | Should -Be '| r1 | `example.com` |'
    }
}
