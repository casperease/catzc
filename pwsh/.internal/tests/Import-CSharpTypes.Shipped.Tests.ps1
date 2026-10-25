Describe 'shipped C# types' -Tag 'L0', 'integrity' {
    It 'every shipped C# type resolves after import (Test-ShippedTypes quality gate)' {
        $result = Test-ShippedTypes -PassThru -OutputFolder (Join-Path $TestDrive 'shipped-types')
        $result.Facts['Types'] | Should -BeGreaterThan 0 -Because 'the gate must find shipped C# type sources (no silent no-op)'
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }

    It 'every shipped C# type declares its module file-scoped namespace (Test-Formatting quality gate)' {
        if (-not (Get-Command Test-Formatting -ErrorAction Ignore)) {
            Set-ItResult -Skipped -Because 'harness_test_formatting'; return
        }
        Mock Format-Code -ModuleName Catzc.Base.QualityGates { }
        $result = Test-Formatting -Language bcl -PassThru -OutputFolder (Join-Path $TestDrive 'formatting')
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}

Describe 'combined types assembly is committed and current' -Tag 'integrity' {
    BeforeAll {
        $script:currentHash = (Get-CombinedTypeHash (Get-CatzcModulesRoot)).CombinedHash
    }

    It 'is exactly one committed assembly whose hash matches the current sources (Test-BuildArtifact)' -Tag 'L2', 'source-only' {
        if (-not (Get-Command git -ErrorAction Ignore)) {
            Set-ItResult -Skipped -Because 'tool_git_missing'; return
        }
        $result = Test-BuildArtifact -Facet Types -PassThru -OutputFolder (Join-Path $TestDrive 'build-artifact')
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }

    It 'the IDE project build stamps its version to the current committed hash (dotnet build)' -Tag 'L2' {
        if (-not (Test-Tool 'dotnet')) {
            Set-ItResult -Skipped -Because 'tool_dotnet_missing'; return
        }
        $csproj = Join-Path (Get-CatzcModulesRoot) '.internal/assets/Catzc.Types.csproj'
        # Build to an isolated output dir so we read THIS run's deps.json and never race the default bin/.
        $outputDirectory = Join-Path $TestDrive 'stamp-build'
        $log = & dotnet build $csproj -c Debug --output $outputDirectory -v minimal 2>&1
        $LASTEXITCODE | Should -Be 0 -Because "dotnet build must succeed — the stamping target fails the build when the committed pwsh/.compiled/Catzc.Types.<hash>.dll is stale or missing:`n$($log -join "`n")"

        $dependencies = Get-Content (Join-Path $outputDirectory 'Catzc.Types.deps.json') -Raw | ConvertFrom-Json
        # The project library entry key is "<AssemblyName>/<Version>"; the stamp makes Version = 1.0.0-<hash>.
        $libraryNames = @($dependencies.libraries.PSObject.Properties.Name)
        $libraryNames | Should -Contain "Catzc.Types/1.0.0-$currentHash" -Because "the deps.json must stamp the current combined types hash, not the default 1.0.0:`n$($libraryNames -join "`n")"
    }
}

Describe 'Import-CSharpTypes — PSTypeAlias accelerators' -Tag 'L0', 'logic' {
    It 'registers the [Catzc.Module.Depm] accelerator for the decorated enum' {
        [Catzc.Module.Depm].FullName | Should -Be 'Catzc.Base.ModuleSystem.ModuleDependencyFormat'
        [Catzc.Module.Depm]::Puml | Should -Be ([Catzc.Base.ModuleSystem.ModuleDependencyFormat]::Puml)
    }
}
