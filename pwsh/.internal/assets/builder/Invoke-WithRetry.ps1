function Invoke-WithRetry {
    [CmdletBinding()]
    param(
        # The one external operation to repeat; it must be safe to repeat
        # ([ADR-AUTO-RETRY-IDEMPOTENTONLY](/docs/drs/automation/retry-as-last-resort.md#rule-adr-auto-retry-idempotentonly)).
        [Parameter(Mandatory)]
        [scriptblock] $Operation,

        # Names the operation in each retry warning.
        [Parameter(Mandatory)]
        [string] $Name,

        [ValidateRange(1, 100)]
        [int] $Attempts = 8,

        [ValidateRange(0, 10000)]
        [int] $DelayMilliseconds = 250,

        # The exception types read as transient; any other failure throws at once.
        [type[]] $TransientTypes = @([System.IO.IOException], [System.UnauthorizedAccessException])
    )

    # A fixed attempt count and one warning per retry
    # ([ADR-AUTO-RETRY-BOUNDEDANDVISIBLE](/docs/drs/automation/retry-as-last-resort.md#rule-adr-auto-retry-boundedandvisible)); the last failure throws as it is.
    for ($attempt = 1; ; $attempt++) {
        try {
            return & $Operation
        }
        catch {
            $exception = $_.Exception
            if ($exception -is [System.Management.Automation.MethodInvocationException] -and $null -ne $exception.InnerException) {
                $exception = $exception.InnerException
            }
            $transient = $false
            foreach ($type in $TransientTypes) {
                if ($exception -is $type) {
                    $transient = $true
                    break
                }
            }
            if (-not $transient -or $attempt -ge $Attempts) {
                throw
            }
            Write-Message -Warning "$Name failed on attempt $attempt of $Attempts ($($exception.Message)); retrying in $DelayMilliseconds ms."
            Start-Sleep -Milliseconds $DelayMilliseconds
        }
    }
}
