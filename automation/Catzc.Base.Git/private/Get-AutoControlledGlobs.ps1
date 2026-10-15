<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Git/private/Get-AutoControlledGlobs.ps1
    kind: private-function
    module: Catzc.Base.Git
    visibility: private
    adrs:
      - ADR-CONF-LOADING#6
      - ADR-REPO-OUTDIR#10
      - ADR-REPO-OUTDIR#8
---
#>

<#
.SYNOPSIS
    Computes, in memory, the whitelist of paths the automation itself generates and owns.
.DESCRIPTION
    Derived fresh on every call and never persisted, so the whitelist cannot drift from what the owners generate.
.OUTPUTS
    [string[]] The -like patterns of the auto-controlled set; a '!'-prefixed pattern is an exclusion.
#>
function Get-AutoControlledGlobs {
    [CmdletBinding()]
    [OutputType([string[]])]
    param()

    $ret = [System.Collections.Generic.List[string]]::new()

    # The managed, gitignored root-config targets — the registry names them (generated-root-configs).
    $rootConfig = Get-Config -Config rootconfig
    foreach ($entry in $rootConfig.files) {
        if ($entry.optIn -and -not $entry.committed) {
            $ret.Add($entry.target)
        }
    }

    # Vendored .psd1 files are committed, so they can never show up among the untracked clean candidates.
    # [comment:2](/docs/references/automation/catzc-base-git/private/Get-AutoControlledGlobs.ps1.md#comment2)
    $ret.Add('automation/*/*.psd1')

    # Generated READMEs (generated-readmes): a gitignored README.md is a generated copy by construction.
    $ret.Add('README.md')
    $ret.Add('*/README.md')

    # Regenerated at the importer tail, so deleting these dictionaries loses nothing.
    # [comment:3](/docs/references/automation/catzc-base-git/private/Get-AutoControlledGlobs.ps1.md#comment3)
    $ret.Add('.cspell')
    $ret.Add('.cspell/*')

    # Plan files are authored working notes, not output, so the exclusion keeps them though out/ is transient.
    # [comment:4](/docs/references/automation/catzc-base-git/private/Get-AutoControlledGlobs.ps1.md#comment4)
    $ret.Add('out')
    $ret.Add('out/*')
    $ret.Add('!out/plan-*.md')

    # The generated .vscode editor config (generated-root-configs); clean may list the whole folder.
    $ret.Add('.vscode')
    $ret.Add('.vscode/*')

    # The IDE-only C# project's build output (native-csharp-types).
    $ret.Add('automation/.internal/assets/bin')
    $ret.Add('automation/.internal/assets/bin/*')
    $ret.Add('automation/.internal/assets/obj')
    $ret.Add('automation/.internal/assets/obj/*')

    # The compiled-type build scratch — only *.tmp is gitignored there; the hash-keyed DLL is committed.
    $ret.Add('automation/.compiled/*.tmp')

    # Editor autosave shadows sit beside a committed .drawio.png and are regenerable, so cleaning them is safe.
    # [comment:5](/docs/references/automation/catzc-base-git/private/Get-AutoControlledGlobs.ps1.md#comment5)
    $ret.Add('**/.$*.drawio.png.bkp')

    , $ret.ToArray()
}
