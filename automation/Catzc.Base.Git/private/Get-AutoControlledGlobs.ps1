<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Git/private/Get-AutoControlledGlobs.ps1
    kind: automation-function
    module: Catzc.Base.Git
    visibility: private
    adrs:
      - ADR-CONF-LOADING#6
      - ADR-REPO-OUTDIR#10
      - ADR-REPO-OUTDIR#8
  config:
    synopsis: Computes, in memory, the whitelist of paths the automation itself generates and owns.
    description: |-
      The auto-controlled set Reset-GitCleanFxd deletes against — derived fresh on every call, held in
      memory only, never persisted, so it cannot drift from what the owners actually generate. It is the
      union of:

      - the managed root-config registry's gitignored targets (rootconfig.yml entries with optIn and
        committed false — .editorconfig, the .vscode/ files, cspell.yml, catzc.sln, …), read through
        Get-Config (reading a config is global access, never limited by the dependency graph —
        [ADR-CONF-LOADING#6](/docs/adr/configuration/module-config-loading.md#rule-adr-conf-loading6));
      - the conventional generated-artifact classes: the dynamic module manifests
        (automation/<Module>/<Module>.psd1), the generated READMEs (every gitignored README.md is a
        generated copy by the generated-readmes contract — a hand-authored README is only safe once
        opted in and committed), the generated cspell dictionaries (.cspell/), the transient output root (out/ — disposable by the
        dedicated-output-directory contract), the IDE-only C# project's build output (bin/obj under
        automation/.internal/assets), the compiled-type *.tmp scratch, and the drawio editor's autosave
        shadows ('.$*.drawio.png.bkp' beside a committed .drawio.png asset).

      Minus the exclusions, written gitignore-style with a leading '!': a path matching an exclusion is
      never auto-controlled, whatever else it matches (the authored out/plan-*.md files,
      [ADR-REPO-OUTDIR#10](/docs/adr/repository/dedicated-output-directory.md#rule-adr-repo-outdir10)).

      Patterns are repo-relative, '/'-separated -like globs; a directory is listed both bare and with a
      trailing /* so a whole-folder candidate from `git clean` matches too.
    outputs: '[string[]] The -like patterns of the auto-controlled set; a ''!''-prefixed pattern is an exclusion.'
---
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
    # [comment:6](/docs/references/automation/catzc-base-git/private/Get-AutoControlledGlobs.ps1.md#comment6)
    $ret.Add('automation/*/*.psd1')

    # Generated READMEs (generated-readmes): a gitignored README.md is a generated copy by construction.
    $ret.Add('README.md')
    $ret.Add('*/README.md')

    # Generated cspell dictionaries, regenerated at the importer tail.
    # [comment:7](/docs/references/automation/catzc-base-git/private/Get-AutoControlledGlobs.ps1.md#comment7)
    $ret.Add('.cspell')
    $ret.Add('.cspell/*')

    # The output root — transient by contract (dedicated-output-directory) — except the authored plan files, which...
    # [comment:8](/docs/references/automation/catzc-base-git/private/Get-AutoControlledGlobs.ps1.md#comment8)
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
    # [comment:9](/docs/references/automation/catzc-base-git/private/Get-AutoControlledGlobs.ps1.md#comment9)
    $ret.Add('**/.$*.drawio.png.bkp')

    , $ret.ToArray()
}
