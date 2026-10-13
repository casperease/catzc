// One statically named command call inside a function body: the command name as written and the line it starts on.
// Collected by FunctionCallCollector for Test-FunctionDependency.
//
// BCL only; declares its module namespace (file-scoped), per the type loader. PascalCase (a result shape).

using System;

namespace Catzc.Base.ModuleSystem;

public sealed class FunctionCall
{
    public string Name { get; }
    public int Line { get; }

    public FunctionCall(string name, int line)
    {
        if (string.IsNullOrEmpty(name)) { throw new ArgumentException("FunctionCall.Name is required"); }
        Name = name;
        Line = line;
    }

    public override string ToString() => Name + ":" + Line;
}
