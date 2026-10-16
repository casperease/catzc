<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.ModuleSystem/Get-InternalAssetDependency.ps1
    name: get-internal-asset-dependency
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.ModuleSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-base-modulesystem/Get-InternalAssetDependency.ps1.md
    test: automation/Catzc.Base.ModuleSystem/tests/Get-InternalAssetDependency.Tests.ps1
    cites:
      - ADR-AUTO-ASSETDEP#2
      - ADR-DSGN-RUNMODE
  config:
    synopsis: Lists every internal asset dependency in the module code — one record per Get-CatzcModuleRoot call site.
    description: |-
      The inventory of [ADR-AUTO-ASSETDEP#2](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep2),
      derived from the code: the code is the registration, so there is no
      separate list to keep in step. Parses every module function file — the .ps1 files at a module folder's root
      and in its private/ folder, never tests/ or assets/ — and finds each call to Get-CatzcModuleRoot. Each call
      site becomes one record:

          Module     the module whose folder the call resolves under: the -Module literal when the call passes
                     one (a cross-module read), otherwise the module that holds the file
          Function   the function that makes the call
          ChildPath  the -ChildPath literal (positional argument 0 or -ChildPath); $null when the call names the
                     module folder itself
          File       the file, repository-relative (automation/<Module>/...)
          Line       the line of the call

      -ChildPath must be a string literal at every call site
      ([ADR-AUTO-ASSETDEP#2](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep2)), and so must
      -Module when it
      is passed. A call whose value is computed — a variable, an expandable string, a subexpression, or a splat
      that hides the arguments — cannot be inventoried. Such a call site is a violation: by default the command
      throws, naming every violating site, so the inventory is never silently partial. -Violation returns the
      violating sites instead of the inventory, without throwing.

      Reads the per-function source files, which exist only in the source tree, so it stops with a named error
      in build mode (Assert-SourceTree, [ADR-DSGN-RUNMODE](/docs/adr/design/run-modes.md)).
    parameters:
      AutomationRoot: Path to the automation directory to scan. Defaults to the loaded code root (Get-CatzcModulesRoot).
      Module: 'Scan only these module folders. Default: every module folder (non-dot) under the automation root.'
      Violation: |-
        Return the call sites whose -ChildPath or -Module is not a string literal ({ Module; Function; File; Line;
        Expression; Reason }) instead of the inventory, and do not throw.
      ParsedScripts: |-
        The call's shared parse of each script; a caller running several checks over the same files passes one so a
        file is parsed once.
    outputs: |-
      [pscustomobject] One record per call site: Module, Function, ChildPath, File, Line (with -Violation, one
      record per violating call site instead).
    examples:
      - Get-InternalAssetDependency | Format-Table Module, ChildPath, Function
      - Get-InternalAssetDependency -Violation
---
#>

function Get-InternalAssetDependency {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $AutomationRoot = (Get-CatzcModulesRoot),

        [string[]] $Module,

        [switch] $Violation,

        [Catzc.Base.Repository.ParsedScripts] $ParsedScripts = [Catzc.Base.Repository.ParsedScripts]::new()
    )

    Assert-SourceTree
    Assert-PathExist $AutomationRoot -PathType Container

    $helperName = 'Get-CatzcModuleRoot'
    $helperParameters = (Get-Command $helperName -CommandType Function).Parameters
    $resolveParameter = {
        param([string] $Name)
        $match = @($helperParameters.Values | Where-Object { $_.Name -ieq $Name -or $_.Aliases -icontains $Name })
        if ($match.Count -eq 0) {
            $match = @($helperParameters.Values | Where-Object { $_.Name.StartsWith($Name, [System.StringComparison]::OrdinalIgnoreCase) })
        }
        if ($match.Count -eq 1) {
            return $match[0]
        }
        $null
    }

    $moduleNames = [string[]] @(
        [System.IO.Directory]::EnumerateDirectories($AutomationRoot) |
            ForEach-Object { [System.IO.Path]::GetFileName($_) } |
            Where-Object { -not $_.StartsWith('.') -and (-not $Module -or $_ -in $Module) }
    )
    [System.Array]::Sort($moduleNames, [System.StringComparer]::Ordinal)

    $records = [System.Collections.Generic.List[object]]::new()
    $violations = [System.Collections.Generic.List[object]]::new()

    foreach ($moduleName in $moduleNames) {
        $moduleDirectory = Join-Path $AutomationRoot $moduleName
        $files = [System.Collections.Generic.List[object]]::new()
        foreach ($path in [System.IO.Directory]::EnumerateFiles($moduleDirectory, '*.ps1')) {
            $files.Add([pscustomobject]@{ Path = $path; Relative = "automation/$moduleName/$([System.IO.Path]::GetFileName($path))" })
        }
        $privateDirectory = Join-Path $moduleDirectory 'private'
        if ([System.IO.Directory]::Exists($privateDirectory)) {
            foreach ($path in [System.IO.Directory]::EnumerateFiles($privateDirectory, '*.ps1')) {
                $files.Add([pscustomobject]@{ Path = $path; Relative = "automation/$moduleName/private/$([System.IO.Path]::GetFileName($path))" })
            }
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
                    if ($element -is [System.Management.Automation.Language.VariableExpressionAst] -and $element.Splatted) {
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
            "-ChildPath and -Module must be string literals (ADR-AUTO-ASSETDEP#2):`n$listing")
    }

    $records.ToArray()
}
