# pwsh/Tooling.Provisioning/tests/Install-Postman.Tests.ps1

The tests of `Install-Postman`. As with `Install-Git`, the install is a live download from dl.pstmn.io, best proven by an L2 or manual run.
These L0 tests cover the hermetic idempotent-skip decision on every platform, with the download and CLI boundaries mocked so nothing is
fetched, extracted or launched.
