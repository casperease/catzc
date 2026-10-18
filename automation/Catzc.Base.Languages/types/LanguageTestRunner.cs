using System;
using System.Collections.Generic;

namespace Catzc.Base.Languages;

// How a test-artifact language's tests run: the command that runs them, the tools that must resolve first, and the parameter the tool's
// path binds to ([ADR-AUTO-MODULE#6](/docs/adr/automation/module-model.md#rule-adr-auto-module6)).
public sealed class LanguageTestRunner
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The command that runs one module's tests of the language and returns one result per test (e.g. Invoke-GoTest).
    public string runner { get; }

    // The tools that must resolve at their locked version before a run; the first one's path is the one passed to the runner. Empty for a
    // language whose tests run under an engine of their own.
    public IReadOnlyList<string> tools { get; }

    // The runner's parameter that takes the executable's path (e.g. GoExecutable).
    public string executable { get; }

    // The engine the tests run under when the language is one of the engines (bash); its executable is the one passed, and the runner
    // takes no engine argument. Null when the tests run under every engine.
    public string engine { get; }

    // The name a missing-executable skip reason carries: the engine, else the first tool.
    public string ExecutableName => engine ?? tools[0];

    public LanguageTestRunner(string runner, string[] tools, string executable, string engine)
    {
        this.runner = runner;
        this.tools = tools == null ? Array.Empty<string>() : (string[])tools.Clone();
        this.executable = executable;
        this.engine = engine;
    }
}
