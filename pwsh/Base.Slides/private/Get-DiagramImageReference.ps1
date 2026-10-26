function Get-DiagramImageReference {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string] $Text
    )

    # A page's reference definitions that point at a diagram beside it: label, case-folded as markdown folds it, to the name.
    $references = @{}
    foreach ($definition in [regex]::Matches($Text,
            '(?m)^ {0,3}\[([^\]]+)\]:\s*(?:\./)?\.assets/([^/\s]+)\.drawio\.png\s*$')) {
        $references[$definition.Groups[1].Value.ToLowerInvariant()] = $definition.Groups[2].Value
    }
    $references
}
