<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Languages/New-GoWorkspace.ps1
    name: new-go-workspace
    filetype: ps1
    kind: function
    subkind: writer
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Languages
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-base-languages/New-GoWorkspace.ps1.md
    test: automation/Catzc.Base.Languages/tests/New-GoWorkspace.Tests.ps1
    cites:
      - ADR-CONF-ADDRESSING
      - ADR-REPO-ROOTCFG
  config:
    synopsis: |-
      Renders the Go test workspace — the repository-root go.work and each <root>/tests/<folder>/go.mod — from
      configs/go.yml.
    description: |-
      The Go root is go.yml's `root`, resolved by GoConfig.ResolveRoot: the declared folder, else go/ when the
      repository has one (a Go root track), else .go/ (the dot-prefixed tooling folder). Discovers the Go test folders
      (the immediate, non-dot-prefixed subdirectories of <root>/tests/ that hold at least one .go file; each is one Go
      module, named for its catzc module in kebab case) and renders:

        go.work                       at the repository root, the idiomatic workspace place an editor's Go language
                                      server finds with no configuration: the go directive and one
                                      `use ./<root>/tests/<folder>` entry per folder;
        <root>/tests/<folder>/go.mod  the module path <module_root>/<folder>, the go directive, and one require line
                                      per declared dependency.

      The settings come from configs/go.yml (Get-Config -Config go, typed as GoConfig); the go directive is the go
      tool's pin in tools.yml (global.tools.go.version, e.g. 1.27), the one Go version, so the workspace never asks
      for a newer toolchain than the managed one. Folders and dependencies are sorted ordinally and every file is LF
      with one trailing newline, so the same tree and config render the same bytes on every machine. Rendering is pure
      text: offline, with no call to the go tool.

      This is a pure renderer: it returns the content and writes nothing. It is the `generator` the root-config
      registry names for the go.work and go.mod targets, and Build-RootConfig owns the write
      ([ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md)). One call renders every file, so a
      registry entry selects its files with -Target.
    parameters:
      Target: |-
        Return only the files whose repository-relative path matches this case-sensitive wildcard pattern (e.g.
        'go.work' or '*/tests/*/go.mod'). Default: every file.
    outputs: |-
      [Catzc.Base.Languages.GoWorkspaceFile] One record per rendered file ({ Target; Content }): go.work first,
      then each go.mod in folder order.
    examples:
      - New-GoWorkspace
      - (New-GoWorkspace -Target 'go.work').Content
---
#>

function New-GoWorkspace {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Languages.GoWorkspaceFile])]
    param(
        [string] $Target = '*'
    )

    $config = Get-Config -Config go
    $goVersion = "$(Get-ConfigValue -Address 'global.tools.go.version')"
    if ($goVersion -cnotmatch '^1\.(0|[1-9][0-9]*)(\.(0|[1-9][0-9]*))?$') {
        throw "tools.yml go.version '$goVersion' is not a Go language version for the go directive (1.N or 1.N.P, e.g. '1.27')."
    }
    $repositoryRoot = Get-RepositoryRoot
    $testsRelative = "$($config.ResolveRoot($repositoryRoot))/tests"
    $testsRoot = Join-Path $repositoryRoot $testsRelative

    # One Go module per folder that holds Go code; a folder left with only generated files is not a module.
    $folders = [System.Collections.Generic.List[string]]::new()
    if (Test-Path -LiteralPath $testsRoot -PathType Container) {
        foreach ($folderPath in @(Get-ChildPath $testsRoot -Directory -Depth 1)) {
            $folderName = [System.IO.Path]::GetFileName($folderPath)
            if ($folderName.StartsWith('.')) {
                continue
            }
            # Go code sits directly in its module folder; the deeper levels are headroom for sub-packages.
            if (-not @(Get-ChildPath $folderPath -File -Filter '*.go' -Depth 3).Count) {
                continue
            }
            if ($folderName -cnotmatch '^[a-z0-9]+(-[a-z0-9]+)*$') {
                throw "$testsRelative/$folderName/: a Go test folder is named for its catzc module in kebab case (lowercase, dots as hyphens, e.g. catzc-base-repository)."
            }
            $folders.Add($folderName)
        }
    }
    $folders.Sort([System.StringComparer]::Ordinal)

    $files = [System.Collections.Generic.List[Catzc.Base.Languages.GoWorkspaceFile]]::new()

    $work = [System.Collections.Generic.List[string]]::new()
    $work.Add("go $goVersion")
    if ($folders.Count -gt 0) {
        $work.Add('')
        $work.Add('use (')
        foreach ($folder in $folders) {
            $work.Add("`t./$testsRelative/$folder")
        }
        $work.Add(')')
    }
    $files.Add([Catzc.Base.Languages.GoWorkspaceFile]::new('go.work', ($work -join "`n") + "`n"))

    foreach ($folder in $folders) {
        $mod = [System.Collections.Generic.List[string]]::new()
        $mod.Add("module $($config.module_root)/$folder")
        $mod.Add('')
        $mod.Add("go $goVersion")
        if ($config.dependencies.Count -gt 0) {
            $mod.Add('')
            $mod.Add('require (')
            # GoConfig keeps the dependencies in ordinal path order.
            foreach ($dependency in $config.dependencies.GetEnumerator()) {
                $mod.Add("`t$($dependency.Key) $($dependency.Value)")
            }
            $mod.Add(')')
        }
        $files.Add([Catzc.Base.Languages.GoWorkspaceFile]::new("$testsRelative/$folder/go.mod", ($mod -join "`n") + "`n"))
    }

    foreach ($file in $files) {
        if ($file.Target -clike $Target) {
            $file
        }
    }
}
