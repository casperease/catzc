<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-contracts/private/Get-ContractCommandRoot.ps1.md"
  header: "generated"
---
#>

function Get-ContractCommandRoot {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $Module,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    # The contract folder names the module in the normal form; the code track names it in PowerShell's folder case.
    $languages = Get-Config -Config languages
    $commandLanguage = $languages.languages | Where-Object name -ceq 'powershell' | Select-Object -First 1
    try {
        $name = [Catzc.Base.Objects.NameCase]::FromNormal($Module, $commandLanguage.naming.folder[0], $languages.naming_normal_form)
    }
    catch {
        throw "contract asset: the module folder '$Module' is not in the repository normal form, $($languages.naming_normal_form) (ADR-REPO-CMDCONTRACT-NOPLACEMENTFACTS)."
    }
    $found = @(Get-CatzcModule -Name $name -EngineTrack -RepositoryRoot $RepositoryRoot)
    if ($found.Count -ne 1) {
        throw "contract asset: no module named '$name' (the folder '$Module') in the code track, so its command contracts name no command file (ADR-REPO-CMDCONTRACT-NOPLACEMENTFACTS)."
    }
    if (@($found[0].languages) -cnotcontains 'powershell') {
        throw [System.NotImplementedException]::new("contract asset: the command contracts of '$Module' need a checker for its implementation language ($(@($found[0].languages) -join ', ')); only PowerShell commands are checked (ADR-REPO-CMDCONTRACT-CHECKERPERLANGUAGE).")
    }
    $found[0].root
}
