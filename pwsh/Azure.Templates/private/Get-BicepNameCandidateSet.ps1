function Get-BicepNameCandidateSet {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param()

    $azure = Get-Config -Config azure
    $environments = [ordered]@{}
    $regions = [System.Collections.Generic.SortedSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($environment in @($azure.environments.Keys)) {
        $entry = $azure.environments[$environment]
        $environments[$environment] = "$($entry.shortcode)"
        [void] $regions.Add("$($entry.region_code)")
    }
    $customers = [ordered]@{}
    $customerConfig = Get-Config -Config customer
    foreach ($customer in @($customerConfig.customers.Keys)) {
        $customers[$customer] = "$($customerConfig.customers[$customer].shortcode)"
    }
    $shortNames = [System.Collections.Generic.SortedSet[string]]::new([System.StringComparer]::Ordinal)
    $slots = [System.Collections.Generic.SortedSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($template in @(Get-BicepTemplateNames)) {
        $descriptor = Get-BicepTemplate $template
        [void] $shortNames.Add($descriptor.short_name)
        foreach ($slot in @($descriptor.slots)) {
            if ($slot.slot) {
                [void] $slots.Add($slot.slot)
            }
        }
    }
    @{
        env        = $environments
        slot       = [string[]] @($slots)
        region     = [string[]] @($regions)
        org        = [string[]] @("$($azure.org)")
        short_name = [string[]] @($shortNames)
        customer   = $customers
    }
}
