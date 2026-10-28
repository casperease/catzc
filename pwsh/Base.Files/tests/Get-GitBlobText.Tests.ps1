Describe 'Get-GitBlobText' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:widget = '1' * 40
        $script:gadget = '2' * 40
        $script:empty = '3' * 40
        $script:blobs = @{
            $script:widget = "# ADR-WIDGET-GADGET-SPIN`r`nfunction Get-Widget { }`n`n"
            $script:gadget = "$([char] 0xFEFF)gadget: true`n"
            $script:empty  = ''
        }
        # Stands in for git cat-file --batch=<format>: each line of stdin is one object, a name it cannot find answers '<name> missing'.
        $script:answer = {
            param([string] $Command, [string] $InputText)
            $marker = [regex]::Match($Command, '--batch=(\S+) ').Groups[1].Value
            $out = foreach ($name in ($InputText -split "`n" | Where-Object { $_ })) {
                if ($script:blobs.ContainsKey($name)) {
                    "$marker $name`n$($script:blobs[$name])`n"
                }
                else {
                    "$name missing`n"
                }
            }
            [Catzc.Base.Execution.CliResult]::new(($out -join ''), '', 0)
        }
    }

    BeforeEach {
        InModuleScope Catzc.Base.Files { $script:gitBlobTextCache = $null }
        Mock Invoke-Executable -ModuleName Catzc.Base.Files { & $script:answer $Command $InputText }
    }

    It 'reads every blob in one git process, byte-exact up to a leading byte-order mark' {
        $texts = Get-GitBlobText $script:widget, $script:gadget, $script:empty
        $texts[$script:widget] | Should -BeExactly $script:blobs[$script:widget]
        $texts[$script:gadget] | Should -BeExactly "gadget: true`n"
        $texts[$script:empty] | Should -BeExactly ''
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Files -Times 1 -Exactly -ParameterFilter {
            $Command -like 'git cat-file "--batch=catzc-blob-* %(objectname)"'
        }
    }

    It 'keeps each text under its blob id, so a second call reads only the blobs it has not seen' {
        $null = Get-GitBlobText $script:widget
        $null = Get-GitBlobText $script:widget, $script:gadget
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Files -Times 2 -Exactly
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Files -Times 1 -Exactly -ParameterFilter {
            $InputText -notlike "*$script:widget*"
        }
        $null = Get-GitBlobText $script:gadget, $script:widget
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Files -Times 2 -Exactly
    }

    It 'launches nothing for no blob' {
        (Get-GitBlobText @()).Count | Should -Be 0
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Files -Times 0 -Exactly
    }

    It 'refuses a blob id the repository does not hold' {
        { Get-GitBlobText $script:widget, ('9' * 40) } | Should -Throw "*'$('9' * 40)' is not a blob of this repository*"
    }

    It 'refuses a stream that ends without its closing marker' {
        Mock Invoke-Executable -ModuleName Catzc.Base.Files { [Catzc.Base.Execution.CliResult]::new('', '', 0) }
        { Get-GitBlobText $script:widget } | Should -Throw '*ends without its closing marker*'
    }
}

Describe 'Get-GitBlobText — the real repository' -Tag 'L2', 'integrity', 'source-only' {
    It 'reads a committed file''s text as git show reads it' {
        $blob = (Get-GitCommitTree)['importer.ps1']
        $shown = Invoke-Executable "git cat-file blob $blob" -PassThru -Silent
        (Get-GitBlobText $blob)[$blob].TrimEnd("`r", "`n") | Should -BeExactly $shown.Output
    }
}
