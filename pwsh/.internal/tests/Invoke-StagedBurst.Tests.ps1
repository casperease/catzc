Describe 'Invoke-StagedBurst' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:burst = Join-Path $PSScriptRoot '../assets/Invoke-StagedBurst.ps1'
    }

    BeforeEach {
        $script:lockName = "Local\catzc-test-$([guid]::NewGuid())"
        $script:root = Join-Path $TestDrive "root-$([guid]::NewGuid())"
        # The staged folder, and so its journal, sits outside the root, as the burst requires.
        $script:staged = Join-Path $TestDrive "staging-$([guid]::NewGuid())/widget/staged"
        $null = New-Item -ItemType Directory -Path (Join-Path $script:root 'widgets'), (Join-Path $script:staged 'widgets') -Force
        $script:target = Join-Path $script:root 'widgets/gadget.txt'
        $script:created = Join-Path $script:root 'widgets/sprocket.txt'
        [System.IO.File]::WriteAllText($script:target, 'original')
        [System.IO.File]::WriteAllText((Join-Path $script:staged 'widgets/gadget.txt'), 'staged')
        [System.IO.File]::WriteAllText((Join-Path $script:staged 'widgets/sprocket.txt'), 'new')
        $script:importer = Join-Path $script:root 'widget-importer.ps1'
        $script:doomed = Join-Path $script:root 'widgets/cog.txt'
        [System.IO.File]::WriteAllText($script:doomed, 'cog')
        $gadget = $script:target.Replace("'", "''")
        $cog = $script:doomed.Replace("'", "''")
        $widgets = (Join-Path $script:root 'widgets').Replace("'", "''")
        $script:generated = Join-Path $script:root 'gen/sprocket.json'
        $script:kept = Join-Path $script:root 'kept.txt'
        [System.IO.File]::WriteAllText($script:kept, 'kept')
        $generated = $script:generated.Replace("'", "''")
        $kept = $script:kept.Replace("'", "''")
        $recorder = (Join-Path $PSScriptRoot '../assets/types/Save-BurstJournalWrite.ps1').Replace("'", "''")
        [System.IO.File]::WriteAllText($script:importer, @"
function Write-Message { param([AllowEmptyString()] [string] `$Message, [switch] `$NoHeader) Write-Information `$Message -InformationAction Continue }
function Test-Swapped { if ((Get-Content -LiteralPath '$gadget' -Raw) -ne 'staged') { throw 'the staged gadget is not in place' } }
function Test-Deleted { if (Test-Path -LiteralPath '$cog') { throw 'the cog is still there' } }
function Test-Broken { throw 'broken gadget' }
function Remove-Widgets { Remove-Item -LiteralPath '$widgets' -Recurse -Force }
. '$recorder'
function Write-Generated {
    foreach (`$path in '$generated', '$kept') { Save-BurstJournalWrite -Path `$path }
    `$null = New-Item -ItemType Directory -Path (Split-Path -Parent '$generated') -Force
    [System.IO.File]::WriteAllText('$generated', 'generated')
    [System.IO.File]::WriteAllText('$kept', 'rewritten')
}
function Test-BurstHeld { `$event = `$null; if (-not [System.Threading.EventWaitHandle]::TryOpenExisting('$($script:lockName)-burst', [ref] `$event)) { throw 'no burst event while the swap runs' }; `$event.Dispose() }
"@)
    }

    It 'swaps the staged files in, creates a new one, tests them under one import and removes the journal' {
        $lines = @(& $script:burst -StagedFolder $script:staged -RepositoryRoot $script:root -Importer $script:importer -LockName $script:lockName -LockSeconds 1 -Seconds 30 'Test-Swapped')
        $LASTEXITCODE | Should -Be 0
        [System.IO.File]::ReadAllText($script:target) | Should -BeExactly 'staged'
        [System.IO.File]::ReadAllText($script:created) | Should -BeExactly 'new'
        Test-Path -LiteralPath "$script:staged.backup" | Should -BeFalse
        $lines | Should -Contain '[Invoke-CatzcCommand] passed: Test-Swapped'
        $lines | Should -Contain '[Invoke-CatzcCommand] 1 of 1 passed'
        ($lines -join "`n") | Should -Not -BeLike '*is not recognized*'
        $lines | Should -Contain '[Invoke-StagedBurst] swapped 2 staged file(s) in and 1 command(s) passed'
        $lines[-1] | Should -BeLike '[[]Enter-CatzcBurst] released the run lock: the 1 -Run steps passed'
    }

    It 'restores every target, deleting the one it created, when a test fails' {
        $lines = @(& $script:burst -StagedFolder $script:staged -RepositoryRoot $script:root -Importer $script:importer -LockName $script:lockName -LockSeconds 1 -Seconds 30 'Test-Swapped' 'Test-Broken')
        $LASTEXITCODE | Should -Be 1
        [System.IO.File]::ReadAllText($script:target) | Should -BeExactly 'original'
        Test-Path -LiteralPath $script:created | Should -BeFalse
        Test-Path -LiteralPath "$script:staged.backup" | Should -BeFalse
        $lines | Should -Contain '[Invoke-CatzcCommand] failed: Test-Broken — broken gadget'
        $lines |
            Should -Contain '[Invoke-StagedBurst] restored every target from the journal: the tests failed (exit code 1)'
    }

    It 'removes every folder the swap created, deepest first, when a test fails' {
        $deep = Join-Path $script:staged 'fresh/deeper/thing.txt'
        $null = New-Item -ItemType Directory -Path (Split-Path -Parent $deep) -Force
        [System.IO.File]::WriteAllText($deep, 'thing')
        $null = @(& $script:burst -StagedFolder $script:staged -RepositoryRoot $script:root -Importer $script:importer -LockName $script:lockName -LockSeconds 1 -Seconds 30 'Test-Broken')
        $LASTEXITCODE | Should -Be 1
        Join-Path $script:root 'fresh' | Should -Not -Exist
        [System.IO.File]::ReadAllText($script:target) | Should -BeExactly 'original'
    }

    It 'restores a journal a killed call left, before it swaps anything' {
        $journal = "$script:staged.backup"
        $null = New-Item -ItemType Directory -Path (Join-Path $journal 'files/widgets') -Force
        [System.IO.File]::WriteAllText((Join-Path $journal 'files/widgets/gadget.txt'), 'before the killed swap')
        [System.IO.File]::WriteAllText((Join-Path $journal 'manifest.json'),
            '[{"path":"widgets/gadget.txt","existed":true},{"path":"widgets/sprocket.txt","existed":false}]')
        [System.IO.File]::WriteAllText($script:target, 'half swapped')
        [System.IO.File]::WriteAllText($script:created, 'half swapped')
        # The staged folder holds one file only, so the journal's second target is restored by the journal alone.
        Remove-Item -LiteralPath (Join-Path $script:staged 'widgets/sprocket.txt')
        $lines = @(& $script:burst -StagedFolder $script:staged -RepositoryRoot $script:root -Importer $script:importer -LockName $script:lockName -LockSeconds 1 -Seconds 30 'Test-Swapped')
        $LASTEXITCODE | Should -Be 0
        $lines | Should -Contain '[Invoke-StagedBurst] restored an interrupted swap from its journal'
        Test-Path -LiteralPath $script:created | Should -BeFalse
        [System.IO.File]::ReadAllText($script:target) | Should -BeExactly 'staged'
    }

    It 'runs the commands under the run lock alone, touching no target and writing no journal, when <Case>' -ForEach @(
        @{ Case = 'the staged folder holds no file'; Remove = 'widgets' }
        @{ Case = 'the staged folder is absent'; Remove = '' }
    ) {
        $folder = if ($Remove) {
            Join-Path $script:staged $Remove
        }
        else {
            $script:staged
        }
        Remove-Item -LiteralPath $folder -Recurse -Force
        $lines = @(& $script:burst -StagedFolder $script:staged -RepositoryRoot $script:root -Importer $script:importer -LockName $script:lockName -LockSeconds 1 -Seconds 30 'Test-BurstHeld')
        $LASTEXITCODE | Should -Be 0
        [System.IO.File]::ReadAllText($script:target) | Should -BeExactly 'original'
        Test-Path -LiteralPath "$script:staged.backup" | Should -BeFalse
        $lines | Should -Contain '[Invoke-StagedBurst] nothing staged; 1 command(s) passed under the run lock'
    }

    Context 'a staged base' {
        BeforeEach {
            Remove-Item -LiteralPath (Join-Path $script:staged 'widgets/gadget.txt'), (Join-Path $script:staged 'widgets/sprocket.txt')
            $null = & $script:burst -StagedFolder $script:staged -RepositoryRoot $script:root -Stage 'widgets/gadget.txt'
            [System.IO.File]::WriteAllText((Join-Path $script:staged 'widgets/gadget.txt'), 'staged')
        }

        It 'stages a target with the hash it had, beside the copy' {
            [System.IO.File]::Exists((Join-Path $script:staged 'widgets/gadget.txt.burst-base')) | Should -BeTrue
        }

        It 'stages every path of a list, whether passed as an array, one comma-joined string, or further arguments' {
            [System.IO.File]::WriteAllText((Join-Path $script:root 'widgets/sprocket.txt'), 'sprocket')
            Remove-Item -LiteralPath (Join-Path $script:staged 'widgets') -Recurse
            $null = & $script:burst -StagedFolder $script:staged -RepositoryRoot $script:root -Stage 'widgets/gadget.txt', 'widgets/cog.txt'
            $null = & $script:burst -StagedFolder $script:staged -RepositoryRoot $script:root -Stage 'widgets/sprocket.txt,widgets/cog.txt'
            foreach ($name in 'gadget', 'cog', 'sprocket') {
                [System.IO.File]::Exists((Join-Path $script:staged "widgets/$name.txt.burst-base")) |
                    Should -BeTrue -Because $name
            }
            Remove-Item -LiteralPath (Join-Path $script:staged 'widgets') -Recurse
            $null = & pwsh -NoProfile -File $script:burst -StagedFolder $script:staged -RepositoryRoot $script:root -Stage 'widgets/gadget.txt' 'widgets/cog.txt'
            foreach ($name in 'gadget', 'cog') {
                [System.IO.File]::Exists((Join-Path $script:staged "widgets/$name.txt.burst-base")) |
                    Should -BeTrue -Because "$name through pwsh -File"
            }
        }

        It 'applies a staged copy whose target has not changed since it was staged' {
            $null = @(& $script:burst -StagedFolder $script:staged -RepositoryRoot $script:root -Importer $script:importer -LockName $script:lockName -LockSeconds 1 -Seconds 30 'Test-Swapped')
            $LASTEXITCODE | Should -Be 0
            [System.IO.File]::ReadAllText($script:target) | Should -BeExactly 'staged'
            Test-Path -LiteralPath "$script:target.burst-base" | Should -BeFalse
        }

        It 'refuses a staged copy whose target changed after it was staged, naming it, before touching anything' {
            [System.IO.File]::WriteAllText($script:target, 'a peer''s edit')
            $lines = @(& $script:burst -StagedFolder $script:staged -RepositoryRoot $script:root -Importer $script:importer -LockName $script:lockName -LockSeconds 1 -Seconds 30 'Test-Swapped')
            $LASTEXITCODE | Should -Be 1
            [System.IO.File]::ReadAllText($script:target) | Should -BeExactly 'a peer''s edit'
            ($lines -join "`n") | Should -BeLike "*'widgets*gadget.txt' changed since it was staged*"
        }

        It 'applies a new file staged with no base' {
            [System.IO.File]::WriteAllText((Join-Path $script:staged 'widgets/sprocket.txt'), 'new')
            $null = @(& $script:burst -StagedFolder $script:staged -RepositoryRoot $script:root -Importer $script:importer -LockName $script:lockName -LockSeconds 1 -Seconds 30 'Test-Swapped')
            $LASTEXITCODE | Should -Be 0
            [System.IO.File]::ReadAllText($script:created) | Should -BeExactly 'new'
        }
    }

    Context 'a staged delete' {
        BeforeEach {
            Remove-Item -LiteralPath (Join-Path $script:staged 'widgets/gadget.txt'), (Join-Path $script:staged 'widgets/sprocket.txt')
            [System.IO.File]::WriteAllText((Join-Path $script:staged 'widgets/cog.txt.burst-delete'), '')
        }

        It 'deletes the target a marker names, under the same import, and removes the journal' {
            $null = @(& $script:burst -StagedFolder $script:staged -RepositoryRoot $script:root -Importer $script:importer -LockName $script:lockName -LockSeconds 1 -Seconds 30 'Test-Deleted')
            $LASTEXITCODE | Should -Be 0
            Test-Path -LiteralPath $script:doomed | Should -BeFalse
            Test-Path -LiteralPath "$script:doomed.burst-delete" | Should -BeFalse
            Test-Path -LiteralPath "$script:staged.backup" | Should -BeFalse
        }

        It 'puts the deleted target back when a test fails' {
            $null = @(& $script:burst -StagedFolder $script:staged -RepositoryRoot $script:root -Importer $script:importer -LockName $script:lockName -LockSeconds 1 -Seconds 30 'Test-Deleted' 'Test-Broken')
            $LASTEXITCODE | Should -Be 1
            [System.IO.File]::ReadAllText($script:doomed) | Should -BeExactly 'cog'
            Test-Path -LiteralPath "$script:staged.backup" | Should -BeFalse
        }

        It 'restores every target when a step deleted a staged file''s folder before a test failed' {
            [System.IO.File]::WriteAllText((Join-Path $script:staged 'widgets/gadget.txt'), 'staged')
            $lines = @(& $script:burst -StagedFolder $script:staged -RepositoryRoot $script:root -Importer $script:importer -LockName $script:lockName -LockSeconds 1 -Seconds 30 'Remove-Widgets' 'Test-Broken')
            $LASTEXITCODE | Should -Be 1
            $lines | Should -Contain '[Invoke-StagedBurst] restored every target from the journal: the tests failed (exit code 1)'
            [System.IO.File]::ReadAllText($script:target) | Should -BeExactly 'original'
            [System.IO.File]::ReadAllText($script:doomed) | Should -BeExactly 'cog'
            Test-Path -LiteralPath "$script:staged.backup" | Should -BeFalse
        }

        It 'puts back what the import wrote when a test fails, so the tree is as it was' {
            # The fixture's whole tree is the root and its widgets folder, one level each, plus where the import writes.
            $tree = {
                foreach ($folder in $script:root, (Join-Path $script:root 'widgets'), (Join-Path $script:root 'gen')) {
                    if ([System.IO.Directory]::Exists($folder)) {
                        foreach ($file in [System.IO.Directory]::GetFiles($folder)) {
                            "$file=$([System.IO.File]::ReadAllText($file))"
                        }
                    }
                }
            }
            $before = @(& $tree)
            $null = @(& $script:burst -StagedFolder $script:staged -RepositoryRoot $script:root -Importer $script:importer -LockName $script:lockName -LockSeconds 1 -Seconds 30 'Write-Generated' 'Test-Broken')
            $LASTEXITCODE | Should -Be 1
            $after = @(& $tree)
            $after | Should -Be $before
            Join-Path $script:root 'gen' | Should -Not -Exist
        }

        It 'keeps what the import wrote when the tests pass' {
            $null = @(& $script:burst -StagedFolder $script:staged -RepositoryRoot $script:root -Importer $script:importer -LockName $script:lockName -LockSeconds 1 -Seconds 30 'Write-Generated')
            $LASTEXITCODE | Should -Be 0
            [System.IO.File]::ReadAllText($script:generated) | Should -BeExactly 'generated'
            [System.IO.File]::ReadAllText($script:kept) | Should -BeExactly 'rewritten'
        }

        It 'restores a swap and a delete together when a test fails' {
            [System.IO.File]::WriteAllText((Join-Path $script:staged 'widgets/gadget.txt'), 'staged')
            $null = @(& $script:burst -StagedFolder $script:staged -RepositoryRoot $script:root -Importer $script:importer -LockName $script:lockName -LockSeconds 1 -Seconds 30 'Test-Swapped' 'Test-Deleted' 'Test-Broken')
            $LASTEXITCODE | Should -Be 1
            [System.IO.File]::ReadAllText($script:target) | Should -BeExactly 'original'
            [System.IO.File]::ReadAllText($script:doomed) | Should -BeExactly 'cog'
        }

        It 'refuses a marker whose target does not exist, before touching anything' {
            [System.IO.File]::WriteAllText((Join-Path $script:staged 'widgets/gadget.txt'), 'staged')
            [System.IO.File]::WriteAllText((Join-Path $script:staged 'widgets/sprocket.txt.burst-delete'), '')
            $lines = @(& $script:burst -StagedFolder $script:staged -RepositoryRoot $script:root -Importer $script:importer -LockName $script:lockName -LockSeconds 1 -Seconds 30 'Test-Deleted')
            $LASTEXITCODE | Should -Be 1
            [System.IO.File]::ReadAllText($script:target) | Should -BeExactly 'original'
            [System.IO.File]::ReadAllText($script:doomed) | Should -BeExactly 'cog'
            ($lines -join "`n") | Should -BeLike "*marks 'widgets*sprocket.txt' for deletion, but it does not exist*"
        }
    }

    It 'holds the burst event for the swap window, so an import outside it waits, and lets it go after a pass and after a failure' -ForEach @(
        @{ Commands = @('Test-BurstHeld'); Exit = 0 }
        @{ Commands = @('Test-BurstHeld', 'Test-Broken'); Exit = 1 }
    ) {
        $null = @(& $script:burst -StagedFolder $script:staged -RepositoryRoot $script:root -Importer $script:importer -LockName $script:lockName -LockSeconds 1 -Seconds 30 @Commands)
        $LASTEXITCODE | Should -Be $Exit
        $handle = $null
        [System.Threading.EventWaitHandle]::TryOpenExisting("$($script:lockName)-burst", [ref] $handle) | Should -BeFalse
    }

    It 'refuses a staged folder inside the root, whose journal a cleanup could delete mid-burst, before touching anything' {
        $inside = Join-Path $script:root 'out/widget/staged'
        $null = New-Item -ItemType Directory -Path (Join-Path $inside 'widgets') -Force
        [System.IO.File]::WriteAllText((Join-Path $inside 'widgets/gadget.txt'), 'staged')
        { & $script:burst -StagedFolder $inside -RepositoryRoot $script:root -Importer $script:importer -LockName $script:lockName -LockSeconds 1 -Seconds 30 -InBurst 'Test-Swapped' } |
            Should -Throw '*would live inside the repository*'
        [System.IO.File]::ReadAllText($script:target) | Should -BeExactly 'original'
        Test-Path -LiteralPath "$inside.backup" | Should -BeFalse
    }

    It 'refuses to stage into a folder inside the root, such as out/, before copying anything' {
        $inside = Join-Path $script:root 'out/widget/staged'
        { & $script:burst -StagedFolder $inside -RepositoryRoot $script:root -Stage 'widgets/gadget.txt' } |
            Should -Throw '*is inside the repository*'
        Test-Path -LiteralPath (Join-Path $inside 'widgets/gadget.txt') | Should -BeFalse
    }

    It 'names no command, and stops' {
        { & $script:burst -StagedFolder $script:staged -RepositoryRoot $script:root -LockName $script:lockName } |
            Should -Throw '*at least one command*'
    }
}
