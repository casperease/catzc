<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-languages/New-GoWorkspace.ps1.md"
  header: "generated"
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
    $goRelative = $config.ResolveRoot($repositoryRoot)
    $testsRelative = "$goRelative/tests"
    $testsRoot = Join-Path $repositoryRoot $testsRelative
    $go = @((Get-Config -Config languages).languages.Where({ $_.name -ceq 'go' }, 'First'))
    $naming = $go.Count ? $go[0].naming : $null

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
            if ($null -ne $naming -and -not $naming.IsFolderIdiomatic($folderName)) {
                throw "$testsRelative/$folderName/: a Go test folder is named for its catzc module in go's folder case, $($naming.folder -join ' or ') case."
            }
            $folders.Add($folderName)
        }
    }
    $folders.Sort([System.StringComparer]::Ordinal)

    # One Go module per module folder of the track: a folder the module-type registry names as a module, holding Go
    # code.
    $modules = [System.Collections.Generic.List[string]]::new()
    $goRoot = Join-Path $repositoryRoot $goRelative
    if (Test-Path -LiteralPath $goRoot -PathType Container) {
        foreach ($folderPath in @(Get-ChildPath $goRoot -Directory -Depth 1)) {
            $folderName = [System.IO.Path]::GetFileName($folderPath)
            $placed = Get-PathModule "$goRelative/$folderName/_"
            if ($null -eq $placed -or $placed.name -cne $folderName) {
                continue
            }
            if (-not @(Get-ChildPath $folderPath -File -Filter '*.go' -Depth 3).Count) {
                continue
            }
            $modules.Add($folderName)
        }
    }
    $modules.Sort([System.StringComparer]::Ordinal)

    # The members: the test holder's folders under tests/, then the modules, each with its module path under
    # module_root.
    $members = @(foreach ($folder in $folders) {
            [pscustomobject]@{ Folder = "$testsRelative/$folder"; Path = "$($config.module_root)/tests/$folder" }
        }) +
    @(foreach ($module in $modules) {
            [pscustomobject]@{ Folder = "$goRelative/$module"; Path = "$($config.module_root)/$module" }
        })

    $files = [System.Collections.Generic.List[Catzc.Base.Languages.GoWorkspaceFile]]::new()

    $work = [System.Collections.Generic.List[string]]::new()
    $work.Add("go $goVersion")
    if ($members.Count -gt 0) {
        $work.Add('')
        $work.Add('use (')
        foreach ($member in $members) {
            $work.Add("`t./$($member.Folder)")
        }
        $work.Add(')')
    }
    $files.Add([Catzc.Base.Languages.GoWorkspaceFile]::new('go.work', ($work -join "`n") + "`n"))

    foreach ($member in $members) {
        $mod = [System.Collections.Generic.List[string]]::new()
        $mod.Add("module $($member.Path)")
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
        $files.Add([Catzc.Base.Languages.GoWorkspaceFile]::new("$($member.Folder)/go.mod", ($mod -join "`n") + "`n"))
    }

    foreach ($file in $files) {
        if ($file.Target -clike $Target) {
            $file
        }
    }
}
