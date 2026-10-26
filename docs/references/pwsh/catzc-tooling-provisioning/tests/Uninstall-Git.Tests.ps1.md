# pwsh/Tooling.Provisioning/tests/Uninstall-Git.Tests.ps1

The tests of `Uninstall-Git`. Every file system, PATH and CLI boundary is mocked, so nothing is removed for real and no process launches; the
L0 tripwire would throw on a real `Invoke-Executable`. The platform branches skip themselves off their platform.
