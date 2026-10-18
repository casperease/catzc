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
