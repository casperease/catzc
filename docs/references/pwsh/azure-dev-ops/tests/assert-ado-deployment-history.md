# pwsh/Azure.DevOps/tests/Assert-AdoDeploymentHistory.Tests.ps1

The L0 tests of the assertion that an environment's deployment history holds a successful deployment of a CI run's commit.

## Fixture runs

The fixture runs are small and distinct. Run 10 is the CI run that built commit `aaa` and run 11 built `bbb`. Runs 20 and 21 are DEPLOY runs
that name a CI run, and run 30 is a CD run.
