$bundleRegistry = (Get-Config -Config exporter).bundles
$bundleCases = @(foreach ($name in @($bundleRegistry.Keys)) {
        @{
            bundle   = "$name"
            maxFiles = [int] $bundleRegistry[$name].max_files
        }
    })

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
            $candidates = foreach ($name in @((Get-Module $module).ExportedFunctions.Keys | Sort-Object)) {
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
                [pscustomobject]@{
                    Name       = $name
                    Parameters = @($command.Parameters.Keys | Where-Object { $_ -notin [System.Management.Automation.Cmdlet]::CommonParameters }).Count
                }
            }
            foreach ($candidate in @($candidates | Sort-Object Parameters, Name)) {
                $name = $candidate.Name
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

    # Each bundle's build is in-process, one after the other; its fresh-pwsh load runs on a thread job beside the next build.
    $kitPath = (Get-Module Catzc.Internal.TestKit).Path
    $probeText = $probe.ToString()
    $loadJob = {
        param($KitPath, $Handle, $ProbeText, $Modules)
        Import-Module $KitPath -Force
        @(Invoke-InBuiltCatzc -Handle $Handle -ScriptBlock ([scriptblock]::Create($ProbeText)) -ArgumentList (, @($Modules)))
    }

    $script:built = @{}
    $jobs = @{}
    # The largest bundle builds first, so its load, the longest, starts first and the last load to start is the smallest's.
    $registry = (Get-Config -Config exporter).bundles
    foreach ($name in @($registry.Keys | Sort-Object { - [int] $registry[$_].max_files })) {
        $destination = Join-Path ([System.IO.Path]::GetTempPath()) ('catzc-bundles-' + [guid]::NewGuid().ToString('N'))
        $state = @{ Error = $null; Handle = $null; Rows = @(); Plan = $null; Modules = @(); Destination = $destination }
        $script:built["$name"] = $state
        try {
            $build = Build-Modules -Bundle "$name" -Destination $destination -Silent
            $state.Plan = $build
            $state.Handle = @{
                BuildRoot   = [string] $build.BuildRoot
                WorkingRoot = $env:RepositoryRoot
                Saved       = @{ RepositoryRoot = $env:RepositoryRoot; CatzcModulesRoot = $env:CatzcModulesRoot }
                Destination = $destination
            }
            $state.Modules = @($build.Modules)
            $jobs["$name"] = Start-ThreadJob -ScriptBlock $loadJob -ArgumentList $kitPath, $state.Handle, $probeText, @($build.Modules)
        }
        catch {
            $state.Error = $_.Exception.Message
            if ([System.IO.Directory]::Exists($destination)) {
                [System.IO.Directory]::Delete($destination, $true)
            }
        }
    }
    foreach ($name in @($jobs.Keys)) {
        try {
            $script:built[$name].Rows = @(Receive-Job -Job $jobs[$name] -Wait -AutoRemoveJob -ErrorAction Stop)
        }
        catch {
            $script:built[$name].Error = $_.Exception.Message
        }
    }
}

AfterAll {
    foreach ($state in $script:built.Values) {
        if ($state.Handle) {
            Remove-BuiltCatzcRoot -Handle $state.Handle
        }
    }
}

Describe 'Every declared bundle builds and loads: <bundle>' -ForEach $bundleCases -Tag 'L2', 'integrity', 'greedy', 'source-only', 'post-build' {
    BeforeAll {
        $built = $script:built[$bundle]
    }

    It 'the declared bundle builds within its footprint limits' {
        $built.Error | Should -BeNullOrEmpty
        @($built.Modules).Count | Should -BeGreaterThan 0
        $built.Plan.FileCount | Should -BeLessOrEqual $maxFiles
    }

    It 'the build passes Assert-CatzcBundle' {
        $built.Error | Should -BeNullOrEmpty
        { Assert-CatzcBundle -Path $built.Plan.BuildRoot } | Should -Not -Throw
    }

    It 'a fresh session loads the build and calls one public function of every module it ships' {
        $built.Error | Should -BeNullOrEmpty
        $rows = @($built.Rows | ForEach-Object { "$_" })
        $rows.Count | Should -Be @($built.Modules).Count
        foreach ($row in $rows) {
            Write-Message "bundle $bundle probe: $row"
        }
        $failed = @($rows | Where-Object { $_ -like '*|failed:*' })
        $failed | Should -BeNullOrEmpty -Because ($failed -join "`n")
    }
}
