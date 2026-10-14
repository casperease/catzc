<#
.SYNOPSIS
    Renders the Go test workspace — the root go.work and each go/tests/<folder>/go.mod — from configs/go.yml.
.DESCRIPTION
    Discovers the Go test folders (the immediate, non-dot-prefixed subdirectories of go/tests/ that hold at least
    one .go file; each is one Go module, named for its catzc module in kebab case) and renders:

      go.work                  the go directive and one `use` entry per folder;
      go/tests/<folder>/go.mod the module path <module_root>/<folder>, the go directive, and one require line per
                               declared dependency.

    The settings come from configs/go.yml (Get-Config -Config go, typed as GoConfig). Folders and dependencies are
    sorted ordinally and every file is LF with one trailing newline, so the same tree and config render the same
    bytes on every machine. Rendering is pure text: offline, with no call to the go tool.

    This is a pure renderer: it returns the content and writes nothing. It is the `generator` the root-config
    registry names for the go.work and go/tests/*/go.mod targets, and Build-RootConfig owns the write
    ([ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md)). One call renders every file, so a
    registry entry selects its files with -Target.
.PARAMETER Target
    Return only the files whose repository-relative path matches this wildcard pattern (e.g. 'go.work' or
    'go/tests/*/go.mod'). Default: every file.
.OUTPUTS
    [Catzc.Base.Languages.GoWorkspaceFile] One record per rendered file ({ Target; Content }): go.work first,
    then each go.mod in folder order.
.EXAMPLE
    New-GoWorkspace
.EXAMPLE
    (New-GoWorkspace -Target 'go.work').Content
#>
function New-GoWorkspace {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Languages.GoWorkspaceFile])]
    param(
        [string] $Target = '*'
    )

    $config = Get-Config -Config go
    $testsRoot = Join-Path (Get-RepositoryRoot) 'go/tests'

    # One Go module per folder that holds Go code; a folder left with only generated files is not a module.
    $folders = [System.Collections.Generic.List[string]]::new()
    if (Test-Path -LiteralPath $testsRoot -PathType Container) {
        foreach ($folder in @(Get-ChildItem -LiteralPath $testsRoot -Directory)) {
            if ($folder.Name.StartsWith('.')) {
                continue
            }
            if (-not @(Get-ChildItem -LiteralPath $folder.FullName -Filter '*.go' -File -Recurse).Count) {
                continue
            }
            if ($folder.Name -cnotmatch '^[a-z0-9]+(-[a-z0-9]+)*$') {
                throw "go/tests/$($folder.Name)/: a Go test folder is named for its catzc module in kebab case (lowercase, dots as hyphens, e.g. catzc-base-repository)."
            }
            $folders.Add($folder.Name)
        }
    }
    $folders.Sort([System.StringComparer]::Ordinal)

    [string[]] $header = @(
        '// GENERATED FILE — do not edit. Single source of truth:'
        '//   automation/Catzc.Base.Languages/configs/go.yml (rendered by New-GoWorkspace over the go/tests/*/ folders)'
        '// Regenerated on import by Build-RootConfig; edit the yml or the folders, not this file.'
    )

    $files = [System.Collections.Generic.List[Catzc.Base.Languages.GoWorkspaceFile]]::new()

    $work = [System.Collections.Generic.List[string]]::new($header)
    $work.Add('')
    $work.Add("go $($config.go_version)")
    if ($folders.Count -gt 0) {
        $work.Add('')
        $work.Add('use (')
        foreach ($folder in $folders) {
            $work.Add("`t./go/tests/$folder")
        }
        $work.Add(')')
    }
    $files.Add([Catzc.Base.Languages.GoWorkspaceFile]::new('go.work', ($work -join "`n") + "`n"))

    foreach ($folder in $folders) {
        $mod = [System.Collections.Generic.List[string]]::new($header)
        $mod.Add('')
        $mod.Add("module $($config.module_root)/$folder")
        $mod.Add('')
        $mod.Add("go $($config.go_version)")
        if ($config.dependencies.Count -gt 0) {
            $mod.Add('')
            $mod.Add('require (')
            # GoConfig keeps the dependencies in ordinal path order.
            foreach ($dependency in $config.dependencies.GetEnumerator()) {
                $mod.Add("`t$($dependency.Key) $($dependency.Value)")
            }
            $mod.Add(')')
        }
        $files.Add([Catzc.Base.Languages.GoWorkspaceFile]::new("go/tests/$folder/go.mod", ($mod -join "`n") + "`n"))
    }

    foreach ($file in $files) {
        if ($file.Target -like $Target) {
            $file
        }
    }
}
