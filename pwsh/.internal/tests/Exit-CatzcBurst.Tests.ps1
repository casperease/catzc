<#
---
catzc:
  immutable:
    with_body_sha: cf97aa75782b
---
#>

Describe 'Exit-CatzcBurst' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:exit = Join-Path $PSScriptRoot '../assets/Exit-CatzcBurst.ps1'
    }

    It 'throws when no burst holds the lock' {
        $name = "Local\catzc-test-$([guid]::NewGuid())"
        { & $script:exit -LockName $name } | Should -Throw "*no burst holds $name*"
    }

    It 'sets the burst event a holding burst waits on' {
        $name = "Local\catzc-test-$([guid]::NewGuid())"
        $burst = [System.Threading.EventWaitHandle]::new($false, [System.Threading.EventResetMode]::ManualReset, "$name-burst")
        try {
            & $script:exit -LockName $name | Should -BeExactly "[Exit-CatzcBurst] ended the burst on $name"
            $burst.WaitOne(0) | Should -BeTrue
        }
        finally {
            $burst.Dispose()
        }
    }
}
