function Test-BicepResourceNames {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [string[]] $Template = @(Get-BicepTemplateNames),

        [string] $OutputFolder,

        [switch] $PassThru
    )

    $issues = [System.Collections.Generic.List[string]]::new()
    $slots = 0
    $declared = 0
    foreach ($name in $Template) {
        $descriptor = Get-BicepTemplate $name
        $declared += $descriptor.names.Count
        foreach ($slot in @($descriptor.slots)) {
            $slots++
            $raw = [System.IO.File]::ReadAllText($slot.file) | ConvertFrom-Yaml
            $written = if ($raw -is [System.Collections.IDictionary] -and $raw.Contains('ParametersFile') -and
                $raw.ParametersFile.Contains('parameters')) {
                $raw.ParametersFile.parameters
            }
            else {
                @{}
            }
            foreach ($parameter in @($descriptor.names.Keys)) {
                # An each entry's items belong in the slot; the resolver below refuses an item that writes a name field.
                if (-not $descriptor.names[$parameter].each -and $written.Contains($parameter)) {
                    $issues.Add("${name}/$($slot.name): writes '$parameter', a name the namer derives (options.yml names) — delete it from the slot")
                }
            }
            # Every declared name resolves for every slot, so a build never meets a name that cannot be derived.
            try {
                $null = Resolve-BicepDerivedNames -TemplateDescriptor $descriptor -Slot $slot -SlotParameters $written
            }
            catch {
                $issues.Add("${name}/$($slot.name): a declared name does not derive — $($_.Exception.Message)")
            }
        }
    }

    Write-QualityGateReport -Subject 'bicep-resource-names' -Title 'Test-BicepResourceNames' -Issues $issues `
        -Facts ([ordered]@{ Templates = @($Template).Count; Slots = $slots; DeclaredNames = $declared }) `
        -OutputFolder $OutputFolder -PassThru:$PassThru
}
