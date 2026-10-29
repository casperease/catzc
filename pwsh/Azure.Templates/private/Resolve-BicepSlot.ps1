function Resolve-BicepSlot {
    [CmdletBinding()]
    [OutputType([Catzc.Azure.Templates.BicepSlot])]
    param(
        [Parameter(Mandatory)]
        [Catzc.Azure.Templates.BicepTemplate] $TemplateDescriptor,

        [Parameter(Mandatory)]
        [string] $Environment,

        [string] $Slot,

        [string] $Customer
    )

    $wantSlot = [string] $Slot
    $wantCustomer = [string] $Customer
    $declared = @($TemplateDescriptor.slots | Where-Object { $_.environment -eq $Environment -and $_.slot -eq $wantSlot -and $_.customer -eq $wantCustomer })
    if ($declared.Count -gt 0) {
        return $declared[0]
    }
    if ([string]::IsNullOrEmpty($wantSlot)) {
        return $null
    }
    $base = @($TemplateDescriptor.slots | Where-Object { $_.environment -eq $Environment -and $_.slot -eq '' -and $_.customer -eq $wantCustomer })
    if ($base.Count -eq 0) {
        return $null
    }
    [Catzc.Azure.Templates.BicepSlot]::new("$Environment-$wantSlot", $Environment, $wantSlot, $base[0].subscription, $base[0].customer, $base[0].file)
}
