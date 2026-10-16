/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Repository/types/ParsedScripts.cs
    kind: csharp-type
    language: csharp
    track: automation
    module: Catzc.Base.Repository
    relatives:
      test: automation/Catzc.Base.Repository/tests/types/ParsedScripts.Tests.ps1
---
*/

// One call's parse of each script: a file is parsed once however many checks read it, and the holder dies with the call that made it.

using System;
using System.Collections.Generic;
using System.Management.Automation.Language;

namespace Catzc.Base.Repository;

public sealed class ParsedScripts
{
    // A parsed script: its tree, and the parse errors it came with (empty when it parsed cleanly).
    public sealed class Script
    {
        public string Path { get; }
        public ScriptBlockAst Ast { get; }
        public IReadOnlyList<ParseError> Errors { get; }

        internal Script(string path, ScriptBlockAst ast, IReadOnlyList<ParseError> errors)
        {
            Path = path;
            Ast = ast;
            Errors = errors;
        }

        public override string ToString() => $"Script {{ Path = {Path}, Errors = {Errors.Count} }}";
    }

    private readonly Dictionary<string, Script> scripts =
        new Dictionary<string, Script>(OperatingSystem.IsWindows() ? StringComparer.OrdinalIgnoreCase : StringComparer.Ordinal);

    // How many files were really parsed, so a caller or a test can see the sharing work.
    public int ParseCount { get; private set; }

    // The script at the path, parsed the first time it is asked for and the same instance after.
    public Script Get(string path)
    {
        if (string.IsNullOrWhiteSpace(path)) { throw new ArgumentException("a script path is required", nameof(path)); }
        string full = System.IO.Path.GetFullPath(path);
        Script script;
        if (scripts.TryGetValue(full, out script)) { return script; }

        Token[] tokens;
        ParseError[] errors;
        ScriptBlockAst ast = Parser.ParseFile(full, out tokens, out errors);
        script = new Script(full, ast, errors ?? Array.Empty<ParseError>());
        scripts[full] = script;
        ParseCount++;
        return script;
    }

    public override string ToString() => $"ParsedScripts {{ Parsed = {ParseCount} }}";
}
