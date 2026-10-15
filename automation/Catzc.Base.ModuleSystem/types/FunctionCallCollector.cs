// Collects, per top-level function of a parsed.ps1 file, the commands its body calls and the names of the functions nested inside it —...
// [comment:1](/docs/references/automation/catzc-base-modulesystem/types/FunctionCallCollector.cs.md#comment1)

using System;
using System.Collections.Generic;
using System.Management.Automation.Language;

namespace Catzc.Base.ModuleSystem;

public sealed class FunctionCallCollector : AstVisitor2
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public FunctionDefinitionAst Function { get; }
    public List<string> NestedFunctionNames { get; } = new List<string>();
    public List<FunctionCall> Calls { get; } = new List<FunctionCall>();

    FunctionCallCollector(FunctionDefinitionAst function)
    {
        Function = function;
    }

    public static FunctionCallCollector[] Collect(ScriptBlockAst file)
    {
        if (file == null) { throw new ArgumentNullException(nameof(file)); }
        var collectors = new List<FunctionCallCollector>();
        foreach (Ast node in file.FindAll(n => n is FunctionDefinitionAst && n.Parent?.Parent == file, false))
        {
            var collector = new FunctionCallCollector((FunctionDefinitionAst)node);
            collector.Function.Body.Visit(collector);
            collectors.Add(collector);
        }
        return collectors.ToArray();
    }

    public override AstVisitAction VisitFunctionDefinition(FunctionDefinitionAst functionDefinitionAst)
    {
        NestedFunctionNames.Add(functionDefinitionAst.Name);
        return AstVisitAction.Continue;
    }

    public override AstVisitAction VisitCommand(CommandAst commandAst)
    {
        string name = commandAst.GetCommandName();
        if (!string.IsNullOrEmpty(name)) { Calls.Add(new FunctionCall(name, commandAst.Extent.StartLineNumber)); }
        return AstVisitAction.Continue;
    }
}
