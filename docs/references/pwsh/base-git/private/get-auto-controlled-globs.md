# pwsh/Base.Git/private/Get-AutoControlledGlobs.ps1

The whitelist behind `Reset-GitCleanFxd`: it computes, on every call and in memory only, the glob patterns of what the automation itself
generates and owns.

## help

### synopsis

Computes, in memory, the whitelist of paths the automation itself generates and owns.

### description

The auto-controlled set Reset-GitCleanFxd deletes against — derived fresh on every call, held in memory only, never persisted, so it cannot
drift from what the owners actually generate. It is the union of:

- the managed root-config registry's gitignored targets (rootconfig.yml entries with optIn and committed false — .editorconfig, the .vscode/
  files, cspell.yml, catzc.sln, …), read through Get-Config (reading a config is global access, never limited by the dependency graph —
  [ADR-CONF-LOADING-READINGISGLOBAL](../../../../drs/configuration/module-config-loading.md#rule-adr-conf-loading-readingisglobal));
- the conventional generated-artifact classes: the dynamic module manifests (`pwsh/<Module>/<Module>.psd1`), the generated READMEs (every
  gitignored README.md is a generated copy by the generated-readmes contract — a hand-authored README is only safe once opted in and
  committed), the generated cspell dictionaries (.cspell/), the transient output root (out/ — disposable by the dedicated-output-directory
  contract), the IDE-only C# project's build output (bin/obj under pwsh/.internal/assets), the compiled-type `*.tmp` scratch, and the drawio
  editor's autosave shadows ('`.$*.drawio.png.bkp`' beside a committed .drawio.png asset).

Minus the exclusions, written gitignore-style with a leading '!': a path matching an exclusion is never auto-controlled, whatever else it
matches (the authored `out/plan-*.md` files,
[ADR-REPO-OUTDIR-PLANNOTES](../../../../drs/repository/dedicated-output-directory.md#rule-adr-repo-outdir-plannotes)).

Patterns are repo-relative, '/'-separated -like globs; a directory is listed both bare and with a trailing `/*` so a whole-folder candidate
from `git clean` matches too.

### outputs

`[string[]]` The -like patterns of the auto-controlled set; a '!'-prefixed pattern is an exclusion.

## The members

- The generated members of the track model, the module manifests among them: the vendored `.psd1` files are committed, so they can never
  appear among untracked clean candidates. These are the gitignored members whose writer is a generator: a glob as written, a folder glob as
  its folder and what lies in it (DDR-TRACK-ISPLACEDCLUSTER).
- The generated cspell dictionaries, regenerated at the importer tail
  ([ADR-REPO-OUTDIR-DICTIONARIESGENERATED](../../../../drs/repository/dedicated-output-directory.md#rule-adr-repo-outdir-dictionariesgenerated)).
- The drawio editor's autosave shadows (`.$<name>.drawio.png.bkp`): disposable copies the editor writes beside a committed `.drawio.png`
  asset; regenerable, safe to clean.
