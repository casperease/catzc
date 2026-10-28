BeforeAll {
    . (Join-Path $PSScriptRoot 'Pipelines.Fixture.ps1')
}

Describe 'Test-Pipelines — real .ado/pipelines/ tree' -Tag 'L1', 'integrity' {
    It 'the shipped .ado/pipelines/ tree satisfies ADR-ADO-NAME (zero violations)' {
        (Test-Pipelines -PassThru -OutputFolder (Join-Path $TestDrive 'pipelines')).IssueCount | Should -Be 0
    }

    It 'builds a customer''s ephemeral slots from its own Expeditions list: the expedition build passes -RuntimeSlotsJson from it' {
        $yaml = ConvertFrom-Yaml -Yaml ([System.IO.File]::ReadAllText((Join-Path (Get-RepositoryRoot) '.ado/pipelines/extends/cd-customer.yaml'))) -Ordered
        $runs = [System.Collections.Generic.List[string]]::new()
        $walk = {
            param($Node)
            if ($Node -is [System.Collections.IDictionary]) {
                if ($Node['parameters'] -is [System.Collections.IDictionary] -and $Node['parameters']['RunCommand']) {
                    $runs.Add("$($Node['parameters']['RunCommand'])")
                }
                foreach ($value in $Node.Values) {
                    & $walk $value
                }
            }
            elseif ($Node -is [System.Collections.IList]) {
                foreach ($item in $Node) {
                    & $walk $item
                }
            }
        }
        & $walk $yaml
        $build = @($runs | Where-Object { $_ -like 'Build-Bicep expedition *' })
        $build.Count | Should -Be 1
        $build[0] | Should -BeLike "*-RuntimeSlotsJson '`${{ convertToJson(parameters.Expeditions) }}'*"
    }

    It 'previews every deploy with a what-if: each Deploy-Bicep step of <_> follows its own -DryRun sibling' -ForEach 'deploy-unit.yaml', 'deploy-expedition.yaml' {
        $found = & $script:findDeploysWithoutDryRun (Join-Path (Get-RepositoryRoot) ".ado/pipelines/stages/$_")
        $found.Deploys | Should -BeGreaterThan 0
        $found.Missing | Should -BeNullOrEmpty -Because 'a pipeline deploy previews its effect with Deploy-Bicep -DryRun first'
    }

    It 'deploys production only from a DEPLOY pipeline: no other pipeline targets a production subscription (FDR-CD-CDSTAYSINNONPROD)' {
        $ids = & $script:productionSubscriptionIds
        $ids | Should -Not -BeNullOrEmpty
        $root = Join-Path (Get-RepositoryRoot) '.ado/pipelines'
        $offenders = foreach ($file in Get-ChildPath $root -File -Filter '*.yaml' -Depth 4) {
            $targets = @(& $script:findProductionTargets $file $ids)
            $name = [System.IO.Path]::GetFileName($file)
            if ($targets.Count -gt 0 -and $name -notlike 'deploy-*.yaml') {
                "${name}: $($targets -join ', ')"
            }
        }
        @($offenders) | Should -BeNullOrEmpty -Because 'progression toward prod leaves CD and enters DEPLOY (FDR-CD-PRODPROGRESSIONISDEPLOY)'
        $deploys = @(Get-ChildPath $root -File -Filter 'deploy-*.yaml' -Depth 1 | Where-Object {
                @(& $script:findProductionTargets $_ $ids).Count -gt 0
            })
        $deploys | Should -Not -BeNullOrEmpty -Because 'some DEPLOY pipeline carries the production rung'
    }

    It 'gives every production DEPLOY a rollback target that runs the prod path, certified by a production environment''s history' {
        $ids = & $script:productionSubscriptionIds
        $root = Join-Path (Get-RepositoryRoot) '.ado/pipelines'
        foreach ($path in Get-ChildPath $root -File -Filter 'deploy-*.yaml' -Depth 1) {
            $file = [System.IO.FileInfo] $path
            if (@(& $script:findProductionTargets $file.FullName $ids).Count -eq 0) {
                continue
            }
            $yaml = ConvertFrom-Yaml -Yaml ([System.IO.File]::ReadAllText($file.FullName)) -Ordered
            $target = $yaml['parameters'] | Where-Object { $_['name'] -eq 'Target' } | Select-Object -First 1
            $target['values'] | Should -Contain 'rollback' -Because "$($file.Name) carries a production rung"
            $keys = @($yaml['stages'] | ForEach-Object { $_.Keys })
            $keys | Should -Contain "`${{ if in(parameters.Target, 'prod', 'rollback') }}" -Because 'a rollback runs the one prod path'
            $first = $yaml['stages'] | Where-Object { $_.Contains("`${{ if in(parameters.Target, 'prod', 'rollback') }}") } | Select-Object -First 1
            $stage = ($first["`${{ if in(parameters.Target, 'prod', 'rollback') }}"] | Select-Object -First 1)['parameters']
            $certified = $stage["`${{ if eq(parameters.Target, 'rollback') }}"]
            $certified | Should -Not -BeNullOrEmpty -Because "$($file.Name) asserts the earlier commit ran in production before it redeploys it"
            "$($certified['CertifiedBy'])" | Should -Not -BeNullOrEmpty
            @(@($stage['Foundations']) + @($stage['Discoveries']) + @($stage['Expeditions']) | Where-Object { $_ } |
                    ForEach-Object { "$($_['subscriptionIdAssertIs'])" } | Where-Object { $_ -in $ids }) |
                    Should -Not -BeNullOrEmpty -Because 'the first rollback stage deploys into the production subscription'
        }
    }

    It 'runs every foundation-vault write on the network agent pool, declared once, and never on a Microsoft-hosted image' {
        $root = Join-Path (Get-RepositoryRoot) '.ado/pipelines'
        $writers = 0
        $offenders = foreach ($file in Get-ChildPath $root -File -Filter '*.yaml' -Depth 4) {
            $text = [System.IO.File]::ReadAllText($file)
            if (@($script:vaultCommands | Where-Object { $text.Contains($_) }).Count -gt 0) {
                $writers++
            }
            & $script:findVaultJobsOffPool $file $script:vaultCommands | ForEach-Object { "$([System.IO.Path]::GetFileName($file)): $_" }
        }
        $writers | Should -BeGreaterThan 1 -Because 'the anomaly seed and the break-glass rotation both write a foundation vault'
        @($offenders) | Should -BeNullOrEmpty -Because 'the foundation vault has no public network access, so only an agent inside the network reaches it'
        $declared = ConvertFrom-Yaml -Yaml ([System.IO.File]::ReadAllText((Join-Path (Get-RepositoryRoot) $script:networkPoolInclude.TrimStart('/')))) -Ordered
        "$($declared['variables']['NetworkAgentPool'])" | Should -Not -BeNullOrEmpty -Because 'the pool name is declared once, in the variable template'
    }

    It 'prints a pre-deploy cost estimate in CI for every template, after its build and from no network' {
        $yaml = ConvertFrom-Yaml -Yaml ([System.IO.File]::ReadAllText((Join-Path (Get-RepositoryRoot) '.ado/pipelines/ci-infrastructure.yaml'))) -Ordered
        $runs = @($yaml['jobs'][0]['steps'] | Where-Object { $_ -is [System.Collections.IDictionary] -and $_['parameters'] } |
                ForEach-Object { "$($_['parameters']['RunCommand'])" })
        foreach ($template in Get-BicepTemplateNames) {
            $estimates = @($runs | Where-Object { $_ -like "Get-BicepCostEstimate $template*" })
            $estimates | Should -Not -BeNullOrEmpty -Because "CI prices $template"
            foreach ($estimate in $estimates) {
                [array]::IndexOf($runs, $estimate) | Should -BeGreaterThan ([array]::IndexOf($runs, "Build-Bicep $template")) -Because "CI prices $template once it is compiled"
            }
        }
        foreach ($hub in 'shared_nonprod', 'shared_prod') {
            $runs | Should -Contain "Get-BicepCostEstimate discovery -Subscription $hub" -Because "the hub $hub's firewall tier prices only when the estimate knows the subscription"
        }
        @($runs | Where-Object { $_ -like '*Update-AzurePriceTable*' }) | Should -BeNullOrEmpty -Because 'CI reads the checked-in price table'
    }

    It 'names only derived service connections, each of the identity its use needs and on the subscription its entry asserts' {
        $connections = @{}
        foreach ($connection in Get-BicepServiceConnections) {
            $connections[$connection.name] = $connection
        }
        $subscriptions = (Get-Config -Config azure).subscriptions
        $root = Join-Path (Get-RepositoryRoot) '.ado/pipelines'
        $uses = 0
        $offenders = foreach ($file in Get-ChildPath $root -File -Filter '*.yaml' -Depth 4) {
            $name = [System.IO.Path]::GetFileName($file)
            foreach ($use in & $script:findServiceConnectionUses $file $script:vaultCommands) {
                $uses++
                $connection = $connections[$use.Connection]
                if (-not $connection) {
                    "${name}: $($use.Use) names '$($use.Connection)', which Get-BicepServiceConnections does not derive"
                    continue
                }
                if ($connection.identity -ne $use.Needs) {
                    "${name}: $($use.Use) needs the $($use.Needs) identity, and '$($use.Connection)' is $($connection.identity)"
                }
                if ($use.Subscription -and "$($subscriptions[$connection.subscription].id)" -ne $use.Subscription) {
                    "${name}: $($use.Use) asserts $($use.Subscription), and '$($use.Connection)' reaches $($connection.subscription)"
                }
            }
        }
        $uses | Should -BeGreaterThan 0
        @($offenders) | Should -BeNullOrEmpty -Because 'a pipeline authenticates as the least identity that does its job (ADR-AZ-LZ-CAFDELIVERY)'
    }
}
