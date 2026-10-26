# pwsh/Base.TypesSystem/tests/Build-AgentHook.Tests.ps1

The tests of `Build-AgentHook` and of the shipped hooks it publishes.

## The publish stand-in

The tests stand in for `dotnet publish`: they copy this host's own executable to where the real publish puts the program, so it carries the
platform's real executable extension and resolves as an application.

## Package feeds

NuGet reads its config from the project's folder up, so each hook folder must see the generated root config's cleared feeds alone; a test
case per hook folder lists no package feed.
