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

            # A name the slot already declares is matched under any known order and rendered again under the configured one.
            $writes = [ordered]@{}
            foreach ($parameter in @($parameters.Keys)) {
                $entry = $parameters[$parameter]
                if ($entry -isnot [System.Collections.IDictionary] -or -not $entry.Contains('value') -or $entry.Contains('naming_exception')) {
                    continue
                }
                $location = "$($slot.file): $parameter"
                $value = Resolve-BicepDeclaredNames -Value $entry.value -CandidateSet $candidateSet -Location $location -Parameter $parameter
                if ((ConvertTo-Yaml $value) -cne (ConvertTo-Yaml $entry.value)) {
                    $rewritten = [ordered]@{}
                    foreach ($key in @($entry.Keys)) {
                        $rewritten[$key] = $entry[$key]
                    }
                    $rewritten['value'] = $value
                    $writes[$parameter] = $rewritten
                }
            }

            $resourceGroup = $null
            if ($descriptor.deployment_target -eq 'ResourceGroup') {
                if ($document -isnot [System.Collections.IDictionary] -or -not $document.Contains('ResourceGroup') -or
                    [string]::IsNullOrWhiteSpace("$($document.ResourceGroup)")) {
                    throw "Template '$name' is ResourceGroup-target but its config '$($slot.file)' declares no top-level 'ResourceGroup' key — add 'ResourceGroup: <name>' (ADR-AZ-DATAMOD-DECLAREDGROUPNAME)"
                }
                $resourceGroup = Resolve-BicepDeclaredNames -Value "$($document.ResourceGroup)" -CandidateSet $candidateSet -Location "$($slot.file): ResourceGroup"
            }

            $content = Merge-BicepSlotYamlText -Text $text -Parameters $writes -ResourceGroup $resourceGroup
            if ($content -cne ($text -replace "`r", '') -and $PSCmdlet.ShouldProcess($slot.file, 'Write the declared resource names')) {
                [void] (Write-FileIfChanged -Path $slot.file -Content $content)
                Write-Message "Wrote the names of slot '$($slot.name)' of template '$name' to $($slot.file)"
            }
        }
    }
}
