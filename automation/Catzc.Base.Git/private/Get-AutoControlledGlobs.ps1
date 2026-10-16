<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Git/private/Get-AutoControlledGlobs.ps1
    folder: private
    name: get-auto-controlled-globs
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Git
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    page: docs/references/automation/catzc-base-git/private/Get-AutoControlledGlobs.ps1.md
    test: automation/Catzc.Base.Git/tests/Get-AutoControlledGlobs.Tests.ps1
    cites:
      - ADR-CONF-LOADING#6
      - ADR-REPO-OUTDIR#{8,10}
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

    $ret.Add('automation/*/*.psd1')

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
    $ret.Add('automation/.internal/assets/bin')
    $ret.Add('automation/.internal/assets/bin/*')
    $ret.Add('automation/.internal/assets/obj')
    $ret.Add('automation/.internal/assets/obj/*')

    # The compiled-type build scratch — only *.tmp is gitignored there; the hash-keyed DLL is committed.
    $ret.Add('automation/.compiled/*.tmp')

    $ret.Add('**/.$*.drawio.png.bkp')

    , $ret.ToArray()
}
