<#
---
catzc:
  derived:
    path: automation/Catzc.Base.ModuleSystem/tests/New-Importer.Tests.ps1
    kind: test
---
#>

Describe 'New-Importer' -Tag 'L0', 'logic', 'source-only' {
    BeforeAll {
        $script:realOverlay = Join-Path (Get-RepositoryRoot) 'automation/.internal/Catzc.Internal.Importer.psm1'
        Mock Write-Message -ModuleName Catzc.Base.ModuleSystem { }
    }

    BeforeEach {
        # A sandbox repo root carrying only the real overlay at its conventional path.
        $script:sandbox = Join-Path $TestDrive ([System.IO.Path]::GetRandomFileName())
        $overlayDir = Join-Path $script:sandbox 'automation/.internal'
        New-Item -ItemType Directory -Path $overlayDir -Force | Out-Null
        Copy-Item $script:realOverlay (Join-Path $overlayDir 'Catzc.Internal.Importer.psm1')
    }

    It 'writes importer.ps1 into the target root and returns its path' {
        $path = New-Importer -RepositoryRoot $script:sandbox
        $path | Should -Be (Join-Path $script:sandbox 'importer.ps1')
        Test-Path $path | Should -BeTrue
    }

    It 'refuses to overwrite an existing importer.ps1 without -Force' {
        New-Importer -RepositoryRoot $script:sandbox | Out-Null
        { New-Importer -RepositoryRoot $script:sandbox } | Should -Throw '*already exists*'
    }

    It 'overwrites an existing importer.ps1 with -Force' {
        New-Importer -RepositoryRoot $script:sandbox | Out-Null
        { New-Importer -RepositoryRoot $script:sandbox -Force } | Should -Not -Throw
    }

    It 'throws when the overlay is absent' {
        $empty = Join-Path $TestDrive ([System.IO.Path]::GetRandomFileName())
        New-Item -ItemType Directory -Path $empty -Force | Out-Null
        { New-Importer -RepositoryRoot $empty } | Should -Throw '*overlay not found*'
    }

    It 'generates a shim that parses cleanly and delegates to Invoke-Importer' {
        $content = New-Importer -RepositoryRoot $script:sandbox -DryRun
        $errors = $null
        [System.Management.Automation.Language.Parser]::ParseInput($content, [ref] $null, [ref] $errors) | Out-Null
        $errors | Should -BeNullOrEmpty
        $content | Should -Match 'Invoke-Importer @PSBoundParameters'
    }

    It 'generates an advanced shim, so -Verbose binds and is forwarded to Invoke-Importer' {
        $content = New-Importer -RepositoryRoot $script:sandbox -DryRun
        $ast = [System.Management.Automation.Language.Parser]::ParseInput($content, [ref] $null, [ref] $null)
        $ast.ParamBlock.Attributes.TypeName.Name | Should -Contain 'CmdletBinding'
    }
}

Describe 'New-Importer — build mode' -Tag 'L0', 'logic' {
    It 'stops with a named error when the session runs a built package' {
        Mock Get-CatzcRunMode { 'build' } -ModuleName Catzc.Base.Repository
        { New-Importer -RepositoryRoot $TestDrive -DryRun } | Should -Throw '*New-Importer operates on the catzc source tree*'
    }
}

Describe 'New-Importer — importer.ps1 drift guard' -Tag 'L2', 'integrity', 'source-only' {
    # The committed importer.ps1 is generated from the Invoke-Importer overlay. These guard the two ways it can
    # drift: its parameter set must equal the overlay's (signature = parameter set, no tagging), and its whole
    # content must equal New-Importer's output. To fix a failure, run New-Importer -Force and commit importer.ps1.
    BeforeAll {
        $script:repoRoot = Get-RepositoryRoot
        $script:importer = Join-Path $script:repoRoot 'importer.ps1'
        $script:overlay = Join-Path $script:repoRoot 'automation/.internal/Catzc.Internal.Importer.psm1'

        # The '<name> [<type-as-written>]' list of a param block — the script's own (FunctionName $null) or a
        # named function's within a module file. AST parse, so the overlay need not be loaded.
        function script:Get-ParamSignature {
            param([string] $Path, [string] $FunctionName)
            $ast = [System.Management.Automation.Language.Parser]::ParseFile($Path, [ref] $null, [ref] $null)
            $block = if ($FunctionName) {
                $ast.Find({
                        param($node)
                        $node -is [System.Management.Automation.Language.FunctionDefinitionAst] -and $node.Name -eq $FunctionName
                    }, $true).Body.ParamBlock
            }
            else {
                $ast.ParamBlock
            }
            $isTypeConstraint = { $_ -is [System.Management.Automation.Language.TypeConstraintAst] }
            foreach ($parameter in $block.Parameters) {
                $typeConstraint = $parameter.Attributes.Where($isTypeConstraint) | Select-Object -First 1
                '{0} [{1}]' -f $parameter.Name.VariablePath.UserPath, $typeConstraint.TypeName.Name
            }
        }
    }

    It 'importer.ps1 parameter set equals the Invoke-Importer overlay (signature = parameter set)' {
        $shim = (@(Get-ParamSignature $script:importer $null) | Sort-Object) -join "`n"
        $overlay = (@(Get-ParamSignature $script:overlay 'Invoke-Importer') | Sort-Object) -join "`n"
        $shim | Should -BeExactly $overlay
    }

    It 'committed importer.ps1 equals New-Importer output (Test-GeneratedFiles)' {
        $result = Test-GeneratedFiles -Generator New-Importer -PassThru -OutputFolder (Join-Path $TestDrive 'generated-files')
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
