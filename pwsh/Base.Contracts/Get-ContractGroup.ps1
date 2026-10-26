<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-contracts/Get-ContractGroup.ps1.md"
  header: "generated"
---
#>

function Get-ContractGroup {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Module,

        [string] $RepositoryRoot = (Get-RepositoryRoot)
    )

    # A module's contract group is its track and its folder in the normal form (pwsh.base.vs_code for Catzc.Base.VSCode):
    # the group names where the module lives, never the namespace it carries.
    $found = @(Get-CatzcModule -Name $Module -RepositoryRoot $RepositoryRoot)
    if ($found.Count -ne 1) {
        throw "Get-ContractGroup: no module named '$Module', so it has no contract group."
    }
    $track = Get-Track -Name $found[0].track
    $languages = Get-Config -Config languages
    $folder = [Catzc.Base.Objects.NameCase]::ToNormal('pascal-dotted', $track.FolderNameOf($found[0].name),
        $languages.naming_normal_form)
    "$($found[0].track).$folder"
}
