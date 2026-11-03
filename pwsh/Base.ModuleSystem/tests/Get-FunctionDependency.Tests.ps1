Describe 'Get-FunctionDependency' -Tag 'L0', 'integrity', 'source-only' {
    BeforeAll {
        $script:dependencies = Get-FunctionDependency
    }

    It 'CrossModule is true when CallerModule != TargetModule' {
        # One Should over the violating set: a Should per edge costs about 0.5 ms times about 1000 edges, past the L0 limit.
        $violations = foreach ($dependency in $dependencies) {
            if ($dependency.CrossModule -and $dependency.CallerModule -eq $dependency.TargetModule) {
                $dependency
            }
        }
        @($violations) | Should -BeNullOrEmpty
    }
}

Describe 'Get-FunctionDependency — shared parse' -Tag 'L0', 'logic' {
    BeforeAll {
        Import-InternalModule TestKit
        $script:fake = New-FakeRepositoryRoot -Modules @{
            'Catzc.Base.Widget' = @{ Files = @{ 'Get-Widget.ps1' = "function Get-Widget {`n    Get-Gadget`n}" } }
            'Catzc.Base.Gadget' = @{ Files = @{ 'Get-Gadget.ps1' = "function Get-Gadget {`n    'gadget'`n}" } }
        }
        Mock Assert-CatzcSourceTree -ModuleName Catzc.Base.ModuleSystem { }
    }

    AfterAll {
        Remove-FakeRepositoryRoot $script:fake
    }

    It 'parses each file once into the holder it is given' {
        $parsed = [Catzc.Base.Repository.ParsedScripts]::new()
        $edges = @(Get-FunctionDependency -ModulesRoot $script:fake.ModulesRoot -ParsedScripts $parsed)
        $parsed.ParseCount | Should -Be 2
        $edges | Should -HaveCount 1
        $edges[0].CallerFunction | Should -Be 'Get-Widget'
    }
}

Describe 'Get-FunctionDependency — cross-session file' -Tag 'L0', 'logic' {
    BeforeAll {
        Import-InternalModule TestKit
        $script:fake = New-FakeRepositoryRoot -Modules @{
            'Catzc.Base.Widget' = @{ Files = @{ 'Get-Widget.ps1' = "function Get-Widget {`n    Get-Gadget`n}" } }
            'Catzc.Base.Gadget' = @{ Files = @{ 'Get-Gadget.ps1' = "function Get-Gadget {`n    'gadget'`n}" } }
        }
        $script:cacheFile = Join-Path $TestDrive 'cache/function-dependency.json'
        Mock Assert-CatzcSourceTree -ModuleName Catzc.Base.ModuleSystem { }
        Mock Get-FunctionDependencyCachePath -ModuleName Catzc.Base.ModuleSystem { $env:FUNCTION_DEPENDENCY_TEST_CACHE }
        $script:previousCache = $env:FUNCTION_DEPENDENCY_TEST_CACHE
        $env:FUNCTION_DEPENDENCY_TEST_CACHE = $script:cacheFile
    }

    AfterAll {
        $env:FUNCTION_DEPENDENCY_TEST_CACHE = $script:previousCache
        Remove-FakeRepositoryRoot $script:fake
    }

    BeforeEach {
        # The session cache sits in front of the file, so each call below starts from an empty one.
        & (Get-Module Catzc.Base.ModuleSystem) { $script:functionDependencyCache = @{} }
    }

    It 'writes the file on a first call, reads it back without parsing, and rebuilds it after a script changed' {
        $first = [Catzc.Base.Repository.ParsedScripts]::new()
        $firstEdges = @(Get-FunctionDependency -ModulesRoot $script:fake.ModulesRoot -ParsedScripts $first)
        $first.ParseCount | Should -Be 2
        [System.IO.File]::Exists($script:cacheFile) | Should -BeTrue
        $stampBefore = (Get-Content -Raw $script:cacheFile | ConvertFrom-Json).Stamp

        & (Get-Module Catzc.Base.ModuleSystem) { $script:functionDependencyCache = @{} }
        $second = [Catzc.Base.Repository.ParsedScripts]::new()
        $secondEdges = @(Get-FunctionDependency -ModulesRoot $script:fake.ModulesRoot -ParsedScripts $second)
        $second.ParseCount | Should -Be 0
        $secondEdges | Should -HaveCount 1
        ($secondEdges | ConvertTo-Json -Compress) | Should -Be ($firstEdges | ConvertTo-Json -Compress)

        & (Get-Module Catzc.Base.ModuleSystem) { $script:functionDependencyCache = @{} }
        $gadget = Get-ChildPath $script:fake.ModulesRoot -File -Filter 'Get-Gadget.ps1' -Depth 3 | Select-Object -First 1
        $changed = "function Get-Gadget {`n    'changed'`n}"
        [System.IO.File]::WriteAllText($gadget, $changed)
        $third = [Catzc.Base.Repository.ParsedScripts]::new()
        $thirdEdges = @(Get-FunctionDependency -ModulesRoot $script:fake.ModulesRoot -ParsedScripts $third)
        $third.ParseCount | Should -Be 2
        $thirdEdges | Should -HaveCount 1
        (Get-Content -Raw $script:cacheFile | ConvertFrom-Json).Stamp | Should -Not -Be $stampBefore
    }

    It 'parses when the file is unreadable' {
        [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($script:cacheFile)) | Out-Null
        [System.IO.File]::WriteAllText($script:cacheFile, 'not json')
        $parsed = [Catzc.Base.Repository.ParsedScripts]::new()
        $edges = @(Get-FunctionDependency -ModulesRoot $script:fake.ModulesRoot -ParsedScripts $parsed)
        $parsed.ParseCount | Should -Be 2
        $edges | Should -HaveCount 1
    }
}

Describe 'Get-FunctionDependency — build mode' -Tag 'L0', 'logic' {
    It 'stops with a named error when the session runs a built package' {
        Mock Get-CatzcRunMode { 'build' } -ModuleName Catzc.Base.Repository
        { Get-FunctionDependency -ModulesRoot $TestDrive } |
            Should -Throw '*Get-FunctionDependency runs in catzc*s source tree only*'
    }
}
