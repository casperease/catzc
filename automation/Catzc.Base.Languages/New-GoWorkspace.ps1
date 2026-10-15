<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Languages/New-GoWorkspace.ps1
    kind: function
    module: Catzc.Base.Languages
    visibility: public
    adrs:
      - ADR-CONF-ADDRESSING
      - ADR-REPO-ROOTCFG
---
#>

<#
.SYNOPSIS
    Renders the Go test workspace — the repository-root go.work and each <root>/tests/<folder>/go.mod — from
    configs/go.yml.
.DESCRIPTION
    Rendering is pure text, identical on every machine; Build-RootConfig owns the write, so this writes nothing.
    [comment:1](/docs/references/automation/catzc-base-languages/New-GoWorkspace.ps1.md#comment1)
.PARAMETER Target
    The match is case-sensitive, so a pattern in the wrong case returns no files.
    [comment:2](/docs/references/automation/catzc-base-languages/New-GoWorkspace.ps1.md#comment2)
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
    # Reading the tools.yml pin keeps the go directive from asking for a newer toolchain than the managed go.
    # [comment:3](/docs/references/automation/catzc-base-languages/New-GoWorkspace.ps1.md#comment3)
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
        foreach ($folder in @(Get-ChildItem -LiteralPath $testsRoot -Directory)) {
            if ($folder.Name.StartsWith('.')) {
                continue
            }
            if (-not @(Get-ChildItem -LiteralPath $folder.FullName -Filter '*.go' -File -Recurse).Count) {
                continue
            }
            if ($folder.Name -cnotmatch '^[a-z0-9]+(-[a-z0-9]+)*$') {
                throw "$testsRelative/$($folder.Name)/: a Go test folder is named for its catzc module in kebab case (lowercase, dots as hyphens, e.g. catzc-base-repository)."
            }
            $folders.Add($folder.Name)
        }
    }
    $folders.Sort([System.StringComparer]::Ordinal)

    [string[]] $header = @(
        '// GENERATED FILE — do not edit. Single source of truth:'
        "//   automation/Catzc.Base.Languages/configs/go.yml (rendered by New-GoWorkspace over the $testsRelative/*/ folders)"
        '//   the go directive: the go pin in automation/Catzc.Base.Execution/configs/tools.yml'
        '// Regenerated on import by Build-RootConfig; edit the yml or the folders, not this file.'
    )

    $files = [System.Collections.Generic.List[Catzc.Base.Languages.GoWorkspaceFile]]::new()

    $work = [System.Collections.Generic.List[string]]::new($header)
    $work.Add('')
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
        $mod = [System.Collections.Generic.List[string]]::new($header)
        $mod.Add('')
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
