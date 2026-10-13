# Test-Formatting is a quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)):
# each L0 case mocks every formatter at the module boundary and reads the collected issues; the report goes to
# $TestDrive.
Describe 'Test-Formatting' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Assert-SourceTree -ModuleName Catzc.Base.QualityGates { }
        Mock Format-Markdown -ModuleName Catzc.Base.QualityGates { [pscustomobject]@{ ChangedCount = 0; ChangedFiles = @(); Warnings = @(); DryRun = $false; Check = $true; ExitCode = 0 } }
        Mock Format-Pipelines -ModuleName Catzc.Base.QualityGates { [pscustomobject]@{ ChangedCount = 0; ChangedFiles = @(); Warnings = @(); DryRun = $false; Check = $true; ExitCode = 0 } }
        Mock Format-Automation -ModuleName Catzc.Base.QualityGates { }
        Mock Format-Types -ModuleName Catzc.Base.QualityGates { [pscustomobject]@{ ChangedCount = 0; ChangedFiles = @(); BlockScopedFiles = @(); DryRun = $true } }
        $script:reportFolder = Join-Path $TestDrive 'formatting'
    }

    It 'passes a tree every formatter leaves unchanged, running each in its report-only mode' -Tag 'ADR-AUTO-TEST#35' {
        { Test-Formatting -OutputFolder $script:reportFolder } | Should -Not -Throw
        Should -Invoke Format-Markdown -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter { $Check -and $PassThru }
        Should -Invoke Format-Pipelines -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter { $Check -and $PassThru }
        Should -Invoke Format-Automation -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter { $DryRun }
        Should -Invoke Format-Types -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter { $DryRun -and $PassThru }
    }

    It 'throws once listing every unformatted file with the formatter that fixes it' -Tag 'ADR-AUTO-TEST#35' {
        Mock Format-Markdown -ModuleName Catzc.Base.QualityGates { [pscustomobject]@{ ChangedCount = 2; ChangedFiles = @('docs/widget.md', 'docs/gadget.md'); Warnings = @(); DryRun = $false; Check = $true; ExitCode = 1 } }
        Mock Format-Pipelines -ModuleName Catzc.Base.QualityGates { [pscustomobject]@{ ChangedCount = 1; ChangedFiles = @('pipelines/ci-widget.yaml'); Warnings = @(); DryRun = $false; Check = $true; ExitCode = 1 } }

        $thrown = { Test-Formatting -OutputFolder $script:reportFolder } | Should -Throw -PassThru
        $thrown.Exception.Message | Should -BeLike 'Test-Formatting failed: 3 issue(s)*'
        $thrown.Exception.Message | Should -BeLike '*docs/widget.md: not formatted — run Format-Markdown*'
        $thrown.Exception.Message | Should -BeLike '*docs/gadget.md: not formatted — run Format-Markdown*'
        $thrown.Exception.Message | Should -BeLike '*pipelines/ci-widget.yaml: not formatted — run Format-Pipelines*'
    }

    It 'returns the result with the formatter count under -PassThru, naming files repository-relative' -Tag 'ADR-AUTO-TEST#35' {
        $widget = Join-Path (Get-RepositoryRoot) 'automation/Widget/Get-Widget.ps1'
        $gizmo = Join-Path (Get-RepositoryRoot) 'automation/Widget/types/Gizmo.cs'
        Mock Format-Automation -ModuleName Catzc.Base.QualityGates -ParameterFilter { $DryRun } { $widget }
        Mock Format-Types -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ ChangedCount = 1; ChangedFiles = @('automation\Widget\types\Gadget.cs'); BlockScopedFiles = @($gizmo); DryRun = $true }
        }.GetNewClosure()

        $result = Test-Formatting -PassThru -OutputFolder $script:reportFolder
        $result.Subject | Should -Be 'formatting'
        $result.Formatters | Should -Be 4
        $result.Issues | Should -Be @(
            'automation/Widget/Get-Widget.ps1: not formatted — run Format-Automation'
            'automation/Widget/types/Gadget.cs: not formatted — run Format-Types'
            "automation/Widget/types/Gizmo.cs: block-scoped namespace — rewrite it as the file-scoped 'namespace <Module>;'"
        )
    }

    It 'runs only the selected formatters' {
        $result = Test-Formatting -Formatter Format-Pipelines -PassThru -OutputFolder $script:reportFolder
        $result.IssueCount | Should -Be 0
        $result.Formatters | Should -Be 1
        Should -Invoke Format-Pipelines -ModuleName Catzc.Base.QualityGates -Times 1
        Should -Invoke Format-Markdown -ModuleName Catzc.Base.QualityGates -Times 0
        Should -Invoke Format-Automation -ModuleName Catzc.Base.QualityGates -Times 0
        Should -Invoke Format-Types -ModuleName Catzc.Base.QualityGates -Times 0
    }
}

# Integrity: the real repository is formatted — Markdown (Prettier), the gated PowerShell set, and the C# type
# namespaces (each source declares its module's file-scoped namespace, the invariant the type loader also enforces). The pipeline YAML has its own block (Format-Pipelines.Tests.ps1). L2 because it drives the Prettier CLI
# and the vendored analyzer's formatter; self-skips when prettier is absent
# ([ADR-AUTO-TEST#8](/docs/adr/automation/test-automation.md#rule-adr-auto-test8)/9). source-only: it reads the
# repository's own files, which give the same answer in both run modes.
Describe 'Repository formatting integrity' -Tag 'L2', 'integrity', 'source-only' {
    It 'every formatter leaves the repository unchanged (Test-Formatting)' {
        if (-not (Get-Command prettier -ErrorAction Ignore)) {
            Set-ItResult -Skipped -Because 'tool_prettier_missing'
            return
        }
        $result = Test-Formatting -Formatter Format-Markdown, Format-Automation, Format-Types -PassThru -OutputFolder (Join-Path $TestDrive 'formatting')
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
