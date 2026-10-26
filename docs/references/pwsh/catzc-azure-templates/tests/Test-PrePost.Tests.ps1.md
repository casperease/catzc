# pwsh/Azure.Templates/tests/Test-PrePost.Tests.ps1

The L0 tests of the PrePost starter, `Catzc.Azure.Templates/assets/PrePost.psm1`, the copy-in template that authors clone into
`infrastructure/templates/<name>/PrePost.psm1`.

## Importing the starter

Production code does not load the starter. These tests import it explicitly to verify that it is a working no-op baseline.

## Mandatory parameters

The parameter under test is passed as null, with the others supplied, so mandatory binding throws instead of prompting. Omitting a mandatory
parameter entirely hangs an interactive host waiting for input. The same holds for `DeploymentOutput`, which is passed explicitly as null
and not omitted.
