# pwsh/Tooling.Provisioning/tests/Install-Git.Tests.ps1

The tests of `Install-Git`. The install is mostly a live-download integration: the GitHub API, a verified download and a self-extracting
installer. That path earns its confidence from an L2 or manual run, not from mocking every step. These L0 tests cover the hermetic,
high-value decisions, the idempotent skip and the platform delegation, with every external boundary mocked so nothing downloads, extracts or
launches.
