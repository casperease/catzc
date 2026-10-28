BeforeAll {
    # The deploys of one pipeline YAML, and those whose step just before is not the same command with -DryRun.
    $script:findDeploysWithoutDryRun = {
        param([string] $Path)
        $command = {
            param($Step)
            if ($Step -is [System.Collections.IDictionary] -and $Step['parameters'] -is [System.Collections.IDictionary]) {
                "$($Step['parameters']['RunCommand'])" -replace '\s+', ' '
            }
        }
        $result = [pscustomobject]@{ Deploys = 0; Missing = [System.Collections.Generic.List[string]]::new() }
        $walk = {
            param($Node)
            if ($Node -is [System.Collections.IDictionary]) {
                foreach ($value in $Node.Values) {
                    & $walk $value
                }
            }
            elseif ($Node -is [System.Collections.IList]) {
                for ($i = 0; $i -lt $Node.Count; $i++) {
                    $run = & $command $Node[$i]
                    if ($run -like 'Deploy-Bicep *' -and $run -notlike '* -DryRun') {
                        $result.Deploys++
                        $before = if ($i -gt 0) {
                            & $command $Node[$i - 1]
                        }
                        if ($before -ne "$run -DryRun") {
                            $result.Missing.Add($run)
                        }
                    }
                    & $walk $Node[$i]
                }
            }
        }
        & $walk (ConvertFrom-Yaml -Yaml ([System.IO.File]::ReadAllText($Path)) -Ordered)
        [pscustomobject]@{ Deploys = $result.Deploys; Missing = [string[]] $result.Missing }
    }

    # The deploy targets of one pipeline YAML (every mapping that pins a subscription) whose subscription is in the production list.
    $script:findProductionTargets = {
        param([string] $Path, [string[]] $ProductionSubscriptionIds)
        $targets = [System.Collections.Generic.List[pscustomobject]]::new()
        $walk = {
            param($Node)
            if ($Node -is [System.Collections.IDictionary]) {
                if ($Node.Contains('subscriptionIdAssertIs')) {
                    $targets.Add([pscustomobject]@{ Subscription = "$($Node['subscriptionIdAssertIs'])"; Env = "$($Node['env'])" })
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
        & $walk (ConvertFrom-Yaml -Yaml ([System.IO.File]::ReadAllText($Path)) -Ordered)
        [string[]] @($targets | Where-Object { $_.Subscription -in $ProductionSubscriptionIds } | ForEach-Object { $_.Env })
    }

    $script:networkPoolInclude = '/.ado/pipelines/variables/network-agent-pool.yaml'
    $script:findVaultJobsOffPool = {
        param([string] $Path, [string[]] $VaultCommands)
        # Read here, since the analyzer does not follow a parameter into a nested script block.
        $vaultWriters = $VaultCommands
        $text = [System.IO.File]::ReadAllText($Path)
        $offenders = [System.Collections.Generic.List[string]]::new()
        $runs = {
            param($Node)
            if ($Node -is [System.Collections.IDictionary]) {
                if ($Node['RunCommand']) {
                    "$($Node['RunCommand'])"
                }
                foreach ($value in $Node.Values) {
                    & $runs $value
                }
            }
            elseif ($Node -is [System.Collections.IList]) {
                foreach ($item in $Node) {
                    & $runs $item
                }
            }
        }
        $walk = {
            param($Node)
            if ($Node -is [System.Collections.IDictionary]) {
                if ($Node.Contains('pool') -or $Node.Contains('job') -or $Node.Contains('deployment')) {
                    $commands = @(& $runs $Node | ForEach-Object { ($_ -split '\s+', 2)[0] } | Where-Object { $_ -in $vaultWriters })
                    $pool = $Node['pool']
                    $onPool = $pool -is [System.Collections.IDictionary] -and -not $pool.Contains('vmImage') -and
                    "$($pool['name'])" -eq '${{ variables.NetworkAgentPool }}' -and $text.Contains($script:networkPoolInclude)
                    if ($commands.Count -gt 0 -and -not $onPool) {
                        $offenders.Add("$($Node['displayName'])")
                    }
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
        & $walk (ConvertFrom-Yaml -Yaml $text -Ordered)
        [string[]] $offenders
    }
    $script:vaultCommands = @('Set-AnomalyAlertRecipientSecret', 'Invoke-BreakGlassRotation')

    $script:findServiceConnectionUses = {
        param([string] $Path, [string[]] $VaultCommands)
        # Read here, since the analyzer does not follow a parameter into a nested script block.
        $vaultWriters = $VaultCommands
        $uses = [System.Collections.Generic.List[pscustomobject]]::new()
        $entryNeeds = @{ Foundations = 'landing-zone'; Discoveries = 'landing-zone'; Expeditions = 'workload' }
        $walk = {
            param($Node, [string] $Key)
            if ($Node -is [System.Collections.IDictionary]) {
                foreach ($name in @($Node.Keys)) {
                    $value = "$($Node[$name])"
                    if ("$name" -ceq 'serviceConnection' -and $entryNeeds.ContainsKey($Key)) {
                        $uses.Add([pscustomobject]@{ Connection = $value; Needs = $entryNeeds[$Key]; Subscription = "$($Node['subscriptionIdAssertIs'])"; Use = "a $Key entry ($($Node['env']))" })
                    }
                    elseif ("$name" -ceq 'ServiceConnection' -and $value -notlike '*${{*') {
                        $command = ("$($Node['RunCommand'])".Trim() -split '\s+', 2)[0]
                        $needs = if ($command -in $vaultWriters) {
                            'landing-zone'
                        }
                        else {
                            'read-only'
                        }
                        $uses.Add([pscustomobject]@{ Connection = $value; Needs = $needs; Subscription = ''; Use = "a step running $command" })
                    }
                }
                foreach ($name in @($Node.Keys)) {
                    & $walk $Node[$name] "$name"
                }
            }
            elseif ($Node -is [System.Collections.IList]) {
                foreach ($item in $Node) {
                    & $walk $item $Key
                }
            }
        }
        & $walk (ConvertFrom-Yaml -Yaml ([System.IO.File]::ReadAllText($Path)) -Ordered) ''
        $uses
    }

    # The ids of the subscriptions that host a production environment, or stage for one, as azure.yml declares them.
    $script:productionSubscriptionIds = {
        $azure = Get-Config -Config azure
        $production = @($azure.environments.Keys | Where-Object { $azure.environments[$_].production })
        [string[]] @($azure.subscriptions.Values | Where-Object { @($_.environments | Where-Object { $_ -in $production }).Count -gt 0 } |
                ForEach-Object id)
    }
}

Describe 'Test-Pipelines' -Tag 'L0', 'logic' {
    BeforeAll {
        # Build a classifier record like Get-AdoYamlFiles emits (string props stand in for the C# record).
        function New-PipelineRecord {
            param($Rel, $Classification = 'Template', $TemplateType = $null, $ParseError = $null)
            [pscustomobject]@{
                RelativePath      = $Rel
                RelativeDirectory = (Split-Path $Rel -Parent)
                Path              = "X:/pipelines/$Rel"
                Classification    = $Classification
                TemplateType      = $TemplateType
                ParseError        = $ParseError
            }
        }

        # The gate's issues for the current fixture, through -PassThru (the report goes to $TestDrive).
        function Get-Issues {
            @((Test-Pipelines -Path 'X:/pipelines' -PassThru -OutputFolder (Join-Path $TestDrive 'pipelines')).Issues)
        }
    }

    BeforeEach {
        $script:records = @()
        $script:refs = @()

        # Isolated through the classifier and reference-scan seams, so records and refs are the only inputs.
        Mock Get-AdoYamlFiles -ModuleName Catzc.Azure.DevOps { $script:records }
        Mock Get-PipelineTemplateReference -ModuleName Catzc.Azure.DevOps { $script:refs }
        Mock Assert-PathExist -ModuleName Catzc.Azure.DevOps { }
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
    }

    It 'passes a compliant tree with no violations' {
        $script:records = @(
            (New-PipelineRecord 'ci-automation.yaml' 'Pipeline')
            (New-PipelineRecord 'cd-shared.yaml' 'Pipeline')
            (New-PipelineRecord 'steps/invoke-automation.yaml' -Classification 'Template' -TemplateType 'Steps')
            (New-PipelineRecord 'extends/cd-customer.yaml' -Classification 'Template' -TemplateType 'Stages')
        )
        { Test-Pipelines -Path 'X:/pipelines' -OutputFolder (Join-Path $TestDrive 'pipelines') } | Should -Not -Throw
    }

    It 'throws once listing every violation' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        $script:records = @((New-PipelineRecord 'widget-thing.yaml' 'Pipeline'),
            (New-PipelineRecord 'ci-gadget.yml' 'Pipeline'))
        $thrown = { Test-Pipelines -Path 'X:/pipelines' -OutputFolder (Join-Path $TestDrive 'pipelines') } |
            Should -Throw -PassThru
        $thrown.Exception.Message | Should -BeLike 'Test-Pipelines failed: 2 issue(s)*'
        $thrown.Exception.Message | Should -Match 'FDR-PIPELINE-TYPEPREFIX'
        $thrown.Exception.Message | Should -Match 'FDR-PIPELINE-EXECUTABLEYAMLEXTENSION'
    }

    It 'returns the result with the file count under -PassThru' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        $script:records = @((New-PipelineRecord 'widget-thing.yaml' 'Pipeline'),
            (New-PipelineRecord 'ci-gadget.yaml' 'Pipeline'))
        $result = Test-Pipelines -Path 'X:/pipelines' -PassThru -OutputFolder (Join-Path $TestDrive 'pipelines')
        $result.Subject | Should -Be 'pipelines'
        $result.IssueCount | Should -Be 1
        $result.Facts['Files'] | Should -Be 2
        $result.Issues[0] | Should -BeLike '`[FDR-PIPELINE-TYPEPREFIX`] .ado/pipelines/widget-thing.yaml: *'
    }

    It 'flags a root pipeline whose name lacks a valid type prefix (FDR-PIPELINE-TYPEPREFIX)' {
        $script:records = @((New-PipelineRecord 'widget-thing.yaml' 'Pipeline'))
        $v = @(Get-Issues)
        $v | Should -HaveCount 1
        $v[0] | Should -Match 'FDR-PIPELINE-TYPEPREFIX'
    }

    It 'accepts every sanctioned type prefix' {
        $script:records = @('cron', 'ci', 'cd', 'cde', 'deploy',
            'input' | ForEach-Object { New-PipelineRecord "$_-x.yaml" 'Pipeline' })
        Get-Issues | Should -HaveCount 0
    }

    It 'flags a .yml executable under .ado/pipelines/ (FDR-PIPELINE-EXECUTABLEYAMLEXTENSION)' {
        $script:records = @((New-PipelineRecord 'ci-thing.yml' 'Pipeline'))
        Get-Issues | Should -Match 'FDR-PIPELINE-EXECUTABLEYAMLEXTENSION'
    }

    It 'flags a template in an unsanctioned folder (ADR-ADO-NAME-TEMPLATEKINDFOLDER)' {
        $script:records = @((New-PipelineRecord 'widgets/x.yaml' -Classification 'Template' -TemplateType 'Steps'))
        Get-Issues | Should -Match 'ADR-ADO-NAME-TEMPLATEKINDFOLDER'
    }

    It 'flags a template nested deeper than one level (ADR-ADO-NAME-FLATPIPELINESFOLDER)' {
        $script:records = @((New-PipelineRecord 'steps/sub/x.yaml' -Classification 'Template' -TemplateType 'Steps'))
        Get-Issues | Should -Match 'ADR-ADO-NAME-FLATPIPELINESFOLDER'
    }

    It 'flags a structural pipeline hiding inside a template folder (ADR-ADO-NAME-FLATPIPELINESFOLDER)' {
        $script:records = @((New-PipelineRecord 'steps/sneaky.yaml' 'Pipeline'))
        Get-Issues | Should -Match 'ADR-ADO-NAME-FLATPIPELINESFOLDER'
    }

    It 'flags a fragment whose kind does not match its folder (ADR-ADO-NAME-TEMPLATEKINDFOLDER)' {
        $script:records = @((New-PipelineRecord 'steps/x.yaml' -Classification 'Template' -TemplateType 'Jobs'))
        Get-Issues | Should -Match 'ADR-ADO-NAME-TEMPLATEKINDFOLDER'
    }

    It 'does not subtype-check the extends/ folder (whole-pipeline templates)' {
        $script:records = @((New-PipelineRecord 'extends/cd-customer.yaml' -Classification 'Template' -TemplateType 'Jobs'))
        Get-Issues | Should -HaveCount 0
    }

    It 'flags a relative template reference (ADR-ADO-TEMPLATE-ABSOLUTEPATHS)' {
        $script:records = @((New-PipelineRecord 'ci-x.yaml' 'Pipeline'))
        $script:refs = @('steps/local.yaml')
        Get-Issues | Should -Match 'ADR-ADO-TEMPLATE-ABSOLUTEPATHS'
    }

    It 'accepts an absolute template reference' {
        $script:records = @((New-PipelineRecord 'ci-x.yaml' 'Pipeline'))
        $script:refs = @('/.ado/pipelines/steps/invoke-automation.yaml')
        Get-Issues | Should -HaveCount 0
    }

    It 'reports a parse failure as its own violation' {
        $script:records = @((New-PipelineRecord 'ci-broken.yaml' -Classification 'Unknown' -ParseError 'bad indent at line 4'))
        Get-Issues |
            Should -BeLike '`[ADR-ADO-NAME`] .ado/pipelines/ci-broken.yaml: YAML failed to parse: bad indent at line 4'
    }
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

    It 'previews every deploy with a what-if: each Deploy-Bicep step follows its own -DryRun sibling' {
        $found = & $script:findDeploysWithoutDryRun (Join-Path (Get-RepositoryRoot) '.ado/pipelines/stages/deploy-unit.yaml')
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

Describe 'the service-connection finder' -Tag 'L0', 'logic' {
    It 'reads each target entry''s identity from its list, and a step''s from what it runs' {
        $path = Join-Path $TestDrive 'widget.yaml'
        [System.IO.File]::WriteAllText($path, @(
                'Foundations:'
                '  - { env: widget, serviceConnection: sc-widget-lz, subscriptionIdAssertIs: 00000000-0000-0000-0000-00000000000a }'
                'Expeditions:'
                '  - { env: gadget, serviceConnection: sc-widget-wl, subscriptionIdAssertIs: 00000000-0000-0000-0000-00000000000a }'
                'steps:'
                '  - template: /.ado/pipelines/steps/invoke-automation.yaml'
                '    parameters:'
                '      ServiceConnection: sc-widget-vault'
                '      RunCommand: Invoke-BreakGlassRotation widget'
                '  - template: /.ado/pipelines/steps/invoke-automation.yaml'
                '    parameters:'
                '      ServiceConnection: sc-widget-ro'
                '      RunCommand: Get-Widget'
                '  - template: /.ado/pipelines/steps/invoke-automation.yaml'
                '    parameters:'
                '      ServiceConnection: ${{ f.serviceConnection }}'
                '      RunCommand: Get-Gadget'
            ) -join "`n")
        $uses = @(& $script:findServiceConnectionUses $path $script:vaultCommands)
        @($uses | ForEach-Object { "$($_.Connection)=$($_.Needs)" }) |
            Should -Be @('sc-widget-lz=landing-zone', 'sc-widget-wl=workload', 'sc-widget-vault=landing-zone', 'sc-widget-ro=read-only')
        $uses[0].Subscription | Should -Be '00000000-0000-0000-0000-00000000000a'
        $uses[3].Subscription | Should -BeNullOrEmpty
    }
}

Describe 'the production-target finder' -Tag 'L0', 'logic' {
    It 'lists the targets pinned to a production subscription and ignores the rest' {
        $path = Join-Path $TestDrive 'widget.yaml'
        [System.IO.File]::WriteAllText($path, @(
                'Foundations:'
                '  - { env: widget, subscriptionIdAssertIs: 00000000-0000-0000-0000-00000000000a }'
                '  - { env: gadget, subscriptionIdAssertIs: 00000000-0000-0000-0000-00000000000b }'
            ) -join "`n")
        & $script:findProductionTargets $path @('00000000-0000-0000-0000-00000000000b') | Should -Be @('gadget')
        & $script:findProductionTargets $path @() | Should -BeNullOrEmpty
    }
}

Describe 'the network-pool guard on vault writes' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:poolYaml = {
            param([string] $Pool, [string] $Command, [switch] $Include)
            $path = Join-Path $TestDrive "$([guid]::NewGuid().ToString('N')).yaml"
            $variables = if ($Include) {
                "variables:`n  - template: $script:networkPoolInclude`n"
            }
            [System.IO.File]::WriteAllText($path, "$variables" + (@(
                        'jobs:'
                        '  - job: widget'
                        '    displayName: widget'
                        "    pool:`n      $Pool"
                        '    steps:'
                        '      - template: /.ado/pipelines/steps/invoke-automation.yaml'
                        "        parameters:`n          RunCommand: $Command gadget"
                    ) -join "`n"))
            $path
        }
    }

    It 'flags a new vault-writing job on a Microsoft-hosted agent' {
        $path = & $script:poolYaml -Pool 'vmImage: ubuntu-latest' -Command 'Invoke-BreakGlassRotation' -Include
        & $script:findVaultJobsOffPool $path $script:vaultCommands | Should -Be @('widget')
    }

    It 'flags a vault-writing job on the pool variable in a file without the variable template' {
        $path = & $script:poolYaml -Pool 'name: ${{ variables.NetworkAgentPool }}' -Command 'Set-AnomalyAlertRecipientSecret'
        & $script:findVaultJobsOffPool $path $script:vaultCommands | Should -Be @('widget')
    }

    It 'passes a vault-writing job on the declared pool, and any job that writes no vault' {
        $vault = & $script:poolYaml -Pool 'name: ${{ variables.NetworkAgentPool }}' -Command 'Set-AnomalyAlertRecipientSecret' -Include
        & $script:findVaultJobsOffPool $vault $script:vaultCommands | Should -BeNullOrEmpty
        $other = & $script:poolYaml -Pool 'vmImage: ubuntu-latest' -Command 'Deploy-Bicep'
        & $script:findVaultJobsOffPool $other $script:vaultCommands | Should -BeNullOrEmpty
    }
}

Describe 'the what-if guard on pipeline deploys' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:widgetYaml = {
            param([string[]] $Steps)
            $path = Join-Path $TestDrive "$([guid]::NewGuid().ToString('N')).yaml"
            [System.IO.File]::WriteAllText($path, (@('steps:') + @($Steps | ForEach-Object {
                            "  - template: /.ado/pipelines/steps/invoke-automation.yaml`n    parameters:`n      RunCommand: '$_'"
                        })) -join "`n")
            $path
        }
    }

    It 'flags a Deploy-Bicep step with no -DryRun sibling before it' {
        $found = & $script:findDeploysWithoutDryRun (& $script:widgetYaml @('Deploy-Bicep -Environment widget -Template gadget'))
        $found.Deploys | Should -Be 1
        $found.Missing | Should -Be @('Deploy-Bicep -Environment widget -Template gadget')
    }

    It 'flags a sibling that previews another command, and passes the matching one' {
        $other = & $script:findDeploysWithoutDryRun (& $script:widgetYaml @('Deploy-Bicep -Template sprocket -DryRun', 'Deploy-Bicep -Template gadget'))
        $other.Missing | Should -Be @('Deploy-Bicep -Template gadget')
        $match = & $script:findDeploysWithoutDryRun (& $script:widgetYaml @('Deploy-Bicep -Template gadget -DryRun', 'Deploy-Bicep -Template gadget'))
        $match.Missing | Should -BeNullOrEmpty
    }
}
