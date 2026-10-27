function Test-BicepTemplateCompliance {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [string[]] $Template = @(Get-BicepTemplateNames),

        [Catzc.Azure.Templates.TemplateComplianceConfig] $Config = (Get-Config -Config template-compliance),

        # The one tag schema, azure.yml's tags section.
        [Catzc.Azure.AzureTagSchema] $TagSchema = (Get-Config -Config azure).tags,

        [string] $OutputFolder,

        [switch] $PassThru
    )

    $issues = [System.Collections.Generic.List[string]]::new()
    $unresolved = { param($Value) [Catzc.Azure.Templates.ArmExpression]::IsUnresolved($Value) }
    $slots = 0
    $checked = 0

    # The gate builds into its own run folder, so a concurrent build of the same template never swaps the files it reads.
    $runFolder = Join-Path (Get-BicepTemplatesOutputRoot) "template-run/compliance-$([guid]::NewGuid().ToString('N').Substring(0, 8))"
    try {
        foreach ($name in $Template) {
            $outputFolder = @(Build-Bicep $name -OutputFolder (Join-Path $runFolder $name))[-1]
            $main = [System.IO.File]::ReadAllText((Join-Path $outputFolder 'main.json')) | ConvertFrom-Json -AsHashtable
            foreach ($slot in @((Get-BicepTemplate $name).slots)) {
                $slots++
                $parametersFile = Join-Path $outputFolder (Get-BicepParametersFileName -Environment $slot.environment -Slot $slot.slot -Customer $slot.customer)
                $parameters = [System.IO.File]::ReadAllText($parametersFile) | ConvertFrom-Json -AsHashtable
                $values = @{}
                foreach ($parameter in @($parameters.parameters.Keys)) {
                    $entry = $parameters.parameters[$parameter]
                    $values[$parameter] = if ($entry.Contains('value')) {
                        $entry.value
                    }
                    else {
                        [Catzc.Azure.Templates.ArmExpression]::Unresolved
                    }
                }
                $where = "$name/$($slot.name)"
                # Production is the environment's fact in azure.yml, the one place it is declared.
                $environments = (Get-Config -Config azure).environments
                $production = $environments.ContainsKey($slot.environment) -and $environments[$slot.environment].production
                $deployed = @(Get-ArmDeployedResource -Template $main -Values $values)
                $diagnosed = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
                $needing = [System.Collections.Generic.Dictionary[string, string]]::new([System.StringComparer]::OrdinalIgnoreCase)

                foreach ($item in $deployed) {
                    $checked++
                    $resource = $item.Resource
                    $at = "${where}: $($item.Path) ($($item.Type))"
                    $properties = if ($resource.Contains('properties') -and $resource.properties -is [System.Collections.IDictionary]) {
                        $resource.properties
                    }
                    else {
                        @{}
                    }

                    if ($item.Type -eq 'Microsoft.Insights/diagnosticSettings') {
                        if ($item.Conditional) {
                            $issues.Add("${at}: its condition does not resolve, so whether it deploys is unknown")
                        }
                        # A setting with no scope covers its deployment scope (a subscription's activity log), not a resource kind.
                        if (-not $resource.Contains('scope')) {
                            continue
                        }
                        $target = [regex]::Match("$($resource.scope)", "resourceId\('(?<type>[^']+)'")
                        if ($target.Success) {
                            [void]$diagnosed.Add($target.Groups['type'].Value)
                        }
                        else {
                            $issues.Add("${at}: its scope does not name the resource type it covers")
                        }
                        continue
                    }
                    if ($Config.NeedsDiagnostics($item.Type) -and -not $needing.ContainsKey($item.Type)) {
                        $needing[$item.Type] = $at
                    }

                    if ($Config.IsTaggable($item.Type)) {
                        if (-not $resource.Contains('tags')) {
                            $issues.Add("${at}: carries no tags")
                        }
                        else {
                            $tags = [Catzc.Azure.Templates.ArmExpression]::Evaluate($resource.tags, $item.Scope, $item.Variables, $item.Indexes)
                            if (& $unresolved $tags) {
                                $issues.Add("${at}: its tags do not resolve")
                            }
                            elseif ($tags -isnot [System.Collections.IDictionary]) {
                                $issues.Add("${at}: its tags are not a mapping")
                            }
                            else {
                                foreach ($tagError in $TagSchema.TagErrors($tags)) {
                                    $issues.Add("${at}: $tagError")
                                }
                            }
                        }
                    }

                    # The declared property rules: a property copy loop's input stands for every instance it renders.
                    foreach ($rule in $Config.property_rules) {
                        if ($item.Type -ne $rule.type) {
                            continue
                        }
                        $found = Get-ArmPropertyValue -Resource $resource -Path $rule.path
                        if (-not $rule.absent -and $found.Count -eq 0) {
                            $issues.Add("${at}: $($rule.path) is not set ($($rule.reason))")
                        }
                        foreach ($raw in $found) {
                            $value = [Catzc.Azure.Templates.ArmExpression]::Evaluate($raw, $item.Scope, $item.Variables, $item.Indexes)
                            if (& $unresolved $value) {
                                $issues.Add("${at}: $($rule.path) does not resolve")
                            }
                            elseif ($rule.absent -and $null -ne $value) {
                                $issues.Add("${at}: $($rule.path) is set ($($rule.reason))")
                            }
                            elseif (-not $rule.absent -and $value -ne $rule.equals) {
                                $issues.Add("${at}: $($rule.path) is '$value', not '$($rule.equals)' ($($rule.reason))")
                            }
                        }
                    }

                    foreach ($property in $Config.public_access_properties) {
                        if ($properties.Contains($property)) {
                            $value = [Catzc.Azure.Templates.ArmExpression]::Evaluate($properties[$property], $item.Scope, $item.Variables, $item.Indexes)
                            if (& $unresolved $value) {
                                $issues.Add("${at}: $property does not resolve")
                            }
                            elseif ("$value" -eq 'Enabled') {
                                $issues.Add("${at}: $property is Enabled")
                            }
                        }
                    }

                    foreach ($property in $Config.tls_properties.Keys) {
                        if ($properties.Contains($property)) {
                            $value = [Catzc.Azure.Templates.ArmExpression]::Evaluate($properties[$property], $item.Scope, $item.Variables, $item.Indexes)
                            if (& $unresolved $value) {
                                $issues.Add("${at}: $property does not resolve")
                            }
                            elseif ("$value" -notin $Config.tls_properties[$property]) {
                                $issues.Add("${at}: $property is '$value', below TLS 1.2")
                            }
                        }
                    }

                    if ($production) {
                        foreach ($property in $Config.zone_properties) {
                            if ($properties.Contains($property)) {
                                $value = [Catzc.Azure.Templates.ArmExpression]::Evaluate($properties[$property], $item.Scope, $item.Variables, $item.Indexes)
                                if (& $unresolved $value) {
                                    $issues.Add("${at}: $property does not resolve on a production slot")
                                }
                                elseif ($value -ne $true) {
                                    $issues.Add("${at}: $property is off on a production slot")
                                }
                            }
                        }
                    }
                }

                foreach ($type in @($needing.Keys)) {
                    if (-not $diagnosed.Contains($type)) {
                        $issues.Add("$($needing[$type]): no diagnostic setting is scoped to this resource kind")
                    }
                }
            }
        }
    }
    finally {
        if (Test-Path -LiteralPath $runFolder) {
            Remove-Item -LiteralPath $runFolder -Recurse -Force
        }
    }

    Write-QualityGateReport -Subject 'bicep-template-compliance' -Title 'Test-BicepTemplateCompliance' -Issues $issues `
        -Facts ([ordered]@{ Templates = @($Template).Count; Slots = $slots; Resources = $checked }) `
        -OutputFolder $OutputFolder -PassThru:$PassThru
}
