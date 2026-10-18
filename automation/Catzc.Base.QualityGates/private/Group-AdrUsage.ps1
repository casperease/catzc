function Group-AdrUsage {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [pscustomobject[]] $Row,

        [Parameter(Mandatory)]
        [ValidateSet('Rule', 'Document')]
        [string] $By
    )

    if ($By -eq 'Rule') {
        $groups = $Row | Group-Object -Property { "$($_.Code)#$($_.Rule)" }
        $result = foreach ($group in $groups) {
            $first = $group.Group[0]
            $documents = [string[]] @($group.Group.Path | Sort-Object -Unique -CaseSensitive)
            [pscustomobject]@{ Code = $first.Code; Rule = $first.Rule; Count = $documents.Count; Documents = $documents }
        }
        $result | Sort-Object -Property Code, @{ Expression = { if ($null -eq $_.Rule) {
                    -1
                }
                else {
                    $_.Rule
                } }
        }
        return
    }

    $groups = $Row | Group-Object -Property Path
    $result = foreach ($group in $groups) {
        $citations = [string[]] @($group.Group | ForEach-Object { if ($null -eq $_.Rule) {
                    $_.Code
                }
                else {
                    "$($_.Code)#$($_.Rule)"
                } } | Sort-Object -Unique -CaseSensitive)
        [pscustomobject]@{ Path = $group.Name; Count = $citations.Count; Citations = $citations }
    }
    $result | Sort-Object -Property Path
}
