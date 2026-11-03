Describe 'Get-LanguageModuleIssue' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:run = {
            param($Root, $Languages)
            & (Get-Module Catzc.Base.Exporter) { param($r,
                    $l) Get-LanguageModuleIssue -BuildRoot $r -Languages $l } $Root $Languages
        }

        # Lays out one packaged Widget module of a form under the widgets place; returns the languages list that records it.
        $script:addWidget = {
            param($Root, $Form)
            $buildRoot = $Root
            $write = {
                param($relative, $content)
                $target = Join-Path $buildRoot $relative
                [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($target)) | Out-Null
                [System.IO.File]::WriteAllText($target, $content)
            }
            $record = switch ($Form) {
                'source' {
                    & $write 'widgets/Widget/run.sh' '# widget'
                    & $write 'widgets/Widget/executables.json' "[`n  `"run.sh`"`n]`n"
                    @{ Files = 1; Executables = 1 }
                }
                'vsix' {
                    & $write 'widgets/Widget/acme.widget-1.0.0.vsix' 'PK'
                    @{ Files = 3 }
                }
                'binary' {
                    & $write 'widgets/Widget/linux-amd64/widget' 'ELF'
                    & $write 'widgets/Widget/binaries.json' "[`n  {`"path`":`"linux-amd64/widget`",`"sha256`":`"00`"}`n]`n"
                    @{ Platforms = 1 }
                }
                'wheels' {
                    & $write 'widgets/Widget/uv.lock' 'version = 1'
                    & $write 'widgets/Widget/wheels/gadget-1.0-py3-none-any.whl' 'PK'
                    & $write 'widgets/Widget/wheels.json' "[`n  {`"name`":`"gadget-1.0-py3-none-any.whl`",`"sha256`":`"00`"}`n]`n"
                    @{ Files = 1; Wheels = 1 }
                }
            }
            , @(@{ module = 'Widget'; form = $Form; path = 'widgets/Widget'; record = $record })
        }
    }

    BeforeEach {
        $script:root = Join-Path $TestDrive "$([System.Guid]::NewGuid().ToString('N'))/Catzc/1.2.3"
        [System.IO.Directory]::CreateDirectory($root) | Out-Null
    }

    It 'returns nothing for a packaged <Form> module' -ForEach @(
        @{ Form = 'source' }
        @{ Form = 'vsix' }
        @{ Form = 'binary' }
        @{ Form = 'wheels' }
    ) {
        $languages = & $script:addWidget $root $Form
        @(& $run $root $languages).Count | Should -Be 0
    }

    It 'returns nothing when no language is listed' {
        @(& $run $root @()).Count | Should -Be 0
    }

    It 'reports <Missing> when it is absent from a <Form> module' -ForEach @(
        @{ Form = 'source'; File = 'widgets/Widget/executables.json'; Message = "*language module 'widgets/Widget' (source) is missing its executables.json*"; Missing = 'its carrier' }
        @{ Form = 'vsix'; File = 'widgets/Widget/acme.widget-1.0.0.vsix'; Message = "*language module 'widgets/Widget' (vsix) is missing its extension*"; Missing = 'its extension' }
        @{ Form = 'binary'; File = 'widgets/Widget/linux-amd64/widget'; Message = "*language module 'widgets/Widget' (binary) is missing the binary linux-amd64/widget*"; Missing = 'a listed binary' }
        @{ Form = 'wheels'; File = 'widgets/Widget/wheels/gadget-1.0-py3-none-any.whl'; Message = "*language module 'widgets/Widget' (wheels) is missing the wheel gadget-1.0-py3-none-any.whl*"; Missing = 'a listed wheel' }
    ) {
        $languages = & $script:addWidget $root $Form
        [System.IO.File]::Delete((Join-Path $root $File))
        @(& $run $root $languages) | Should -BeLike $Message
    }

    It 'reports a recorded module that has no folder' {
        $languages = @(@{ module = 'Widget'; form = 'vsix'; path = 'widgets/Widget'; record = @{} })
        @(& $run $root $languages) | Should -BeLike "*language module 'widgets/Widget' (vsix) is recorded in build.json but has no folder*"
    }

    It 'reports a form it does not know' {
        $languages = & $script:addWidget $root 'vsix'
        $languages[0].form = 'gizmo'
        @(& $run $root $languages) | Should -BeLike "*language module 'widgets/Widget' (gizmo) records a form this check does not know*"
    }

    It 'reports a folder under the language place that no entry names' {
        $languages = & $script:addWidget $root 'vsix'
        [System.IO.Directory]::CreateDirectory((Join-Path $root 'widgets/Gizmo')) | Out-Null
        @(& $run $root $languages) |
            Should -BeLike "*folder 'widgets/Gizmo' is under the language place 'widgets' but no build.json languages entry names it*"
    }
}
