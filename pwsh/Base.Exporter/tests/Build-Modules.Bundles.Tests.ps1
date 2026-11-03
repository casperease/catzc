$bundleRegistry = (Get-Config -Config exporter).bundles
$bundleCases = @(foreach ($name in @($bundleRegistry.Keys)) {
        @{
            bundle   = "$name"
            maxFiles = [int] $bundleRegistry[$name].max_files
        }
    })

Describe 'Every declared bundle builds and loads: <bundle>' -ForEach $bundleCases -Tag 'L2', 'integrity', 'greedy', 'source-only' {
    BeforeAll {
        Import-InternalModule TestKit

        $probe = {
            param([string[]] $Modules)
            foreach ($module in $Modules) {
                if (-not (Get-Module $module)) {
                    "$module|-|failed: the module is not loaded in the fresh session"
                    continue
                }
                $result = $null
                $firstError = $null
                $tried = 0
                foreach ($name in @((Get-Module $module).ExportedFunctions.Keys | Sort-Object)) {
                    if ($name -notlike 'Get-*') {
                        continue
                    }
                    $command = Get-Command -Name $name -Module $module
                    $mandatory = @($command.Parameters.Values | Where-Object {
                            @($_.ParameterSets.Values | Where-Object { $_.IsMandatory }).Count -gt 0
                        })
                    if ($mandatory.Count -gt 0) {
                        continue
                    }
                    $tried++
                    try {
                        & $name | Out-Null
                        $result = "$module|$name|ok"
                        break
                    }
                    catch {
                        if ($null -eq $firstError) {
                            $firstError = "$name threw: $($_.Exception.Message)"
                        }
                    }
                    if ($tried -ge 5) {
                        break
                    }
                }
                if ($result) {
                    $result
                }
                elseif ($firstError) {
                    "$module|-|skipped: $($firstError -replace '\s+', ' ')"
                }
                else {
                    "$module|-|skipped: no exported Get- function with all-optional parameters"
                }
            }
        }

        $destination = Join-Path ([System.IO.Path]::GetTempPath()) ('catzc-bundles-' + [guid]::NewGuid().ToString('N'))
        $script:built = @{ Error = $null; Handle = $null; Rows = @(); Plan = $null; Modules = @() }
        try {
            $build = Build-Modules -Bundle $bundle -Destination $destination -Silent
            $script:built.Plan = $build
            $script:built.Handle = @{
                BuildRoot   = [string] $build.BuildRoot
                WorkingRoot = $env:RepositoryRoot
                Saved       = @{ RepositoryRoot = $env:RepositoryRoot; CatzcModulesRoot = $env:CatzcModulesRoot }
                Destination = $destination
            }
            $script:built.Modules = @($build.Modules)
            $script:built.Rows = @(Invoke-InBuiltCatzc -Handle $script:built.Handle -ScriptBlock $probe -ArgumentList (, @($build.Modules)))
        }
        catch {
            $script:built.Error = $_.Exception.Message
            if ([System.IO.Directory]::Exists($destination)) {
                [System.IO.Directory]::Delete($destination, $true)
            }
        }
        $script:built.Destination = $destination
    }

    AfterAll {
        if ($script:built.Handle) {
            Remove-BuiltCatzcRoot -Handle $script:built.Handle
        }
    }

    It 'the declared bundle builds within its footprint limits' {
        $script:built.Error | Should -BeNullOrEmpty
        @($script:built.Modules).Count | Should -BeGreaterThan 0
        $script:built.Plan.FileCount | Should -BeLessOrEqual $maxFiles
    }

    It 'the build passes Assert-CatzcBundle' {
        $script:built.Error | Should -BeNullOrEmpty
        { Assert-CatzcBundle -Path $script:built.Plan.BuildRoot } | Should -Not -Throw
    }

    It 'a fresh session loads the build and calls one public function of every module it ships' {
        $script:built.Error | Should -BeNullOrEmpty
        $rows = @($script:built.Rows | ForEach-Object { "$_" })
        $rows.Count | Should -Be @($script:built.Modules).Count
        foreach ($row in $rows) {
            Write-Message "bundle $bundle probe: $row"
        }
        $failed = @($rows | Where-Object { $_ -like '*|failed:*' })
        $failed | Should -BeNullOrEmpty -Because ($failed -join "`n")
    }
}
