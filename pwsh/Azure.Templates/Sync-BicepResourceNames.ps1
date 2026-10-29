function Sync-BicepResourceNames {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param(
        [ArgumentCompleter({ Get-BicepTemplateNames })]
        [ValidateScript({ $_ -in (Get-BicepTemplateNames) })]
        [string[]] $Template = @(Get-BicepTemplateNames)
    )

    $candidateSet = Get-BicepNameCandidateSet
    foreach ($name in $Template) {
        $descriptor = Get-BicepTemplate $name
        foreach ($slot in @($descriptor.slots | Where-Object format -EQ ([Catzc.Azure.Templates.BicepSlot]::YmlFormat))) {
            $text = [System.IO.File]::ReadAllText($slot.file)
            $document = $text | ConvertFrom-Yaml -Ordered
            $parameters = [ordered]@{}
            if ($document -is [System.Collections.IDictionary] -and $document.Contains('ParametersFile') -and
                $document.ParametersFile -is [System.Collections.IDictionary] -and $document.ParametersFile.Contains('parameters') -and
                $document.ParametersFile.parameters -is [System.Collections.IDictionary]) {
                $parameters = $document.ParametersFile.parameters
            }

            $writes = [ordered]@{}
            $derived = [ordered]@{}
            if ($descriptor.names.Count -gt 0) {
                $derived = Resolve-BicepDerivedNames -TemplateDescriptor $descriptor -Slot $slot -SlotParameters $parameters
            }
            foreach ($parameter in @($derived.Keys)) {
                $value = $derived[$parameter]
                # An each entry's items keep the slot's own fields beside the names the namer fills in.
                if ($parameters.Contains($parameter) -and $parameters[$parameter] -is [System.Collections.IDictionary] -and $parameters[$parameter].Contains('value')) {
                    $own = $parameters[$parameter].value
                    $ownItems = @(if ($own -is [System.Collections.IDictionary]) {
                            , $own
                        }
                        else {
                            $own
                        })
                    $newItems = @(if ($value -is [System.Collections.IDictionary]) {
                            , $value
                        }
                        else {
                            $value
                        })
                    for ($index = 0; $index -lt $newItems.Count -and $index -lt $ownItems.Count; $index++) {
                        if ($ownItems[$index] -is [System.Collections.IDictionary] -and $newItems[$index] -is [System.Collections.IDictionary]) {
                            $merged = [ordered]@{}
                            foreach ($key in @($ownItems[$index].Keys)) {
                                $merged[$key] = $ownItems[$index][$key]
                            }
                            foreach ($key in @($newItems[$index].Keys)) {
                                $merged[$key] = $newItems[$index][$key]
                            }
                            $newItems[$index] = $merged
                        }
                    }
                    $value = if ($value -is [System.Collections.IDictionary]) {
                        $newItems[0]
                    }
                    else {
                        , [object[]] $newItems
                    }
                }
                $writes[$parameter] = [ordered]@{ value = $value }
            }

            # A name the slot already declares is matched under any known order and rendered again under the configured one.
            foreach ($parameter in @($parameters.Keys)) {
                $entry = $parameters[$parameter]
                if ($writes.Contains($parameter) -or $parameter -cnotmatch 'Names?$' -or $entry -isnot [System.Collections.IDictionary] -or
                    -not $entry.Contains('value') -or $entry.Contains('naming_exception')) {
                    continue
                }
                $location = "$($slot.file): $parameter"
                $value = Resolve-BicepDeclaredNames -Value $entry.value -CandidateSet $candidateSet -Location $location
                if ((ConvertTo-Yaml $value) -cne (ConvertTo-Yaml $entry.value)) {
                    $rewritten = [ordered]@{}
                    foreach ($key in @($entry.Keys)) {
                        $rewritten[$key] = $entry[$key]
                    }
                    $rewritten['value'] = $value
                    $writes[$parameter] = $rewritten
                }
            }

            # The options' facts and addresses become slot values; a slot that sets the parameter already keeps its own.
            foreach ($parameter in @($descriptor.facts.Keys)) {
                if (-not $parameters.Contains($parameter)) {
                    $writes[$parameter] = [ordered]@{ fact = $descriptor.facts[$parameter] }
                }
            }
            foreach ($parameter in @($descriptor.addresses.Keys)) {
                if (-not $parameters.Contains($parameter)) {
                    $writes[$parameter] = [ordered]@{ address = $descriptor.addresses[$parameter] }
                }
            }

            $resourceGroup = $null
            if ($descriptor.deployment_target -eq 'ResourceGroup') {
                $resourceGroup = if ($document -is [System.Collections.IDictionary] -and $document.Contains('ResourceGroup')) {
                    Resolve-BicepDeclaredNames -Value "$($document.ResourceGroup)" -CandidateSet $candidateSet -Location "$($slot.file): ResourceGroup"
                }
                else {
                    Get-BicepResourceGroupName -Template $descriptor.name -Environment $slot.environment -Slot $slot.slot -Customer $slot.customer
                }
            }

            $content = Merge-BicepSlotYamlText -Text $text -Parameters $writes -ResourceGroup $resourceGroup
            if ($content -cne ($text -replace "`r", '') -and $PSCmdlet.ShouldProcess($slot.file, 'Write the declared resource names')) {
                [void] (Write-FileIfChanged -Path $slot.file -Content $content)
                Write-Message "Wrote the names of slot '$($slot.name)' of template '$name' to $($slot.file)"
            }
        }

        # The options lose what the slots now declare; written after every slot, since the namer above reads them.
        $optionsFile = Join-Path $descriptor.folder 'options.yml'
        if ([System.IO.File]::Exists($optionsFile)) {
            $options = [System.IO.File]::ReadAllText($optionsFile)
            $content = Select-BicepOptionsYamlText -Text $options -ExcludeKey names, facts, addresses
            if ($content -cne ($options -replace "`r", '') -and $PSCmdlet.ShouldProcess($optionsFile, 'Remove names, facts and addresses')) {
                [void] (Write-FileIfChanged -Path $optionsFile -Content $content)
                Write-Message "Removed names, facts and addresses from $optionsFile"
            }
        }
    }
}
