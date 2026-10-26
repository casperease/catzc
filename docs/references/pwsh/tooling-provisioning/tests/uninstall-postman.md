# pwsh/Tooling.Provisioning/tests/Uninstall-Postman.Tests.ps1

The tests of `Uninstall-Postman`. Every file system and CLI boundary is mocked, so nothing is removed for real and no process launches; the
L0 tripwire throws on a real `Invoke-Executable`. The platform branches skip themselves off their platform.
