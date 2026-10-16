<#
---
catzc:
  immutable:
    path: automation/Catzc.Tooling.Toolchain/Uninstall-Java.ps1
    name: uninstall-java
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Tooling.Toolchain
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-tooling-toolchain/Uninstall-Java.ps1.md
    test: automation/Catzc.Tooling.Toolchain/tests/Uninstall-Java.Tests.ps1
    cites:
      - ADR-AUTO-CONSOLE#11
      - ADR-AUTO-ONEJOB#5
      - ADR-AUTO-REMOVE#{4,5}
  config:
    synopsis: Uninstalls Java via the platform package manager.
    description: |-
      Removes Java through the configured manager and clears JAVA_HOME (on Unix, removes the marker block from
      $PROFILE) — the managed uninstall. For a Java installed OUTSIDE the tooling system (a foreign JDK, an apt
      package on a uv-first box), escalate with -Remove -Force: the managed uninstall runs best-effort and then
      falls through to Remove-Java, which evicts whatever the configured manager did not own
      ([ADR-AUTO-REMOVE#5](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove5)).
    parameters:
      Version: Java version to uninstall. Defaults to the locked version in Get-ToolConfig.
      Remove: |-
        After the managed uninstall, escalate to Remove-Java to evict an off-config install. Pair with -Force to
        actually remove; -Remove alone reports the plan
        ([ADR-AUTO-REMOVE#4](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove4)).
      Force: Confirm the destructive Remove-Java step of the escalation. Ignored without -Remove.
    examples:
      - Uninstall-Java
      - Uninstall-Java -Remove -Force
---
#>

function Uninstall-Java {
    [CmdletBinding()]
    param(
        [string] $Version,
        [switch] $Remove,
        [switch] $Force
    )

    try {
        Uninstall-Tool -Tool 'java' -Version $Version

        if ($env:JAVA_HOME) {
            $env:JAVA_HOME = $null
            Write-Message 'Session: removed JAVA_HOME'
        }

        if ($IsWindows) {
            # the seam announces the removal, and does nothing when JAVA_HOME is not set
            Set-PermanentEnvironmentVariable JAVA_HOME $null
        }
        else {
            $marker = '>>> catzc Install-Java >>>'
            $endMarker = '<<< catzc Install-Java <<<'
            $profilePath = $PROFILE.CurrentUserCurrentHost

            if (Test-Path $profilePath) {
                $content = Get-Content $profilePath -Raw
                if ($content -match [regex]::Escape($marker)) {
                    $pattern = "(?ms)\r?\n# $([regex]::Escape($marker)).*?# $([regex]::Escape($endMarker))\r?\n?"
                    $cleaned = $content -replace $pattern, ''
                    Set-Content -Path $profilePath -Value $cleaned -NoNewline
                    Write-Message "Profile '$profilePath': removed the JAVA_HOME block"
                }
            }
        }
    }
    catch {
        if (-not $Remove) {
            throw
        }
        Write-Message "Managed uninstall did not apply ($($_.Exception.Message.Trim())); escalating to Remove-Java."
    }

    if ($Remove) {
        Remove-Java -Force:$Force
    }
}
