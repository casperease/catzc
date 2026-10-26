<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-slides/private/Get-DiagramImageReference.ps1.md"
  header: "generated"
---
#>

function Get-DiagramImageReference {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string] $Text
    )

    $references = @{}
    foreach ($definition in [regex]::Matches($Text,
            '(?m)^ {0,3}\[([^\]]+)\]:\s*(?:\./)?\.assets/([^/\s]+)\.drawio\.png\s*$')) {
        $references[$definition.Groups[1].Value.ToLowerInvariant()] = $definition.Groups[2].Value
    }
    $references
}
