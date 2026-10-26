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

        [Catzc.Base.Repository.ParsedScripts] $ParsedScripts = [Catzc.Base.Repository.ParsedScripts]::new()
    )

    $sourceFolder = [System.IO.Path]::GetFileName($SourceRoot.TrimEnd('\', '/'))
    $selected = [System.Collections.Generic.HashSet[string]]::new([string[]] @($Module),
        [System.StringComparer]::Ordinal)

    foreach ($call in @(Get-FunctionDependency -ModulesRoot $SourceRoot -ParsedScripts $ParsedScripts)) {
        if ($call.CrossModule -and $selected.Contains($call.CallerModule) -and
            -not $selected.Contains($call.TargetModule)) {
            "$sourceFolder/$($call.CallerModule)/$($call.CallerFile):$($call.CallerLine): $($call.CallerFunction) calls $($call.TargetFunction), which $($call.TargetModule) owns"
        }
    }

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
                        $owner = [System.IO.Path]::GetFileName($directory)
                        if (-not $owner.StartsWith('.') -and
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
