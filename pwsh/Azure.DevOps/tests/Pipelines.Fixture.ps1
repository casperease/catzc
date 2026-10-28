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
