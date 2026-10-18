using System;
using System.Collections.Generic;

namespace Catzc.Base.Languages;

public sealed class LanguageTestRunner
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The command that runs one module's tests of the language and returns one result per test (e.g. Invoke-GoTest).
    public string runner { get; }

    public IReadOnlyList<string> tools { get; }

    // The runner's parameter that takes the executable's path (e.g. GoExecutable).
    public string executable { get; }

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
