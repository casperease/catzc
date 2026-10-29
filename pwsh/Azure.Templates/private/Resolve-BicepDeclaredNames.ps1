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
        [string] $Location,

        [string] $Parameter
    )

    $naming = Get-Naming
    $orders = @(, $naming) + @((Get-AzureNameOrderSet).Keys | Where-Object { $naming -isnot [string] -or $_ -ne $naming })
    $azure = Get-Config -Config azure
    $candidates = $CandidateSet

    $renderName = {
        param([string] $Name, [string] $At)
        $components = $null
        foreach ($order in $orders) {
            try {
                $components = ConvertFrom-AzureResourceName -Name $Name -CandidateSet $candidates -Order $order
                break
            }
            catch [System.Management.Automation.MethodInvocationException] {
                $components = $null
            }
        }
        if ($null -eq $components) {
            Write-Message "${At}: '$Name' has no single canonical match under any known order; kept as written"
            return $Name
        }

        # An omitted component matches empty, and the one org is read from azure.yml so the namer always has it.
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
            $nameArgs['CustomerShortcode'] = "$($candidates.customer[$components.customer])"
        }
        if ($components.role) {
            $nameArgs['Role'] = $components.role
        }
        Get-AzureResourceName @nameArgs
    }

    # The leaves the name gate reads as names (Get-BicepSlotNameLeaf); without a parameter every leaf is a name.
    $named = $null
    if (-not [string]::IsNullOrEmpty($Parameter)) {
        $notNames = [string[]] @((Get-Config -Config resource-types).not_names)
        $named = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
        foreach ($leaf in @(Get-BicepSlotNameLeaf -Value ([ordered]@{ "$Parameter" = $Value }) -Location '' -NotNames $notNames)) {
            if ($leaf.named) {
                [void] $named.Add($leaf.location)
            }
        }
    }

    $walk = {
        param([object] $Node, [string] $Path, [string] $At)
        if ($Node -is [System.Collections.IDictionary]) {
            $object = [ordered]@{}
            foreach ($key in @($Node.Keys)) {
                $object[$key] = & $walk $Node[$key] "$Path.$key" "$At.$key"
            }
            return $object
        }
        if ($Node -is [System.Collections.IList]) {
            $items = for ($index = 0; $index -lt $Node.Count; $index++) {
                , (& $walk $Node[$index] "$Path[$index]" "$At[$index]")
            }
            return , [object[]] @($items)
        }
        if ($Node -is [string] -and -not [string]::IsNullOrEmpty($Node) -and ($null -eq $named -or $named.Contains($Path))) {
            return & $renderName $Node $At
        }
        $Node
    }

    & $walk $Value $Parameter $Location
}
