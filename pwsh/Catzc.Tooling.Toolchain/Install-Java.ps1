<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-tooling-toolchain/Install-Java.ps1.md"
  warning: "Generated Header"
---
#>

function Install-Java {
    [CmdletBinding()]
    param(
        [string] $Version = (Get-ToolConfig -Tool 'java').version,
        [switch] $Force
    )

    $config = Get-ToolConfig -Tool 'java'

    # Skip entirely if already at correct version — no install, no profile patching
    if (Test-Command $config.command) {
        $installed = Get-ToolVersion -Config $config
        if ($installed -and $installed.StartsWith($Version)) {
            Write-Message "Java $Version is already installed"
            return
        }
    }

    Install-Tool -Tool 'java' -Version $Version -Force:$Force

    # Resolve JAVA_HOME from the installed binary location
    $command = Get-Command $config.command -ErrorAction SilentlyContinue
    if (-not $command) {
        return
    }

    $javaHome = if ($IsWindows) {
        # winget installs to LOCALAPPDATA\Programs\Microsoft\jdk-<version>.*\
        $wingetJavaRoot = "$env:LOCALAPPDATA\Programs\Microsoft"
        $jdkDir = if ([System.IO.Directory]::Exists($wingetJavaRoot)) {
            Get-ChildPath $wingetJavaRoot -Directory -Filter "jdk-$Version*" -Depth 1 |
                Sort-Object { [System.IO.Path]::GetFileName($_) } -Descending |
                Select-Object -First 1
        }
        if ($jdkDir) {
            $jdkDir
        }
        else {
            Split-Path (Split-Path $command.Source)
        }
    }
    elseif ($IsMacOS) {
        $brewResult = Invoke-Executable "brew --prefix openjdk@$Version" -PassThru -NoAssert -Silent
        if ($brewResult.Output) {
            Join-Path -Path $brewResult.Output -ChildPath 'libexec' -AdditionalChildPath 'openjdk.jdk', 'Contents', 'Home'
        }
        else {
            Split-Path (Split-Path $command.Source)
        }
    }
    else {
        # Linux: /usr/lib/jvm/java-<version>-openjdk-<arch>
        $jvmDir = if ([System.IO.Directory]::Exists('/usr/lib/jvm')) {
            Get-ChildPath '/usr/lib/jvm' -Directory -Filter "java-$Version-openjdk-*" -Depth 1 |
                Select-Object -First 1
        }
        if ($jvmDir) {
            $jvmDir
        }
        else {
            Split-Path (Split-Path $command.Source)
        }
    }

    if (-not $javaHome -or -not (Test-Path $javaHome)) {
        Write-Verbose 'Could not resolve JAVA_HOME — skipping environment setup'
        return
    }

    if ($env:JAVA_HOME -ne $javaHome) {
        $env:JAVA_HOME = $javaHome
        Write-Message "Session: JAVA_HOME='$javaHome'"
    }

    # Persist for future sessions
    if ($IsWindows) {
        # the seam announces the change, and does nothing when the value is already set
        Set-PermanentEnvironmentVariable JAVA_HOME $javaHome
    }
    else {
        $marker = '>>> catzc Install-Java >>>'
        $profilePath = $PROFILE.CurrentUserCurrentHost
        $profileDir = Split-Path $profilePath
        if (-not (Test-Path $profileDir)) {
            New-Item -Path $profileDir -ItemType Directory -Force | Out-Null
        }
        $profileExists = Test-Path $profilePath
        $alreadyPatched = $profileExists -and (Get-Content $profilePath -Raw) -match [regex]::Escape($marker)

        if (-not $alreadyPatched) {
            $block = @"

# $marker
`$env:JAVA_HOME = "$javaHome"
# <<< catzc Install-Java <<<
"@
            Add-Content -Path $profilePath -Value $block
            Write-Message "Profile '$profilePath': added the JAVA_HOME block"
        }
    }

    Write-Verbose "JAVA_HOME set to '$javaHome'"
}
