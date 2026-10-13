# Parity (ADR-DSGN-RUNMODE:2): every built module is the same module as its source folder — its exported command
# set equals the folder's public function files, and its private function set equals the folder's private/ files.
# The source side is read from the files; the build side from the modules as a build-mode session actually loads
# them. source-only: it compares the source tree with a fresh build of it, entered in its own child pwsh, so the
# answer does not depend on the mode of the session running it. greedy: one full build plus one importer-loading
# child pwsh.
Describe 'Built modules match their source folders' -Tag 'L2', 'integrity', 'greedy', 'source-only', 'ADR-DSGN-RUNMODE#2' {
    BeforeAll {
        # '<=name' for a source-only entry, '=>name' for a build-only one; empty when the sets are equal.
        function Get-SetDifference {
            param([string[]] $Expected = @(), [string[]] $Actual = @())
            foreach ($name in $Expected) {
                if ($name -notin $Actual) {
                    "<=$name"
                }
            }
            foreach ($name in $Actual) {
                if ($name -notin $Expected) {
                    "=>$name"
                }
            }
        }

        $script:buildAvailable = [bool](Get-Command Build-Modules -ErrorAction Ignore)
        if ($script:buildAvailable) {
            Import-InternalModule TestKit
            # The default selection — the exporter's default profile — so every module it ships is compared.
            $script:handle = New-BuiltCatzcRoot
            $built = Invoke-InBuiltCatzc -Handle $script:handle -ArgumentList (, @($script:handle.Modules)) -ScriptBlock {
                param([string[]] $Names)
                foreach ($name in $Names) {
                    $module = Get-Module $name
                    $defined = if ($module) {
                        @(& $module {
                                param($ModuleName)
                                foreach ($function in (Get-ChildItem function:)) {
                                    if ($function.ModuleName -eq $ModuleName) {
                                        $function.Name
                                    }
                                }
                            } $name)
                    }
                    [pscustomobject]@{
                        Name     = $name
                        Loaded   = [bool]$module
                        Exported = @(if ($module) {
                                $module.ExportedFunctions.Keys
                            })
                        Defined  = $defined
                    }
                }
            }
            $script:builtByName = @{}
            foreach ($entry in @($built)) {
                $script:builtByName[$entry.Name] = $entry
            }

            # The source side, from the files: public = <Module>/*.ps1, private = <Module>/private/*.ps1.
            $script:sourceByName = @{}
            foreach ($name in $script:handle.Modules) {
                $folder = Join-Path (Get-RepositoryRoot) "automation/$name"
                $public = @([System.IO.Directory]::GetFiles($folder, '*.ps1') | ForEach-Object { [System.IO.Path]::GetFileNameWithoutExtension($_) })
                $privateFolder = Join-Path $folder 'private'
                $private = @(if ([System.IO.Directory]::Exists($privateFolder)) {
                        [System.IO.Directory]::GetFiles($privateFolder, '*.ps1') | ForEach-Object { [System.IO.Path]::GetFileNameWithoutExtension($_) }
                    })
                $script:sourceByName[$name] = [pscustomobject]@{ Public = $public; Private = $private }
            }
        }
    }
    AfterAll {
        if ($script:buildAvailable -and $script:handle) {
            Remove-BuiltCatzcRoot $script:handle
        }
    }

    It 'built at least one module, and loaded every one it built' {
        if (-not $script:buildAvailable) {
            Set-ItResult -Skipped -Because 'tool_build_modules_missing'
            return
        }
        @($script:handle.Modules).Count | Should -BeGreaterThan 0
        $missing = @($script:handle.Modules | Where-Object { -not $script:builtByName[$_].Loaded })
        $missing | Should -BeNullOrEmpty -Because 'every built module loads in build mode'
    }

    It 'exports exactly the public functions of each source folder' {
        if (-not $script:buildAvailable) {
            Set-ItResult -Skipped -Because 'tool_build_modules_missing'
            return
        }
        $drift = foreach ($name in $script:handle.Modules) {
            $expected = @($script:sourceByName[$name].Public | Sort-Object)
            $actual = @($script:builtByName[$name].Exported | Sort-Object)
            $difference = @(Get-SetDifference -Expected $expected -Actual $actual)
            if ($difference.Count -gt 0) {
                "$name exports differ: $($difference -join ', ')"
            }
        }
        @($drift) | Should -BeNullOrEmpty -Because "built exports must equal the source folder's public files (<= source only, => build only):`n$($drift -join "`n")"
    }

    It 'carries exactly the private functions of each source folder' {
        if (-not $script:buildAvailable) {
            Set-ItResult -Skipped -Because 'tool_build_modules_missing'
            return
        }
        $drift = foreach ($name in $script:handle.Modules) {
            $exported = @($script:builtByName[$name].Exported)
            $expected = @($script:sourceByName[$name].Private | Sort-Object)
            $actual = @($script:builtByName[$name].Defined | Where-Object { $_ -notin $exported } | Sort-Object)
            $difference = @(Get-SetDifference -Expected $expected -Actual $actual)
            if ($difference.Count -gt 0) {
                "$name privates differ: $($difference -join ', ')"
            }
        }
        @($drift) | Should -BeNullOrEmpty -Because "built private functions must equal the source folder's private/ files (<= source only, => build only):`n$($drift -join "`n")"
    }
}
