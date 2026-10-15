<#
.SYNOPSIS
    Computes, in memory, the whitelist of paths the automation itself generates and owns.
.DESCRIPTION
    The auto-controlled set Reset-GitCleanFxd deletes against — derived fresh on every call, held in memory only,...
    [ADR-CONF-LOADING#6](/docs/adr/configuration/module-config-loading.md#rule-adr-conf-loading6),
    [ADR-REPO-OUTDIR#10](/docs/adr/repository/dedicated-output-directory.md#rule-adr-repo-outdir10)
    [comment:1](/docs/references/automation/catzc-base-git/private/Get-AutoControlledGlobs.ps1.md#comment1)
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

    # Generated module manifests (dynamic-module-manifests; the vendored.psd1 are committed, so they can never appear...
    # [comment:2](/docs/references/automation/catzc-base-git/private/Get-AutoControlledGlobs.ps1.md#comment2)
    $ret.Add('automation/*/*.psd1')

    # Generated READMEs (generated-readmes): a gitignored README.md is a generated copy by construction.
    $ret.Add('README.md')
    $ret.Add('*/README.md')

    # Generated cspell dictionaries, regenerated at the importer tail.
    # [ADR-REPO-OUTDIR#8](/docs/adr/repository/dedicated-output-directory.md#rule-adr-repo-outdir8)
    # [comment:3](/docs/references/automation/catzc-base-git/private/Get-AutoControlledGlobs.ps1.md#comment3)
    $ret.Add('.cspell')
    $ret.Add('.cspell/*')

    # The output root — transient by contract (dedicated-output-directory) — except the authored plan files, which...
    # [ADR-REPO-OUTDIR#10](/docs/adr/repository/dedicated-output-directory.md#rule-adr-repo-outdir10)
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

    # drawio editor autosave shadows ('.$<name>.drawio.png.bkp') — disposable copies the editor writes beside a...
    # [comment:5](/docs/references/automation/catzc-base-git/private/Get-AutoControlledGlobs.ps1.md#comment5)
    $ret.Add('**/.$*.drawio.png.bkp')

    , $ret.ToArray()
}
