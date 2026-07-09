Describe 'Get-AdrDomainEdges integrity' -Tag 'L1', 'integrity' {
    BeforeAll {
        $script:edges = Get-AdrDomainEdges
        $script:domains = @((Get-Config -Config adrs).Domains.Name)
    }

    It 'produces one edge per declared depends_on link, both ends real domains' {
        $script:edges.Count | Should -BeGreaterThan 0
        foreach ($edge in $script:edges) {
            $edge.From | Should -BeIn $script:domains
            $edge.To | Should -BeIn $script:domains
        }
    }

    It 'the domain dependency graph is acyclic (Kahn: every node becomes removable)' {
        $remaining = [System.Collections.Generic.List[string]]::new()
        $script:domains | ForEach-Object { $remaining.Add($_) }
        $out = @{}
        foreach ($domain in $script:domains) {
            $out[$domain] = @()
        }
        foreach ($edge in $script:edges) {
            $out[$edge.From] += $edge.To
        }

        $progress = $true
        while ($progress -and $remaining.Count -gt 0) {
            $progress = $false
            foreach ($node in @($remaining)) {
                $pending = @($out[$node] | Where-Object { $_ -in $remaining })
                if ($pending.Count -eq 0) {
                    [void]$remaining.Remove($node)
                    $progress = $true
                }
            }
        }
        $remaining.Count | Should -Be 0 -Because 'a cycle would leave nodes that can never be removed'
    }
}
