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

    $name = (Get-Config -Config contracts).ExceptionModuleOf($Module)
    if (-not $name) {
        $languages = Get-Config -Config languages
        $commandLanguage = $languages.languages | Where-Object name -ceq 'powershell' | Select-Object -First 1
        $trackName, $folderNormal = $Module -split '\.', 2
        if (-not $folderNormal) {
            throw "contract asset: the group '$Module' names no module after its track (ADR-REPO-CMDCONTRACT-NOPLACEMENTFACTS)."
        }
        $track = Get-Track -Name $trackName
        try {
            $folder = [Catzc.Base.Objects.NameCase]::FromNormal($folderNormal, $commandLanguage.naming.folder[0],
                $languages.naming_normal_form)
        }
        catch {
            throw "contract asset: the group '$Module' is not in the repository normal form, $($languages.naming_normal_form) (ADR-REPO-CMDCONTRACT-NOPLACEMENTFACTS)."
        }
        $name = $track.FullNameOf($folder)
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
