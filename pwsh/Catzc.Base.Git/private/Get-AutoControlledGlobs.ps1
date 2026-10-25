<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-git/private/Get-AutoControlledGlobs.ps1.md"
  header: "generated"
---
#>

function Get-AutoControlledGlobs {
    [CmdletBinding()]
    [OutputType([string[]])]
    param()

    $ret = [System.Collections.Generic.List[string]]::new()
    $modulesFolder = Get-CatzcModulesFolder

    # The managed, gitignored root-config targets — the registry names them (generated-root-configs).
    $rootConfig = Get-Config -Config rootconfig
    foreach ($entry in $rootConfig.files) {
        if ($entry.optIn -and -not $entry.committed) {
            $ret.Add($entry.target)
        }
    }

    $ret.Add("$modulesFolder/*/*.psd1")

    # Generated READMEs (generated-readmes): a gitignored README.md is a generated copy by construction.
    $ret.Add('README.md')
    $ret.Add('*/README.md')

    $ret.Add('.cspell')
    $ret.Add('.cspell/*')

    $ret.Add('out')
    $ret.Add('out/*')
    $ret.Add('!out/plan-*.md')

    # The generated .vscode editor config (generated-root-configs); clean may list the whole folder.
    $ret.Add('.vscode')
    $ret.Add('.vscode/*')

    # The IDE-only C# project's build output (native-csharp-types).
    $ret.Add("$modulesFolder/.internal/assets/bin")
    $ret.Add("$modulesFolder/.internal/assets/bin/*")
    $ret.Add("$modulesFolder/.internal/assets/obj")
    $ret.Add("$modulesFolder/.internal/assets/obj/*")

    # The compiled-type build scratch — only *.tmp is gitignored there; the hash-keyed DLL is committed.
    $ret.Add("$modulesFolder/.compiled/*.tmp")

    $ret.Add('**/.$*.drawio.png.bkp')

    , $ret.ToArray()
}
