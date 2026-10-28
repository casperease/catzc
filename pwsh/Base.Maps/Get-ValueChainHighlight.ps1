function Get-ValueChainHighlight {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Maps.ValueChainHighlight], [string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({ (Get-Config -Config drs).RuleSets.External })]
        [string[]] $Rule,

        [switch] $AsJson
    )

    $highlight = [Catzc.Base.Maps.ValueChainHighlight]::ForRecord((Get-ValueChainMap), $Rule)
    if ($AsJson) {
        return $highlight.ToJson()
    }
    $highlight
}
