function Test-BicepResourceNames {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [ArgumentCompleter({ Get-BicepTemplateNames })]
        [string[]] $Template = @(Get-BicepTemplateNames),

        [string] $OutputFolder,

        [switch] $PassThru
    )

    $issues = [System.Collections.Generic.List[string]]::new()
    $exceptions = [System.Collections.Generic.List[string]]::new()
    $slots = 0
    $checked = 0
    $foreign = 0
    $candidateSet = Get-BicepNameCandidateSet
    $notNames = [string[]] @((Get-Config -Config resource-types).not_names)
    $types = Get-AzureResourceTypeSet
    $network = Get-Config -Config network
    $byShortName = @{}
    foreach ($known in @(Get-BicepTemplateNames)) {
        $descriptor = Get-BicepTemplate $known
        $byShortName[$descriptor.short_name] = $descriptor
    }
    $armId = '^/subscriptions/[^/]+/(?i:resourceGroups)/([^/]+)(?:/(?i:providers)/[^/]+/(.+))?$'

    foreach ($name in $Template) {
        $descriptor = Get-BicepTemplate $name
        foreach ($slot in @($descriptor.slots)) {
            $slots++
            $where = "${name}/$($slot.name)"
            # A .bicepparam slot declares its group in a sibling yml that holds only ResourceGroup.
            $file = if ($slot.format -eq [Catzc.Azure.Templates.BicepSlot]::YmlFormat) {
                $slot.file
            }
            else {
                [System.IO.Path]::ChangeExtension($slot.file, '.yml')
            }
            if (-not [System.IO.File]::Exists($file)) {
                continue
            }
            $document = [System.IO.File]::ReadAllText($file) | ConvertFrom-Yaml -Ordered
            if ($document -isnot [System.Collections.IDictionary]) {
                continue
            }
            $parameters = [ordered]@{}
            if ($document.Contains('ParametersFile') -and $document.ParametersFile -is [System.Collections.IDictionary] -and
                $document.ParametersFile.Contains('parameters') -and $document.ParametersFile.parameters -is [System.Collections.IDictionary]) {
                $parameters = $document.ParametersFile.parameters
            }

            $names = [System.Collections.Generic.List[object]]::new()
            if ($document.Contains('ResourceGroup')) {
                $names.Add([pscustomobject]@{ location = 'ResourceGroup'; value = "$($document.ResourceGroup)" })
            }
            $excepted = [System.Collections.Generic.List[string]]::new()
            foreach ($parameter in @($parameters.Keys)) {
                $entry = $parameters[$parameter]
                if ($entry -isnot [System.Collections.IDictionary]) {
                    continue
                }
                if ($entry.Contains('naming_exception')) {
                    $exceptions.Add("${where}: $parameter — $($entry.naming_exception)")
                    $excepted.Add("ParametersFile.parameters.$parameter")
                    continue
                }
                if ($entry.Contains('value')) {
                    foreach ($leaf in @(Get-BicepSlotNameLeaf -Value ([ordered]@{ "$parameter" = $entry.value }) -Location '' -NotNames $notNames)) {
                        if ($leaf.named -and $leaf.value -notmatch $armId) {
                            $names.Add($leaf)
                        }
                    }
                }
            }
            # The group and resource names inside an Azure resource ID, anywhere in the slot.
            foreach ($leaf in @(Get-BicepSlotNameLeaf -Value $document -Location '')) {
                $inExcepted = @($excepted | Where-Object { $leaf.location.StartsWith("$_.", [System.StringComparison]::Ordinal) }).Count -gt 0
                if ($inExcepted -or $leaf.value -notmatch $armId) {
                    continue
                }
                $names.Add([pscustomobject]@{ location = "$($leaf.location) (resource group)"; value = $Matches[1] })
                if ($Matches[2]) {
                    $segments = $Matches[2] -split '/'
                    for ($index = 1; $index -lt $segments.Count; $index += 2) {
                        $names.Add([pscustomobject]@{ location = "$($leaf.location) ($($segments[$index - 1]))"; value = $segments[$index] })
                    }
                }
            }

            $own = @{ env = "$($slot.environment)"; customer = "$($slot.customer)"; slot = "$($slot.slot)" }
            foreach ($item in $names) {
                $checked++
                try {
                    $components = ConvertFrom-AzureResourceName -Name $item.value -CandidateSet $candidateSet
                }
                catch {
                    $exception = $_.Exception
                    while ($exception.InnerException) {
                        $exception = $exception.InnerException
                    }
                    $diagnosis = (@($exception.Message -split "`r?`n" | ForEach-Object Trim) | Where-Object { $_ }) -join '; '
                    $issues.Add("${where}: $($item.location): $diagnosis")
                    continue
                }
                # A component the type omits is empty in its name, so it neither matches nor contradicts the file.
                $typeEntry = $types[$components.type]
                $omit = @(
                    if ($typeEntry -is [System.Collections.IDictionary] -and $typeEntry.Contains('omit')) {
                        $typeEntry['omit']
                    }
                )
                $parts = @('env', 'customer', 'slot' | Where-Object { $_ -notin $omit })
                $isOwn = $components.short_name -ceq $descriptor.short_name
                $differs = @($parts | Where-Object { "$($components[$_])" -cne $own[$_] })
                if ($isOwn -and $differs.Count -eq 0) {
                    continue
                }
                # A name off the file's coordinates, its own template's (such as the hub slot) or another's, needs its owner's slot.
                $owner = $byShortName[$components.short_name]
                $ownerSlot = if ($owner) {
                    @($owner.slots | Where-Object {
                            $candidate = @{ env = "$($_.environment)"; customer = "$($_.customer)"; slot = "$($_.slot)" }
                            @($parts | Where-Object { "$($components[$_])" -cne $candidate[$_] }).Count -eq 0
                        }) | Select-Object -First 1
                }
                if ($ownerSlot) {
                    $foreign++
                    continue
                }
                $at = ($parts | ForEach-Object { "$_ '$($components[$_])'" }) -join ', '
                if ($isOwn) {
                    $wrong = ($differs | ForEach-Object { "$_ '$($components[$_])' where the file has '$($own[$_])'" }) -join ', '
                    $issues.Add("${where}: $($item.location): '$($item.value)' has $wrong, and template '$name' has no slot at $at")
                }
                elseif ($owner) {
                    $ownerName = "template '$($owner.name)' (short_name '$($components.short_name)')"
                    $issues.Add("${where}: $($item.location): '$($item.value)' belongs to $ownerName, which has no slot at $at")
                }
                else {
                    $issues.Add("${where}: $($item.location): '$($item.value)' carries short_name '$($components.short_name)', which no template has")
                }
            }

            # Every subnet of the slot's subscription that takes an NSG has a name under networkSecurityGroupNames, and only those.
            if ($parameters.Contains('networkSecurityGroupNames') -and $parameters.networkSecurityGroupNames -is [System.Collections.IDictionary] -and
                $parameters.networkSecurityGroupNames.Contains('value') -and -not $parameters.networkSecurityGroupNames.Contains('naming_exception')) {
                $declared = @(if ($parameters.networkSecurityGroupNames.value -is [System.Collections.IDictionary]) {
                        $parameters.networkSecurityGroupNames.value.Keys | ForEach-Object { "$_" }
                    })
                $subscription = $network.subscriptions[$slot.subscription]
                if ($null -eq $subscription) {
                    $issues.Add("${where}: networkSecurityGroupNames: subscription '$($slot.subscription)' has no entry in network.yml")
                }
                else {
                    $expected = @($subscription.subnets.Keys | ForEach-Object { "$_" } | Where-Object { $_ -notin $network.no_nsg_subnets })
                    foreach ($subnet in @($expected | Where-Object { $_ -cnotin $declared })) {
                        $issues.Add("${where}: networkSecurityGroupNames lacks subnet '$subnet' of subscription '$($slot.subscription)'")
                    }
                    foreach ($key in @($declared | Where-Object { $_ -cnotin $expected })) {
                        $issues.Add("${where}: networkSecurityGroupNames has '$key', not a subnet of subscription '$($slot.subscription)' that takes an NSG")
                    }
                }
            }
        }
    }

    foreach ($exception in $exceptions) {
        Write-Message "naming exception: $exception"
    }
    Write-QualityGateReport -Subject 'bicep-resource-names' -Title 'Test-BicepResourceNames' -Issues $issues `
        -Facts ([ordered]@{ Templates = @($Template).Count; Slots = $slots; Names = $checked; Exceptions = $exceptions.Count; Foreign = $foreign }) `
        -OutputFolder $OutputFolder -PassThru:$PassThru
}
