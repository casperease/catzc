function Resolve-BicepDeclaredNames {
    [CmdletBinding()]
    [OutputType([object])]
    param(
        [Parameter(Mandatory)]
        [AllowNull()]
        [object] $Value,

        [Parameter(Mandatory)]
        [hashtable] $CandidateSet,

        [Parameter(Mandatory)]
        [string] $Location
    )

    if ($Value -is [System.Collections.IDictionary]) {
        $resolved = [ordered]@{}
        foreach ($key in @($Value.Keys)) {
            $resolved[$key] = Resolve-BicepDeclaredNames -Value $Value[$key] -CandidateSet $CandidateSet -Location "$Location.$key"
        }
        return $resolved
    }
    if ($Value -is [System.Collections.IList]) {
        $items = for ($index = 0; $index -lt $Value.Count; $index++) {
            , (Resolve-BicepDeclaredNames -Value $Value[$index] -CandidateSet $CandidateSet -Location "$Location[$index]")
        }
        return , [object[]] @($items)
    }
    if ($Value -isnot [string] -or [string]::IsNullOrEmpty($Value)) {
        return $Value
    }

    $naming = Get-Naming
    $orders = @(, $naming) + @((Get-AzureNameOrderSet).Keys | Where-Object { $naming -isnot [string] -or $_ -ne $naming })
    $components = $null
    foreach ($order in $orders) {
        try {
            $components = ConvertFrom-AzureResourceName -Name $Value -CandidateSet $CandidateSet -Order $order
            break
        }
        catch [System.Management.Automation.MethodInvocationException] {
            $components = $null
        }
    }
    if ($null -eq $components) {
        Write-Message "${Location}: '$Value' has no single canonical match under any known order; kept as written"
        return $Value
    }

    # An omitted component matches empty, and the one org is read from azure.yml so the namer always has it.
    $azure = Get-Config -Config azure
    $nameArgs = @{
        Env        = $components.env
        Shortcode  = "$($azure.environments[$components.env].shortcode)"
        RegionCode = $components.region
        Org        = "$($azure.org)"
        ShortName  = $components.short_name
        Type       = $components.type
        Order      = $naming
    }
    if ($components.slot) {
        $nameArgs['Slot'] = $components.slot
    }
    if ($components.customer) {
        $nameArgs['Customer'] = $components.customer
        $nameArgs['CustomerShortcode'] = "$($CandidateSet.customer[$components.customer])"
    }
    if ($components.role) {
        $nameArgs['Role'] = $components.role
    }
    Get-AzureResourceName @nameArgs
}
