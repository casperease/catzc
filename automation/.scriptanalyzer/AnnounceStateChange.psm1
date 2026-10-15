<#
---
catzc:
  derived:
    path: automation/.scriptanalyzer/AnnounceStateChange.psm1
    kind: analyzer-rule
---
#>

Set-StrictMode -Version Latest   # this module's scope: the rule runs strict inside the analyzer engine
. (Join-Path $PSScriptRoot 'Test-AnalyzedFileIsTest.ps1')   # the shared test-file scope check, in this module's scope

<#
.SYNOPSIS
    Custom PSScriptAnalyzer rule: a function that changes the session's state must announce it.
.DESCRIPTION
    The rule checks that a writer runs with the change, not what the line says; that wording stays a review concern.
    [comment:1](/docs/references/automation/scriptanalyzer/AnnounceStateChange.psm1.md#comment1)
#>

# Whether a command binds the named parameter.
function Test-CommandParameter {
    param($Command, [string] $ParameterName)
    foreach ($element in $Command.CommandElements) {
        if ($element -is [System.Management.Automation.Language.CommandParameterAst] -and $element.ParameterName -eq $ParameterName) {
            return $true
        }
    }
    $false
}

# The first positional argument is the element right after the command name, and only when it is not a parameter.
# [comment:2](/docs/references/automation/scriptanalyzer/AnnounceStateChange.psm1.md#comment2)
function Get-CommandArgument {
    param($Command, [string] $ParameterName)
    $elements = $Command.CommandElements
    for ($i = 1; $i -lt $elements.Count; $i++) {
        $element = $elements[$i]
        if ($element -isnot [System.Management.Automation.Language.CommandParameterAst] -or $element.ParameterName -ne $ParameterName) {
            continue
        }
        if ($element.Argument) {
            return $element.Argument
        }
        if ($i + 1 -lt $elements.Count) {
            return $elements[$i + 1]
        }
    }
    if ($elements.Count -gt 1 -and $elements[1] -isnot [System.Management.Automation.Language.CommandParameterAst]) {
        return $elements[1]
    }
    $null
}

# The literal text of an argument: a constant's value, otherwise its source text.
function Get-ArgumentText {
    param($Argument)
    if ($Argument -is [System.Management.Automation.Language.StringConstantExpressionAst]) {
        return $Argument.Value
    }
    $Argument.Extent.Text
}

# The statement block a writer call runs in — it announces every change inside that block.
function Get-WriterBlock {
    param($Node)
    $parent = $Node.Parent
    while ($null -ne $parent) {
        if ($parent -is [System.Management.Automation.Language.StatementBlockAst] -or
            $parent -is [System.Management.Automation.Language.NamedBlockAst]) {
            return $parent
        }
        $parent = $parent.Parent
    }
    $null
}

# Whether a node sits inside the given block.
function Test-NodeInside {
    param($Node, $Block)
    $parent = $Node.Parent
    while ($null -ne $parent) {
        if ($parent -eq $Block) {
            return $true
        }
        $parent = $parent.Parent
    }
    $false
}

function Measure-AnnounceStateChange {
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst] $ScriptBlockAst
    )

    if (Test-AnalyzedFileIsTest -ScriptBlockAst $ScriptBlockAst) {
        return @()
    }

    $results = [System.Collections.Generic.List[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]]::new()
    $ruleName = 'Measure-AnnounceStateChange'
    $writers = @('Write-Message', 'Write-InformationColored', 'Write-ImporterMessage')
    $otherRunspaceCommands = @('Start-Job', 'Start-ThreadJob')

    # $global:LASTEXITCODE (PowerShell's own) and $global:__<Name> (the toolset's private bookkeeping) are exempt.
    $isExemptGlobal = {
        param([string] $name)
        $name -eq 'lastexitcode' -or $name.StartsWith('__')
    }
    $environmentTypes = @('Environment', 'System.Environment')
    $assemblyTypes = @('Reflection.Assembly', 'System.Reflection.Assembly')
    $itemCommands = @('Set-Item', 'New-Item', 'Remove-Item', 'Clear-Item')
    $variableCommands = @('Set-Variable', 'New-Variable', 'Remove-Variable')
    $fixedTargets = @{
        'Add-Type'                    = 'binary'
        'Import-Module'               = 'module'
        'Remove-Module'               = 'module'
        'Push-Location'               = 'location'
        'Pop-Location'                = 'location'
        'Set-PSReadLineOption'        = 'line editor'
        'Set-PSReadLineKeyHandler'    = 'line editor'
        'Remove-PSReadLineKeyHandler' = 'line editor'
        'Update-TypeData'             = 'type data'
        'Update-FormatData'           = 'format data'
    }

    # Classify a node: the target it changes ('env:path', 'module', ...), or $null when it changes nothing.
    $getTarget = {
        param($node)
        if ($node -is [System.Management.Automation.Language.AssignmentStatementAst]) {
            $left = $node.Left
            if ($left -is [System.Management.Automation.Language.ConvertExpressionAst]) {
                $left = $left.Child
            }
            if ($left -isnot [System.Management.Automation.Language.VariableExpressionAst]) {
                return $null
            }
            $path = $left.VariablePath
            if ($path.DriveName -eq 'env') {
                return "env:$($path.UserPath.Substring(4).ToLowerInvariant())"
            }
            if ($path.IsGlobal) {
                $name = $path.UserPath.Substring(7).ToLowerInvariant()
                if (-not (& $isExemptGlobal $name)) {
                    return "global:$name"
                }
            }
            return $null
        }
        if ($node -is [System.Management.Automation.Language.InvokeMemberExpressionAst]) {
            $member = $node.Member.Extent.Text
            if ($node.Static -and $node.Expression -is [System.Management.Automation.Language.TypeExpressionAst]) {
                $typeName = $node.Expression.TypeName.FullName
                if ($typeName -in $environmentTypes -and $member -eq 'SetEnvironmentVariable' -and $node.Arguments) {
                    return "env:$((Get-ArgumentText $node.Arguments[0]).ToLowerInvariant())"
                }
                if ($typeName -in $assemblyTypes -and $member -in 'Load', 'LoadFrom', 'LoadFile', 'UnsafeLoadFrom') {
                    return 'binary'
                }
            }
            if ($member -in 'LoadFromAssemblyPath', 'LoadFromStream') {
                return 'binary'
            }
            return $null
        }
        if ($node -is [System.Management.Automation.Language.CommandAst]) {
            $name = $node.GetCommandName()
            if (-not $name) {
                return $null
            }
            if ($fixedTargets.ContainsKey($name)) {
                if ($name -eq 'Add-Type' -and (Test-CommandParameter $node 'OutputAssembly')) {
                    return $null
                }
                return $fixedTargets[$name]
            }
            if ($name -in $itemCommands) {
                $pathArgument = Get-CommandArgument $node 'Path'
                if (-not $pathArgument) {
                    $pathArgument = Get-CommandArgument $node 'LiteralPath'
                }
                if ($pathArgument) {
                    $pathText = Get-ArgumentText $pathArgument
                    if ($pathText -match '^env:(.+)$') {
                        return "env:$($Matches[1].ToLowerInvariant())"
                    }
                }
                return $null
            }
            if ($name -in $variableCommands) {
                if (-not (Test-CommandParameter $node 'Scope')) {
                    return $null
                }
                $scopeArgument = Get-CommandArgument $node 'Scope'
                $nameArgument = Get-CommandArgument $node 'Name'
                if ((Get-ArgumentText $scopeArgument) -eq 'Global' -and $nameArgument) {
                    $variableName = (Get-ArgumentText $nameArgument).ToLowerInvariant()
                    if (-not (& $isExemptGlobal $variableName)) {
                        return "global:$variableName"
                    }
                }
                return $null
            }
        }
        $null
    }

    # The scope a node belongs to: its innermost enclosing function, else the script's top level.
    $getScope = {
        param($node)
        $parent = $node.Parent
        while ($null -ne $parent) {
            if ($parent -is [System.Management.Automation.Language.FunctionDefinitionAst]) {
                return $parent
            }
            $parent = $parent.Parent
        }
        $ScriptBlockAst
    }

    # Another runspace or process owns that state, so a change in a literal job scriptblock is not this session's.
    # [comment:3](/docs/references/automation/scriptanalyzer/AnnounceStateChange.psm1.md#comment3)
    $isInOtherRunspace = {
        param($node)
        $parent = $node.Parent
        while ($null -ne $parent) {
            if ($parent -is [System.Management.Automation.Language.ScriptBlockExpressionAst]) {
                $owner = $parent.Parent
                if ($owner -is [System.Management.Automation.Language.CommandParameterAst]) {
                    $owner = $owner.Parent
                }
                if ($owner -is [System.Management.Automation.Language.CommandAst]) {
                    $ownerName = $owner.GetCommandName()
                    if ($ownerName -in $otherRunspaceCommands -or
                        ($ownerName -in 'ForEach-Object', '%', 'foreach' -and (Test-CommandParameter $owner 'Parallel'))) {
                        return $true
                    }
                }
            }
            $parent = $parent.Parent
        }
        $false
    }

    # Whether a node sits inside a finally block that belongs to the scope passed in.
    $isInFinally = {
        param($node, $scope)
        $child = $node
        $parent = $node.Parent
        while ($null -ne $parent -and $parent -ne $scope) {
            if ($parent -is [System.Management.Automation.Language.TryStatementAst] -and $parent.Finally -eq $child) {
                return $true
            }
            $child = $parent
            $parent = $parent.Parent
        }
        $false
    }

    # Predicates as locals, not inlined in FindAll's parens — dodges a cross-version indent skew.
    # [comment:4](/docs/references/automation/scriptanalyzer/AnnounceStateChange.psm1.md#comment4)
    $isCandidate = {
        param($node)
        $node -is [System.Management.Automation.Language.AssignmentStatementAst] -or
        $node -is [System.Management.Automation.Language.InvokeMemberExpressionAst] -or
        $node -is [System.Management.Automation.Language.CommandAst]
    }

    # Grouped per scope because a writer or a finally restore only counts inside its own or an enclosing block.
    # [comment:5](/docs/references/automation/scriptanalyzer/AnnounceStateChange.psm1.md#comment5)
    $changesByScope = [ordered]@{}
    $restoredByScope = @{}
    $coveredByScope = @{}
    foreach ($node in $ScriptBlockAst.FindAll($isCandidate, $true)) {
        $scope = & $getScope $node
        if ($node -is [System.Management.Automation.Language.CommandAst] -and $node.GetCommandName() -in $writers) {
            if (-not (Test-CommandParameter $node 'Verbose')) {
                if (-not $coveredByScope.ContainsKey($scope)) {
                    $coveredByScope[$scope] = [System.Collections.Generic.List[object]]::new()
                }
                $coveredByScope[$scope].Add((Get-WriterBlock $node))
            }
            continue
        }
        $target = & $getTarget $node
        if (-not $target -or (& $isInOtherRunspace $node)) {
            continue
        }
        if (-not $changesByScope.Contains($scope)) {
            $changesByScope[$scope] = [System.Collections.Generic.List[object]]::new()
            $restoredByScope[$scope] = [System.Collections.Generic.HashSet[string]]::new()
        }
        $changesByScope[$scope].Add([pscustomobject]@{ Node = $node; Target = $target })
        if (& $isInFinally $node $scope) {
            [void]$restoredByScope[$scope].Add($target)
        }
    }

    foreach ($scope in $changesByScope.Keys) {
        $coveredBlocks = if ($coveredByScope.ContainsKey($scope)) {
            $coveredByScope[$scope]
        }
        else {
            @()
        }
        $where = if ($scope -is [System.Management.Automation.Language.FunctionDefinitionAst]) {
            "function '$($scope.Name)'"
        }
        else {
            'the script''s top-level code'
        }
        foreach ($change in $changesByScope[$scope]) {
            if ($restoredByScope[$scope].Contains($change.Target)) {
                continue
            }
            $announced = $false
            foreach ($block in $coveredBlocks) {
                if (Test-NodeInside $change.Node $block) {
                    $announced = $true
                    break
                }
            }
            if ($announced) {
                continue
            }
            $results.Add([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                    Message  = "This changes the session state ($($change.Target)), but $where does not announce it where it happens. Announce every lasting state change with Write-Message, naming what changed (ADR-PWSH-ANNOUNCE#8) — or restore it in a finally block if it is temporary (ADR-PWSH-ANNOUNCE#9)."
                    Extent   = $change.Node.Extent
                    RuleName = $ruleName
                    Severity = 'Warning'
                })
        }
    }

    return $results.ToArray()
}

<#
.SYNOPSIS
    Custom PSScriptAnalyzer rule: persistent environment and registry writes go only through their seams.
.DESCRIPTION
    Persistent environment and registry writes go through one mockable seam, so only its own test touches real state.
    [comment:6](/docs/references/automation/scriptanalyzer/AnnounceStateChange.psm1.md#comment6)
#>
function Measure-PersistentWriteThroughSeam {
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst] $ScriptBlockAst
    )

    if (Test-AnalyzedFileIsTest -ScriptBlockAst $ScriptBlockAst) {
        return @()
    }

    $results = [System.Collections.Generic.List[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]]::new()
    $ruleName = 'Measure-PersistentWriteThroughSeam'
    $seams = @('Set-PermanentEnvironmentVariable', 'Set-EnvironmentPath')
    $environmentTypes = @('Environment', 'System.Environment')
    $registryCommands = @('Set-Item', 'New-Item', 'Remove-Item', 'Clear-Item',
        'Set-ItemProperty', 'New-ItemProperty', 'Remove-ItemProperty', 'Clear-ItemProperty')

    # Whether a node sits inside one of the seam functions themselves.
    $isInSeam = {
        param($node)
        $parent = $node.Parent
        while ($null -ne $parent) {
            if ($parent -is [System.Management.Automation.Language.FunctionDefinitionAst]) {
                return $parent.Name -in $seams
            }
            $parent = $parent.Parent
        }
        $false
    }

    # What a node writes persistently ('the User/Machine environment', 'the registry'), or $null.
    $getPersistentWrite = {
        param($node)
        if ($node -is [System.Management.Automation.Language.InvokeMemberExpressionAst]) {
            if (-not ($node.Static -and $node.Expression -is [System.Management.Automation.Language.TypeExpressionAst])) {
                return $null
            }
            if ($node.Expression.TypeName.FullName -notin $environmentTypes -or $node.Member.Extent.Text -ne 'SetEnvironmentVariable') {
                return $null
            }
            if (-not $node.Arguments -or $node.Arguments.Count -lt 3) {
                return $null
            }
            $scopeText = (Get-ArgumentText $node.Arguments[2]).Trim("'", '"')
            if ($scopeText -eq 'Process' -or $scopeText -match '^\[(System\.)?EnvironmentVariableTarget\]::Process$') {
                return $null
            }
            return 'the persistent environment'
        }
        if ($node -is [System.Management.Automation.Language.CommandAst] -and $node.GetCommandName() -in $registryCommands) {
            $pathArgument = Get-CommandArgument $node 'Path'
            if (-not $pathArgument) {
                $pathArgument = Get-CommandArgument $node 'LiteralPath'
            }
            if ($pathArgument -and (Get-ArgumentText $pathArgument) -match '^(HKCU:|HKLM:|Registry::)') {
                return 'the registry'
            }
        }
        $null
    }

    $isCandidate = {
        param($node)
        $node -is [System.Management.Automation.Language.InvokeMemberExpressionAst] -or
        $node -is [System.Management.Automation.Language.CommandAst]
    }

    foreach ($node in $ScriptBlockAst.FindAll($isCandidate, $true)) {
        $target = & $getPersistentWrite $node
        if (-not $target -or (& $isInSeam $node)) {
            continue
        }
        $results.Add([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                Message  = "This writes $target directly. Go through the seam — Set-PermanentEnvironmentVariable for a persistent variable, Set-EnvironmentPath for the persistent PATH — so a logic test can mock it and only the seam's own system test (L3) touches the machine (ADR-AUTO-TEST#33)."
                Extent   = $node.Extent
                RuleName = $ruleName
                Severity = 'Warning'
            })
    }

    return $results.ToArray()
}

Export-ModuleMember -Function Measure-*
