function Invoke-BreakGlassRotation {
    # A state-changing command that previews with -DryRun, not ShouldProcess.
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '',
        Justification = 'Uses -DryRun instead of ShouldProcess — see ADR-PWSH-DRYRUN-SUPPRESSSHOULDPROCESS')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Environment,

        [string] $Customer,

        [ValidateRange(16, 128)]
        [int] $Length = 32,

        [switch] $DryRun
    )

    $descriptor = Get-BicepTemplate expedition
    $slots = @($descriptor.slots | Where-Object {
            $_.environment -eq $Environment -and ([string]::IsNullOrEmpty($Customer) -or $_.customer -eq $Customer)
        })
    $rotated = 0
    foreach ($slot in $slots) {
        $coordinate = @{ Template = 'expedition'; Environment = $slot.environment }
        foreach ($axis in 'Slot', 'Customer') {
            $value = $slot.($axis.ToLowerInvariant())
            if (-not [string]::IsNullOrEmpty($value)) {
                $coordinate[$axis] = $value
            }
        }
        $parameters = (Get-BicepTemplateConfiguration @coordinate).ParametersFile.parameters
        if (-not $parameters.Contains('administratorLoginPassword') -or -not $parameters['administratorLoginPassword'].Contains('reference')) {
            continue
        }
        $reference = $parameters['administratorLoginPassword'].reference
        $target = [pscustomobject]@{
            Slot          = $slot.name
            ResourceGroup = Get-BicepSlotResourceGroup -TemplateDescriptor $descriptor -Environment $slot.environment -Slot $slot.slot -Customer $slot.customer
            Server        = Get-BicepResourceName -Type sql @coordinate
            Vault         = ($reference.keyVault.id -split '/')[-1]
            Secret        = $reference.secretName
        }
        Invoke-SlotBreakGlassRotation -Target $target -Length $Length -DryRun:$DryRun
        $rotated++
    }
    if ($rotated -eq 0) {
        throw "No expedition slot of environment '$Environment'$(if ($Customer) { " and customer '$Customer'" }) has a Key Vault reference for administratorLoginPassword, so there is no break-glass password to rotate."
    }
}
