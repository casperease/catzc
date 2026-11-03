Describe 'The full bundle packages the language modules, rebuilds them identically and runs them' -Tag 'L2', 'integrity', 'greedy', 'source-only' {
    BeforeAll {
        # Lists a folder as relative path plus bytes hash, so two folders compare by value.
        function script:Get-FolderBytes {
            param([string] $Path)
            $prefix = [System.IO.Path]::GetFullPath($Path).TrimEnd('\', '/') + [System.IO.Path]::DirectorySeparatorChar
            $rows = foreach ($file in @(Get-ChildPath $Path -File -Depth 16 -Exclude @() -PruneVendor $false)) {
                $hash = [System.Convert]::ToHexString([System.Security.Cryptography.SHA256]::HashData([System.IO.File]::ReadAllBytes($file)))
                "$($file.Substring($prefix.Length).Replace('\', '/')) $hash"
            }
            @($rows | Sort-Object -CaseSensitive)
        }

        # Runs a git command in a fixture root and fails loudly.
        function script:Invoke-FixtureGit {
            param([string] $Root, [string[]] $Arguments)
            $null = & git -C $Root @Arguments 2>&1
            if ($LASTEXITCODE -ne 0) {
                throw "git $($Arguments -join ' ') failed in '$Root' (exit $LASTEXITCODE)."
            }
        }

        $script:built = @{ Error = $null; Root = $null; Entries = @(); JavaScript = @() }
        try {
            $build = Build-Modules -Bundle full -Destination (Join-Path $TestDrive 'bundle') -Silent
            $script:built.Root = [string] $build.BuildRoot

            # The build plan is read from the build's own build.json, so a module added to the tree is covered without an edit here.
            $plan = [System.IO.File]::ReadAllText((Join-Path $script:built.Root 'build.json')) | ConvertFrom-Json -AsHashtable
            $script:built.Entries = @($plan['languages'] | Where-Object { $_ })

            $script:built.JavaScript = @(foreach ($track in @(Get-Track)) {
                    if ($track.type -cne 'modules' -or $track.languages.Count -eq 0 -or $track.languages[0] -cne 'javascript') {
                        continue
                    }
                    foreach ($languageModule in @(Get-CatzcModule -Track $track.name)) {
                        if ($languageModule.shape -ceq 'folder') {
                            ([string] $languageModule.root).Replace('\', '/').TrimEnd('/')
                        }
                    }
                })

            $script:installs = @{}
            foreach ($kind in 'git', 'plain') {
                $root = Join-Path $TestDrive "install-$kind"
                [void][System.IO.Directory]::CreateDirectory($root)
                if ($kind -eq 'git') {
                    Invoke-FixtureGit -Root $root -Arguments @('init', '-q')
                }
                $script:installs[$kind] = Install-Catzc -Root $root -Source $build.BuildRoot -Silent
            }
        }
        catch {
            $script:built.Error = $_.Exception.Message
        }
    }

    It 'the full bundle builds and installs into a git root and a plain root' {
        $script:built.Error | Should -BeNullOrEmpty
        foreach ($kind in 'git', 'plain') {
            $script:installs[$kind].Importer | Should -Exist
        }
    }

    It 'every JavaScript module of the build plan ships in the form the plan records' {
        $script:built.Error | Should -BeNullOrEmpty
        $script:built.JavaScript.Count | Should -BeGreaterThan 0 -Because 'the tree holds JavaScript modules'
        foreach ($root in $script:built.JavaScript) {
            $entry = @($script:built.Entries | Where-Object { "$($_['path'])".Replace('\', '/').Trim('/') -ceq $root })
            $entry.Count | Should -Be 1 -Because "build.json names $root once"
            $folder = Join-Path $script:built.Root $root
            $extensions = @(Get-ChildPath $folder -File -Filter '*.vsix' -Depth 1 -Exclude @() -PruneVendor $false)
            $files = @(Get-ChildPath $folder -File -Depth 16 -Exclude @() -PruneVendor $false)
            switch ("$($entry[0]['form'])") {
                'vsix' {
                    $extensions.Count | Should -Be 1 -Because "$root is a registered extension"
                }
                'source' {
                    $extensions.Count | Should -Be 0 -Because "$root ships as source"
                    $files.Count | Should -BeGreaterThan 0
                }
                default {
                    "$($entry[0]['form'])" | Should -BeIn @('vsix', 'source') -Because "$root has a JavaScript form"
                }
            }
        }
    }

    It 'the python module python/diagrams ships as source, with wheels only when it holds a lock' {
        $script:built.Error | Should -BeNullOrEmpty
        $folder = Join-Path $script:built.Root 'python/diagrams'
        $folder | Should -Exist
        @(Get-ChildPath $folder -File -Depth 1 -Exclude @() -PruneVendor $false).Count | Should -BeGreaterThan 0
        $hasLock = [System.IO.File]::Exists((Join-Path $folder 'uv.lock'))
        if ($hasLock) {
            Join-Path $folder 'wheels.json' | Should -Exist
        }
        else {
            Join-Path $folder 'wheels.json' | Should -Not -Exist
            Join-Path $folder 'wheels' | Should -Not -Exist
        }
    }

    It 'a second packaging of each JavaScript module and of python/diagrams alone is byte-identical to the bundle''s' {
        $script:built.Error | Should -BeNullOrEmpty
        $jobs = @(foreach ($root in $script:built.JavaScript) {
                @{ Root = $root; Export = 'Export-JavaScriptModule' }
            }) + @(@{ Root = 'python/diagrams'; Export = 'Export-PythonModule' })
        foreach ($job in $jobs) {
            $again = Join-Path $TestDrive "again/$($job.Root)"
            $null = & $job.Export -Module $job.Root -Destination $again -Silent
            $second = @(Get-FolderBytes -Path $again)
            $first = @(Get-FolderBytes -Path (Join-Path $script:built.Root $job.Root))
            $second.Count | Should -BeGreaterThan 0 -Because "$($job.Root) packaged alone wrote no file"
            $second | Should -Be $first -Because "$($job.Root) packaged twice must write the same bytes"
        }
    }

    Context 'Go and bash gadget modules of a fixture repository' {
        BeforeAll {
            $script:fixture = @{ Error = $null; Folders = @{} }
            try {
                $repo = Join-Path $TestDrive 'gadget-repo'
                $goVersion = (Resolve-ToolExecutable -Tool go).Required
                $null = New-Item -ItemType Directory -Path (Join-Path $repo 'go/gadget'), (Join-Path $repo 'bash/gadget') -Force
                [System.IO.File]::WriteAllText((Join-Path $repo 'go/gadget/go.mod'), "module gadget`n`ngo $goVersion`n")
                [System.IO.File]::WriteAllText((Join-Path $repo 'go/gadget/main.go'), "package main`n`nimport `"os`"`n`nfunc main() {`n`tos.Stdout.WriteString(`"gadget\n`")`n}`n")
                [System.IO.File]::WriteAllText((Join-Path $repo 'bash/gadget/gadget.sh'), "#!/usr/bin/env bash`necho gadget`n")
                Invoke-FixtureGit -Root $repo -Arguments @('init', '-q')
                Invoke-FixtureGit -Root $repo -Arguments @('add', '-A')
                Invoke-FixtureGit -Root $repo -Arguments @('update-index', '--chmod=+x', 'bash/gadget/gadget.sh')
                $script:fixture.Repo = $repo
                $script:fixture.Plain = Join-Path $TestDrive 'plain-root'
                $null = New-Item -ItemType Directory -Path $script:fixture.Plain -Force

                Mock Get-RepositoryRoot -ModuleName Catzc.Base.Languages { $script:fixture.Repo }
                Mock Get-RepositoryRoot -ModuleName Catzc.Base.Files { $script:fixture.Repo }
                $goOut = Join-Path $TestDrive 'out/go-gadget'
                $bashOut = Join-Path $TestDrive 'out/bash-gadget'
                $null = Export-GoModule -Module 'go/gadget' -Destination $goOut -Platform (Get-HostPlatform) -Silent
                $null = Export-BashModule -Module 'bash/gadget' -Destination $bashOut -Silent
                $script:fixture.Folders['go/gadget'] = $goOut
                $script:fixture.Folders['bash/gadget'] = $bashOut
            }
            catch {
                $script:fixture.Error = $_.Exception.Message
            }
        }

        It 'the go gadget exports one host binary listed in binaries.json' {
            $script:fixture.Error | Should -BeNullOrEmpty
            $rows = @(ConvertFrom-Json -InputObject ([System.IO.File]::ReadAllText((Join-Path $script:fixture.Folders['go/gadget'] 'binaries.json'))))
            $rows.Count | Should -Be 1
            Join-Path $script:fixture.Folders['go/gadget'] $rows[0].path | Should -Exist
        }

        It 'the bash gadget exports its script listed in executables.json' {
            $script:fixture.Error | Should -BeNullOrEmpty
            $rows = @(ConvertFrom-Json -InputObject ([System.IO.File]::ReadAllText((Join-Path $script:fixture.Folders['bash/gadget'] 'executables.json'))))
            $rows.Count | Should -Be 1
            Join-Path $script:fixture.Folders['bash/gadget'] ([string] $rows[0]) | Should -Exist
        }

        foreach ($kind in 'git', 'plain') {
            foreach ($module in 'go/gadget', 'bash/gadget') {
                It "runs the $module export under a $kind root and exits 0" -ForEach @(@{ kind = $kind; module = $module }) {
                    $script:fixture.Error | Should -BeNullOrEmpty
                    $script:runRoot = $kind -ceq 'git' ? $script:fixture.Repo : $script:fixture.Plain
                    if ($kind -ceq 'plain') {
                        Join-Path $script:runRoot '.git' | Should -Not -Exist
                    }
                    Mock Get-RepositoryRoot -ModuleName Catzc.Base.Execution { $script:runRoot }
                    Mock Get-CatzcModuleRoot -ModuleName Catzc.Base.Execution -ParameterFilter { $Place } { $script:fixture.Folders["$Place/$Module"] }
                    $run = Invoke-LanguageModule -Module $module -PassThru -Silent
                    $run.ExitCode | Should -Be 0 -Because "$($run.Full)"
                    "$($run.Full)" | Should -BeLike '*gadget*'
                }
            }
        }
    }
}
