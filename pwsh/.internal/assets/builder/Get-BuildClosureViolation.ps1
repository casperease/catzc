function Get-BuildClosureViolation {
    # .SYNOPSIS
    #     Returns every call and config read of the selected modules that lands outside the selection.
    # .DESCRIPTION
    #     Proves the closure from the code, because dependencies.yml leaves an unlisted module unconstrained.
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $SourceRoot,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $Module,

        [Parameter(Mandatory)]
        [System.Collections.Generic.Dictionary[string, bool]] $Index,

        [Catzc.Base.Repository.ParsedScripts] $ParsedScripts = [Catzc.Base.Repository.ParsedScripts]::new(),

        # The language module rows the build plan ships.
        [object[]] $Language = @()
    )

    $sourceFolder = [System.IO.Path]::GetFileName($SourceRoot.TrimEnd('\', '/'))
    $selected = [System.Collections.Generic.HashSet[string]]::new([string[]] @($Module),
        [System.StringComparer]::Ordinal)

    # The dependency scan and the folders name modules by folder; the selection names them in full
    # ([DDR-TRACK-MODULENAMESPACE](/docs/drs/design/tracks.md#rule-ddr-track-modulenamespace)).
    $moduleNamespace = Get-ModuleNamespace -ModulesRoot $SourceRoot
    foreach ($call in @(Get-FunctionDependency -ModulesRoot $SourceRoot -ParsedScripts $ParsedScripts)) {
        $caller = Resolve-ModuleName -Folder $call.CallerModule -Namespace $moduleNamespace
        $target = Resolve-ModuleName -Folder $call.TargetModule -Namespace $moduleNamespace
        if ($call.CrossModule -and $selected.Contains($caller) -and -not $selected.Contains($target)) {
            "$sourceFolder/$($call.CallerModule)/$($call.CallerFile):$($call.CallerLine): $($call.CallerFunction) calls $($call.TargetFunction), which $target owns"
        }
    }

    # A language module is reached by its literal <track>/<Module> path, so the paths come from the tracks, never spelled here.
    $languagePaths = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($track in @(Get-Track)) {
        if ($track.type -cne 'modules') {
            continue
        }
        foreach ($languageModule in @(Get-CatzcModule -Track $track.name)) {
            if ($languageModule.shape -ceq 'folder') {
                [void] $languagePaths.Add(([string] $languageModule.root).Replace('\', '/').TrimEnd('/'))
            }
        }
    }
    $shippedPaths = [System.Collections.Generic.HashSet[string]]::new([string[]] @($Language | ForEach-Object { $_.Source }),
        [System.StringComparer]::Ordinal)
    $declaredModules = (Get-Config -Config dependencies).modules

    foreach ($name in $Module) {
        $moduleDirectory = [System.IO.Path]::Combine($SourceRoot, (Resolve-ModuleName -FullName $name -Namespace (Get-ModuleNamespace -ModulesRoot $SourceRoot)))
        if (-not [System.IO.Directory]::Exists($moduleDirectory)) {
            continue
        }
        # A module's scripts sit at most three levels below its folder (tests/types/ is the deepest).
        foreach ($file in Get-ChildPath $moduleDirectory -File -Filter '*.ps1' -Depth 3) {
            $relativePath = [System.IO.Path]::GetRelativePath($SourceRoot, $file).Replace('\', '/')
            if ($relativePath.EndsWith('.Tests.ps1', [System.StringComparison]::OrdinalIgnoreCase) -or
                $relativePath.StartsWith("$name/tests/", [System.StringComparison]::Ordinal) -or
                -not $Index.ContainsKey($relativePath)) {
                continue
            }
            $syntaxTree = $ParsedScripts.Get($file).Ast
            $strings = $syntaxTree.FindAll({ param($node) $node -is [System.Management.Automation.Language.StringConstantExpressionAst] }, $true)
            foreach ($string in $strings) {
                foreach ($path in $languagePaths) {
                    if ($string.Value -cne $path -and -not $string.Value.StartsWith("$path/", [System.StringComparison]::Ordinal)) {
                        continue
                    }
                    $where = "$sourceFolder/${relativePath}:$($string.Extent.StartLineNumber)"
                    $declared = @(if ($declaredModules.Contains($name)) {
                            $declaredModules[$name]
                        })
                    if ($path -cnotin $declared) {
                        "${where}: $name reaches the language module '$path', which its dependencies.yml row does not declare; add '$path' to the $name row"
                    }
                    elseif (-not $shippedPaths.Contains($path)) {
                        "${where}: $name reaches the language module '$path', which the build does not ship; select a module that declares it"
                    }
                }
            }
            foreach ($read in [Catzc.Base.Repository.SyntaxSearch]::CommandsNamed($syntaxTree, 'Get-Config', $false)) {
                $elements = $read.CommandElements
                # -ListOwners / -Module read a config that many modules may ship, owner by owner: only the owners
                # present are read, so an owner missing from the build is not a gap.
                $isOwnerScoped = @($elements | Where-Object {
                        $_ -is [System.Management.Automation.Language.CommandParameterAst] -and $_.ParameterName -in 'ListOwners', 'Module'
                    }).Count -gt 0
                if ($isOwnerScoped) {
                    continue
                }
                $argument = $null
                for ($position = 1; $position -lt $elements.Count; $position++) {
                    $element = $elements[$position]
                    if ($element -is [System.Management.Automation.Language.CommandParameterAst]) {
                        if ($element.ParameterName -ieq 'Config' -and $position + 1 -lt $elements.Count) {
                            $argument = $elements[$position + 1]
                        }
                        break
                    }
                    $argument = $element
                    break
                }
                if ($argument -isnot [System.Management.Automation.Language.StringConstantExpressionAst]) {
                    continue
                }
                $config = $argument.Value
                $owners = @(foreach ($directory in [System.IO.Directory]::GetDirectories($SourceRoot)) {
                        $ownerFolder = [System.IO.Path]::GetFileName($directory)
                        $owner = Resolve-ModuleName -Folder $ownerFolder -Namespace $moduleNamespace
                        if (-not $ownerFolder.StartsWith('.') -and
                            [System.IO.File]::Exists([System.IO.Path]::Combine($directory, 'configs', "$config.yml"))) {
                            $owner
                        }
                    })
                if ($owners.Count -gt 0 -and -not @($owners | Where-Object { $selected.Contains($_) })) {
                    "$sourceFolder/${relativePath}:$($read.Extent.StartLineNumber): reads config '$config', which $($owners -join ', ') owns"
                }
            }
        }
    }
}
