# .ado/pipelines/steps/invoke-automation.yaml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `parameters:`, written with `#`.

```text
Unified step template for running PowerShell automation commands.

Usage:
  - template: /.ado/pipelines/steps/invoke-automation.yaml
    parameters:
      RunCommand: 'Test-Automation'

  - template: /.ado/pipelines/steps/invoke-automation.yaml
    parameters:
      RunCommand: |
        Build-Bicep -Template sample -Environments dev
        Deploy-Bicep -Environment dev -Template sample
      Mode: azcli
      ServiceConnection: 'sc-my-subscription'

Security: all flags default to off. Each flag is an explicit escalation.
No credentials leak to environment variables in any mode.
See ADR: [FDR-CD-RUNNER](/docs/drs/flow/pipeline-runner-pattern.md)
```
