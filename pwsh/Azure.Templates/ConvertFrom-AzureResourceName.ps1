function ConvertFrom-AzureResourceName {
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [string] $Name,
        [ArgumentCompleter({ (Get-AzureResourceTypeSet).Keys })]
        [string] $Type,
        [Parameter(Mandatory)]
        [hashtable] $CandidateSet,
        [ArgumentCompleter({ (Get-AzureNameOrderSet).Keys })]
        [object] $Order = (Get-Naming)
    )

    begin {
        $sequence = Resolve-AzureNameOrder -Order $Order
        $sets = @{}
        foreach ($key in $CandidateSet.Keys) {
            $sets[$key] = $CandidateSet[$key]
        }
        $sets['types'] = Get-AzureResourceTypeSet
        $sets['patterns'] = Get-AzureNamePatternSet
    }

    process {
        [Catzc.Azure.Templates.AzureNameMatcher]::Match($Name, $Type, $sets, $sequence)
    }
}
