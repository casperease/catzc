# pwsh/Base.Languages/types/LanguageTestRunner.cs

How a test-artifact language's tests run: the command that runs them, the tools that must resolve first, and the parameter the tool's path
binds to ([ADR-AUTO-MODULE-CHECKSBYLANGUAGE](../../../../drs/automation/module-model.md#rule-adr-auto-module-checksbylanguage)).

## Properties

- **`tools`** — the tools that must resolve at their locked version before a run; the first one's path is the one passed to the runner.
  Empty for a language whose tests run under an engine of their own.
- **`engine`** — the engine the tests run under when the language is one of the engines (bash); its executable is the one passed, and the
  runner takes no engine argument. Null when the tests run under every engine.
