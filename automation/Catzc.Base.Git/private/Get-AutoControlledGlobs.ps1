<#
.SYNOPSIS
    Computes, in memory, the whitelist of paths the automation itself generates and owns.
.DESCRIPTION
    The auto-controlled set Reset-GitCleanFxd deletes against — derived fresh on every call, held in
    memory only, never persisted, so it cannot drift from what the owners actually generate. It is the
    union of:

    - the managed root-config registry's gitignored targets (rootconfig.yml entries with optIn and
      committed false — .editorconfig, the .vscode/ files, cspell.yml, catzc.sln, …), read through
      Get-Config (reading a config is global access, never dependency-gated — ADR-MODCFG:6);
    - the conventional generated-artifact classes: the dynamic module manifests
      (automation/<Module>/<Module>.psd1), the generated README links (every gitignored README.md is a
      materialised link by the generated-readmes contract — a hand-authored README is only safe once
      opted in and committed), the generated cspell dictionaries (.cspell/), the transient output root
      (out/ — disposable by the dedicated-output-directory contract), the IDE-only C# project's build
      output (bin/obj under automation/.internal/assets), and the compiled-type *.tmp scratch.

    Patterns are repo-relative, '/'-separated -like globs; a directory is listed both bare and with a
    trailing /* so a whole-folder candidate from `git clean` matches too.
.OUTPUTS
    [string[]] The -like patterns of the auto-controlled set.
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

    # Generated module manifests (dynamic-module-manifests; the vendored .psd1 are committed, so they
    # can never appear among untracked clean candidates).
    $ret.Add('automation/*/*.psd1')

    # Generated README links (generated-readmes): a gitignored README.md is a link by construction.
    $ret.Add('README.md')
    $ret.Add('*/README.md')

    # Generated cspell dictionaries, regenerated at the importer tail (ADR-OUTDIR:8).
    $ret.Add('.cspell')
    $ret.Add('.cspell/*')

    # The output root — transient by contract (dedicated-output-directory).
    $ret.Add('out')
    $ret.Add('out/*')

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

    , $ret.ToArray()
}
