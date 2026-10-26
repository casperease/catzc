<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-module-system/Get-InternalAssetDependency.ps1.md"
  header: "generated"
---
#>

function Get-InternalAssetDependency {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $ModulesRoot = (Get-CatzcModulesRoot),

        [string[]] $Module,

        [switch] $Violation,

        [Catzc.Base.Repository.ParsedScripts] $ParsedScripts = [Catzc.Base.Repository.ParsedScripts]::new()
    )

    Assert-SourceTree
    Assert-PathExist $ModulesRoot -PathType Container
    # The repository-relative labels name the modules folder by the root's own name, never a literal.
    $modulesFolder = [System.IO.Path]::GetFileName($ModulesRoot.TrimEnd('\', '/'))

    $helperName = 'Get-CatzcModuleRoot'
    $helperParameters = (Get-Command $helperName -CommandType Function).Parameters
    $resolveParameter = {
        param([string] $Name)
        $match = @($helperParameters.Values | Where-Object { $_.Name -ieq $Name -or $_.Aliases -icontains $Name })
        if ($match.Count -eq 0) {
            $match = @($helperParameters.Values | Where-Object { $_.Name.StartsWith($Name,
                        [System.StringComparison]::OrdinalIgnoreCase) })
        }
        if ($match.Count -eq 1) {
            return $match[0]
        }
        $null
    }

    # A record names its module by its full name; the folder, which drops the namespace, builds the paths.
    $moduleFolders = @(
        Get-ChildPath $ModulesRoot -Depth 1 -Directory |
            Where-Object { -not [System.IO.Path]::GetFileName($_).StartsWith('.') } |
            ForEach-Object { [pscustomobject]@{ Folder = [System.IO.Path]::GetFileName($_); Name = (Get-ModuleFolderFullName $_) } } |
            Where-Object { -not $Module -or $_.Name -in $Module }
    )

    $records = [System.Collections.Generic.List[object]]::new()
    $violations = [System.Collections.Generic.List[object]]::new()

    $walk = Get-Config -Config folder-walk
    $privateFolderName = (Get-Config -Config languages).FolderOf('private-function')
    foreach ($moduleFolder in $moduleFolders) {
        $moduleName = $moduleFolder.Name
        $folderName = $moduleFolder.Folder
        $moduleDirectory = Join-Path $ModulesRoot $folderName
        $files = [System.Collections.Generic.List[object]]::new()
        foreach ($path in [Catzc.Base.Folders.PathSet]::new($walk).AddPattern($moduleDirectory, '*.ps1', 1).ToArray()) {
            $files.Add([pscustomobject]@{ Path = $path; Relative = "$modulesFolder/$folderName/$([System.IO.Path]::GetFileName($path))" })
        }
        $privateDirectory = Join-Path $moduleDirectory $privateFolderName
        foreach ($path in [Catzc.Base.Folders.PathSet]::new($walk).AddPattern($privateDirectory, '*.ps1',
                1).ToArray()) {
            $files.Add([pscustomobject]@{ Path = $path; Relative = "$modulesFolder/$folderName/$privateFolderName/$([System.IO.Path]::GetFileName($path))" })
        }

        foreach ($file in ($files | Sort-Object Relative)) {
            $syntaxTree = $ParsedScripts.Get($file.Path).Ast

            foreach ($call in [Catzc.Base.Repository.SyntaxSearch]::CommandsNamed($syntaxTree, $helperName, $true)) {
                # The enclosing function (one function per file); a top-level call falls back to the file name.
                $owner = $call.Parent
                while ($owner -and $owner -isnot [System.Management.Automation.Language.FunctionDefinitionAst]) {
                    $owner = $owner.Parent
                }
                $functionName = if ($owner) {
                    $owner.Name
                }
                else {
                    [System.IO.Path]::GetFileNameWithoutExtension($file.Path)
                }

                # Bind the arguments: named -ChildPath / -Module (space or colon form), else the first positional.
                $childPathValue = $null
                $moduleValue = $null
                $reasons = [System.Collections.Generic.List[string]]::new()
                $positional = [System.Collections.Generic.List[object]]::new()
                $elements = $call.CommandElements
                for ($i = 1; $i -lt $elements.Count; $i++) {
                    $element = $elements[$i]
                    if ($element -is [System.Management.Automation.Language.CommandParameterAst]) {
                        $parameter = & $resolveParameter $element.ParameterName
                        $value = $element.Argument
                        $takesValue = $parameter -and $parameter.ParameterType -ne [System.Management.Automation.SwitchParameter]
                        if (-not $value -and $takesValue -and ($i + 1) -lt $elements.Count) {
                            $i++
                            $value = $elements[$i]
                        }
                        if ($parameter -and $parameter.Name -eq 'ChildPath') {
                            $childPathValue = $value
                        }
                        elseif ($parameter -and $parameter.Name -eq 'Module') {
                            $moduleValue = $value
                        }
                        continue
                    }
                    if ($element -is [System.Management.Automation.Language.VariableExpressionAst] -and
                        $element.Splatted) {
                        $reasons.Add("splatted arguments (@$($element.VariablePath.UserPath)) hide -ChildPath and -Module")
                        continue
                    }
                    $positional.Add($element)
                }
                if (-not $childPathValue -and $positional.Count -gt 0) {
                    $childPathValue = $positional[0]
                }

                $childPath = $null
                if ($childPathValue) {
                    if ($childPathValue -is [System.Management.Automation.Language.StringConstantExpressionAst]) {
                        $childPath = $childPathValue.Value
                    }
                    else {
                        $reasons.Add("-ChildPath is not a string literal ($($childPathValue.Extent.Text))")
                    }
                }

                $targetModule = $moduleName
                if ($moduleValue) {
                    if ($moduleValue -is [System.Management.Automation.Language.StringConstantExpressionAst]) {
                        $targetModule = $moduleValue.Value
                    }
                    else {
                        $reasons.Add("-Module is not a string literal ($($moduleValue.Extent.Text))")
                    }
                }

                if ($reasons.Count -gt 0) {
                    $violations.Add([pscustomobject]@{
                            Module     = $moduleName
                            Function   = $functionName
                            File       = $file.Relative
                            Line       = $call.Extent.StartLineNumber
                            Expression = $call.Extent.Text
                            Reason     = $reasons -join '; '
                        })
                    continue
                }

                $records.Add([pscustomobject]@{
                        Module    = $targetModule
                        Function  = $functionName
                        ChildPath = $childPath
                        File      = $file.Relative
                        Line      = $call.Extent.StartLineNumber
                    })
            }
        }
    }

    if ($Violation) {
        return $violations.ToArray()
    }

    if ($violations.Count -gt 0) {
        $listing = ($violations | ForEach-Object { "  $($_.File):$($_.Line) $($_.Function) — $($_.Reason)" }) -join "`n"
        throw ("Get-InternalAssetDependency: $($violations.Count) Get-CatzcModuleRoot call site(s) cannot be inventoried — " +
            "-ChildPath and -Module must be string literals (ADR-AUTO-ASSETDEP-LITERALCHILDPATH):`n$listing")
    }

    $records.ToArray()
}
