/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-languages/types/LanguageTestRunner.cs.md"
  header: "generated"
---
*/

using System;
using System.Collections.Generic;

namespace Catzc.Base.Languages;

// The runner command, the tools that resolve first, and the parameter the tool's path binds to.
public sealed class LanguageTestRunner
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The command that runs one module's tests of the language and returns one result per test (e.g. Invoke-GoTest).
    public string runner { get; }

    // The first tool's path is the one passed; empty when the tests run under an engine of their own.
    public IReadOnlyList<string> tools { get; }

    // The runner's parameter that takes the executable's path (e.g. GoExecutable).
    public string executable_parameter { get; }

    // Set when the language is an engine (bash); null when the tests run under every engine.
    public string engine { get; }

    // The file-name glob that makes a file a test file of the language (e.g. test_*.py); a folder holding one is a test folder.
    public string pattern { get; }

    // The name a missing-executable skip reason carries: the engine, else the first tool.
    public string ExecutableName => engine ?? tools[0];

    public LanguageTestRunner(string runner, string[] tools, string executableParameter, string engine, string pattern)
    {
        this.runner = runner;
        this.tools = tools == null ? Array.Empty<string>() : (string[])tools.Clone();
        executable_parameter = executableParameter;
        this.engine = engine;
        this.pattern = pattern;
    }
}
