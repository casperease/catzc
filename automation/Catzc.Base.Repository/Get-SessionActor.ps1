<#
.SYNOPSIS
    Returns who is running this session: Pipeline, Agent, or Person.
.DESCRIPTION
    The one answer every actor-dependent behaviour reads, so the policy lives in one place
    ([ADR-AUTO-TYPES#13](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types13)). A CI/CD pipeline
    (Test-IsRunningInPipeline) wins over an agent, because an agent's run inside a pipeline is still a pipeline run;
    otherwise an AI coding agent (Test-IsRunningAsAgent); otherwise a person at a devbox. A person may change the
    machine and the repository on their own behalf — stop their stale sessions, commit generated files — while an
    agent leaves both to the person, and a pipeline only asserts.
.OUTPUTS
    [string] 'Pipeline', 'Agent', or 'Person'.
.EXAMPLE
    Get-SessionActor
.EXAMPLE
    if ((Get-SessionActor) -eq 'Person') { Sync-GeneratedFile }
#>
function Get-SessionActor {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    if (Test-IsRunningInPipeline) {
        return 'Pipeline'
    }
    if (Test-IsRunningAsAgent) {
        return 'Agent'
    }
    'Person'
}
