Describe 'Export-Catzc installs a real base build into a working root' -Tag 'L2', 'logic', 'greedy', 'source-only' {
    BeforeAll {
        # Lists every file under a root as relative path plus content hash, so two snapshots compare by value.
        function script:Get-RootSnapshot {
            param([string] $Path, [switch] $ExcludeOut)
            $prefix = [System.IO.Path]::GetFullPath($Path).TrimEnd('\', '/') + [System.IO.Path]::DirectorySeparatorChar
            # A named whole-tree walk: the fixture root is small and every file of it is compared.
            $rows = foreach ($file in Get-ChildPath $Path -File -Depth 64 -Exclude @() -PruneVendor $false) {
                $relative = $file.Substring($prefix.Length).Replace('\', '/')
                if ($ExcludeOut -and $relative.StartsWith('out/')) {
                    continue
                }
                "$relative $([System.Convert]::ToHexString([System.Security.Cryptography.SHA256]::HashData([System.IO.File]::ReadAllBytes($file))))"
            }
            @($rows | Sort-Object)
        }

        # The load runs in a fresh pwsh through the installed importer.ps1, the way a consumer of the root loads catzc.
        function script:Invoke-RootLoad {
            param([string] $Path, [string] $Importer)
            $command = ". '$Importer' | Out-Null; 'RUNMODE=' + (Get-CatzcRunMode)"
            Push-Location $Path
            try {
                $output = & ([System.Environment]::ProcessPath) -NoProfile -NonInteractive -Command $command 2>&1
                $exitCode = $LASTEXITCODE
            }
            finally {
                Pop-Location
            }
            [pscustomobject]@{ ExitCode = $exitCode; Output = @($output | ForEach-Object { "$_" }) }
        }

        $script:roots = @{}
        $isBuilt = $false
        foreach ($kind in 'git', 'plain') {
            $root = Join-Path $TestDrive "root-$kind"
            [void][System.IO.Directory]::CreateDirectory($root)
            if ($kind -eq 'git') {
                & git -C $root init --quiet
                if ($LASTEXITCODE -ne 0) {
                    throw "git init failed in the fixture root '$root'."
                }
            }
            if ($isBuilt) {
                $first = Install-Catzc -Root $root -Bundle base -Silent
            }
            else {
                $first = Export-Catzc -Root $root -Bundle base -Silent
                $isBuilt = $true
            }
            $afterFirst = Get-RootSnapshot -Path $root
            $second = Install-Catzc -Root $root -Bundle base -Silent
            $afterSecond = Get-RootSnapshot -Path $root
            # No process ran since the second snapshot, so the pre-load state is that snapshot without out/.
            $before = @($afterSecond | Where-Object { -not $_.StartsWith('out/') })
            $load = Invoke-RootLoad -Path $root -Importer $first.Importer
            $after = Get-RootSnapshot -Path $root -ExcludeOut
            $script:roots[$kind] = @{
                Root = $root; First = $first; Second = $second
                AfterFirst = $afterFirst; AfterSecond = $afterSecond
                Before = $before; After = $after; Load = $load
            }
        }
    }

    It 'writes the root importer.ps1 and the module under .vendor into a <kind> root' -ForEach @(
        @{ kind = 'git' }, @{ kind = 'plain' }
    ) {
        $state = $script:roots[$kind]
        $state.First.Importer | Should -Exist
        [System.IO.Path]::GetDirectoryName($state.First.Importer) | Should -Be $state.Root
        $state.First.ModulePath | Should -Exist
        [System.IO.Directory]::Exists((Join-Path $state.Root '.git')) | Should -Be ($kind -eq 'git')
    }

    It 'the install renders the consumer root files into a <kind> root' -ForEach @(
        @{ kind = 'git' }, @{ kind = 'plain' }
    ) {
        $state = $script:roots[$kind]
        foreach ($name in 'cspell.yml', '.markdownlint.yml', 'nuget.config', 'PSScriptAnalyzerSettings.psd1') {
            Join-Path $state.Root $name | Should -Exist
        }
        Join-Path $state.Root '.cspell/product.txt' | Should -Exist
    }

    It 'a second export to the same <kind> root is idempotent' -ForEach @(
        @{ kind = 'git' }, @{ kind = 'plain' }
    ) {
        $state = $script:roots[$kind]
        $state.Second.AlreadyCurrent | Should -BeTrue
        $state.Second.ContentHash | Should -Be $state.First.ContentHash
        $state.AfterSecond | Should -Be $state.AfterFirst
    }

    It 'a fresh session loading the <kind> root through importer.ps1 reports the run mode build' -ForEach @(
        @{ kind = 'git' }, @{ kind = 'plain' }
    ) {
        $load = $script:roots[$kind].Load
        $load.ExitCode | Should -Be 0 -Because ($load.Output -join "`n")
        $load.Output | Should -Contain 'RUNMODE=build'
    }

    It 'the load of the <kind> root wrote nothing outside the working root''s out/' -ForEach @(
        @{ kind = 'git' }, @{ kind = 'plain' }
    ) {
        $state = $script:roots[$kind]
        $state.After | Should -Be $state.Before
    }
}
