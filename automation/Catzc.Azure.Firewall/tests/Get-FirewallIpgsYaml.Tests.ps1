Describe 'Get-FirewallIpgsYaml' -Tag 'L2', 'logic' {
    BeforeAll {
        $script:assets = Join-Path (Get-RepositoryRoot) 'automation/Catzc.Azure.Firewall/tests/assets'
        $script:subNetwork = '00000000-0000-0000-0000-000000000002'
        $script:subHub = '00000000-0000-0000-0000-000000000003'

        # No live ARM: replay the committed golden INPUT fixture matching the requested resource group.
        Mock Assert-AzCliExtension -ModuleName Catzc.Azure.Firewall {}
        Mock Invoke-AzCli -ModuleName Catzc.Azure.Firewall {
            $rg = if ($Arguments -match '--resource-group (\S+)') {
                $Matches[1]
            }
            $file = Join-Path $assets "ipgs-$rg.json"
            if (-not (Test-Path $file)) {
                return [pscustomobject]@{ Output = '[]'; ExitCode = 0 }
            }
            [pscustomobject]@{ Output = (Get-Content $file -Raw); ExitCode = 0 }
        }
    }

    Context 'single target' {
        BeforeAll {
            $script:out = Join-Path $TestDrive 'one.yaml'
            Get-FirewallIpgsYaml -SubscriptionId $subNetwork -ResourceGroupName rg-network -YamlPath $out | Out-Null
            $script:doc = Get-Content $out -Raw | ConvertFrom-Yaml
        }

        It 'declares the source once, keyed by resource group, holding its subscription' {
            $doc.sources.Keys | Should -Be 'rg-network'
            $doc.sources['rg-network'].subscriptionId | Should -Be $subNetwork
        }

        It 'maps each IP group to its source and addresses' {
            $doc.ipgs.Keys | Should -Contain 'ipg-web'
            $doc.ipgs['ipg-web'].source | Should -Be 'rg-network'
            @($doc.ipgs['ipg-web'].addresses).Count | Should -Be 3
        }

        It 'sorts addresses numerically by first IP (fixture stores them reversed)' {
            # Golden input has ipg-web reversed; output must be 10.1 < 10.2 < 10.10.
            $doc.ipgs['ipg-web'].addresses | Should -Be @('10.1.0.0/24', '10.2.0.0/24', '10.10.0.0/24')
        }

        It 'asserts the ip-group extension once, up front' {
            # The single call happened in this Context's BeforeAll, so count at Context scope.
            Should -Invoke Assert-AzCliExtension -ModuleName Catzc.Azure.Firewall -Scope Context -Times 1 -Exactly
        }

        It 'targets the subscription explicitly (never switches the active context)' {
            Should -Invoke Invoke-AzCli -ModuleName Catzc.Azure.Firewall -Scope Context -ParameterFilter {
                $Arguments -match "--subscription $subNetwork"
            }
        }
    }

    Context 'multi-target pipeline aggregation (golden compare to ipgs.yml)' {
        It 'reproduces the golden ipgs.yml exactly: 2 sources, 28 groups' {
            $out = Join-Path $TestDrive 'all.yaml'
            @(
                [pscustomobject]@{ SubscriptionId = $subNetwork; ResourceGroupName = 'rg-network' }
                [pscustomobject]@{ SubscriptionId = $subHub; ResourceGroupName = 'rg-hub' }
            ) | Get-FirewallIpgsYaml -YamlPath $out | Out-Null

            $expected = Get-Content (Join-Path $assets 'ipgs.yml') -Raw | ConvertFrom-Yaml
            $actual = Get-Content $out -Raw | ConvertFrom-Yaml

            ($actual | ConvertTo-Json -Depth 10) | Should -BeExactly ($expected | ConvertTo-Json -Depth 10)
            $actual.sources.Count | Should -Be 2
            $actual.ipgs.Count | Should -Be 28
        }
    }

    Context 'collisions and empties' {
        It 'throws on a source-name (resource group) collision across subscriptions' {
            { @(
                    [pscustomobject]@{ SubscriptionId = $subNetwork; ResourceGroupName = 'rg-network' }
                    [pscustomobject]@{ SubscriptionId = $subHub; ResourceGroupName = 'rg-network' }
                ) | Get-FirewallIpgsYaml -YamlPath (Join-Path $TestDrive 'c1.yaml') } |
                Should -Throw '*Source name collision*'
        }

        It 'throws on an IP-group-name collision across sources' {
            # Two distinct RGs whose fixtures share a group name. Build a one-off colliding pair in TestDrive.
            $collideA = Join-Path $assets 'ipgs-rg-network.json'   # contains ipg-web
            Mock Invoke-AzCli -ModuleName Catzc.Azure.Firewall {
                # Both RGs return a group named ipg-web -> cross-source name collision.
                [pscustomobject]@{ Output = (Get-Content $collideA -Raw); ExitCode = 0 }
            }
            { @(
                    [pscustomobject]@{ SubscriptionId = $subNetwork; ResourceGroupName = 'rg-a' }
                    [pscustomobject]@{ SubscriptionId = $subHub; ResourceGroupName = 'rg-b' }
                ) | Get-FirewallIpgsYaml -YamlPath (Join-Path $TestDrive 'c2.yaml') } |
                Should -Throw '*IP Group name collision*'
        }

        It 'throws when a resource group has no IP groups' {
            Mock Invoke-AzCli -ModuleName Catzc.Azure.Firewall { [pscustomobject]@{ Output = '[]'; ExitCode = 0 } }
            { Get-FirewallIpgsYaml -SubscriptionId $subNetwork -ResourceGroupName rg-empty -YamlPath (Join-Path $TestDrive 'e.yaml') } |
                Should -Throw '*No IP Groups found*'
        }

        It 'throws when no targets are supplied on the pipeline' {
            { @() | Get-FirewallIpgsYaml -YamlPath (Join-Path $TestDrive 'n.yaml') } |
                Should -Throw '*No IP Groups collected*'
        }
    }
}
