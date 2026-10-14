BeforeAll {
    # An isolated sandbox = importer + the .internal shared modules + vendor, with no application modules, imported in a
    # fresh child pwsh (the same shape as Import-AllModules.Tests.ps1). Capturing the child's output redirects its
    # standard output, which is the case under test.
    $script:sandbox = Join-Path ([System.IO.Path]::GetTempPath()) "redirected-encoding-$([guid]::NewGuid().ToString('N'))"
    $sandboxAuto = Join-Path $script:sandbox 'automation'
    [System.IO.Directory]::CreateDirectory($sandboxAuto) | Out-Null
    Copy-Item -Path (Join-Path $env:RepositoryRoot 'importer.ps1') -Destination $script:sandbox
    Copy-Directory (Join-Path $env:RepositoryRoot 'automation/.internal') (Join-Path $sandboxAuto '.internal')
    Copy-Directory (Join-Path $env:RepositoryRoot 'automation/.vendor') (Join-Path $sandboxAuto '.vendor')

    # ONE cold import, with its verbose load record merged into the captured output. The child gets its own console
    # (CreateNoWindow): assigning the output encoding sets the code page of the console a process is attached to, so a
    # child sharing this worker's console would inherit whatever the worker's own import already set.
    $childScript = ". '$script:sandbox/importer.ps1' -Verbose 4>&1 6>`$null; " +
    "'codepage=' + [Console]::OutputEncoding.CodePage; 'redirected=' + [Console]::IsOutputRedirected"
    $startInfo = [System.Diagnostics.ProcessStartInfo]::new('pwsh')
    foreach ($argument in '-NoProfile', '-Command', $childScript) {
        $startInfo.ArgumentList.Add($argument)
    }
    $startInfo.UseShellExecute = $false
    $startInfo.CreateNoWindow = $true
    $startInfo.RedirectStandardOutput = $true
    $startInfo.RedirectStandardError = $true
    $startInfo.StandardOutputEncoding = [System.Text.UTF8Encoding]::new($false)
    $process = [System.Diagnostics.Process]::Start($startInfo)
    $errorTask = $process.StandardError.ReadToEndAsync()
    $standardOutput = $process.StandardOutput.ReadToEnd()
    $process.WaitForExit()
    $script:output = @($standardOutput -split '\r?\n' | Where-Object { $_ })
    $script:errorOutput = $errorTask.Result
    $script:exitCode = $process.ExitCode
}

AfterAll {
    if ($script:sandbox -and [System.IO.Directory]::Exists($script:sandbox)) {
        [System.IO.Directory]::Delete($script:sandbox, $true)
    }
}

Describe 'Set-RedirectedOutputEncoding' -Tag 'L1', 'logic', 'ADR-AUTO-ANNOUNCE#1' {
    It 'imports cleanly in a redirected child session' {
        $script:exitCode | Should -Be 0 -Because $script:errorOutput
        $script:output | Should -Contain 'redirected=True'
    }

    It 'leaves a redirected session writing UTF-8' {
        $script:output | Should -Contain 'codepage=65001'
    }

    It 'announces the change on the importer''s verbose load record' -Tag 'ADR-AUTO-ANNOUNCE#6' {
        @($script:output | Where-Object { $_ -like '*console output encoding UTF-8 (output is redirected)*' }).Count | Should -Be 1
    }
}
