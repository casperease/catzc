<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-contracts/private/Get-ContractDescriptionFindings.ps1.md"
  header: "generated"
---
#>

function Get-ContractDescriptionFindings {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        # The contract asset the description belongs to, named in each finding.
        [Parameter(Mandatory)]
        [string] $AssetPath,

        # The key that holds the description in the asset: description in a YAML contract, $comment in a JSON schema.
        [Parameter(Mandatory)]
        [string] $Key,

        # The description as the asset holds it; empty when the asset has none.
        [AllowEmptyString()]
        [string] $Description,

        # The command's help synopsis, when the contract has one to equal; a schema has none, so its check is form only.
        [AllowEmptyString()]
        [string] $Synopsis = ''
    )

    if (-not $Description) {
        return "'$AssetPath': $Key is missing; one plain sentence says what the contract guarantees"
    }
    $form = [Catzc.Base.CodeMeta.PlainText]::PlainScalarFinding($Description)
    if ($form) {
        "'$AssetPath': $Key $form, so it is no plain description"
    }
    if ($PSBoundParameters.ContainsKey('Synopsis')) {
        $expected = [Catzc.Base.CodeMeta.PlainText]::Plain($Synopsis)
        if ($Description -cne $expected) {
            "'$AssetPath': $Key is not the command's synopsis as plain text; write '$expected', or change the synopsis on its comment page"
        }
    }
}
