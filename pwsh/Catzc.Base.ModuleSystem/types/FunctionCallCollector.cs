/*
---
catzc:
  immutable:
    with_body_sha: fb6403b37483
  edges:
    test: pwsh/Catzc.Base.ModuleSystem/tests/types/FunctionCallCollector.Tests.ps1
    docs: "[FunctionCallCollector.cs.md](../../../docs/references/pwsh/catzc-base-module-system/types/FunctionCallCollector.cs.md)"
---
*/

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
