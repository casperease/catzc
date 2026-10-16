/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Repository/types/SyntaxSearch.cs
    kind: type
    language: csharp
    filetype: cs
    track: automation
    module: Catzc.Base.Repository
    moduletype: pwsh-folder-module
    bundle: azure
    relatives:
      test: automation/Catzc.Base.Repository/tests/types/SyntaxSearch.Tests.ps1
---
*/

// A scriptblock handed to FindAll runs once per node and allocates about 2 KB each time; these compiled walks allocate almost nothing.

using System;
using System.Collections.Generic;
using System.Management.Automation.Language;

namespace Catzc.Base.Repository;

public static class SyntaxSearch
{
    // Every command call under the node, in document order, nested script blocks included.
    public static IReadOnlyList<CommandAst> Commands(Ast root)
    {
        return Find<CommandAst>(root, node => node is CommandAst, true);
    }

    // The command calls whose name is `name`, ignoring case; with includeQualified, also `<module>\name`. A dynamic call name never matches.
    public static IReadOnlyList<CommandAst> CommandsNamed(Ast root, string name, bool includeQualified)
    {
        if (string.IsNullOrEmpty(name)) { throw new ArgumentException("a command name is required", nameof(name)); }
        string qualifiedEnd = "\\" + name;
        return Find<CommandAst>(root, node =>
        {
            CommandAst command = node as CommandAst;
            string commandName = command == null ? null : command.GetCommandName();
            if (commandName == null) { return false; }
            return commandName.Equals(name, StringComparison.OrdinalIgnoreCase)
                || (includeQualified && commandName.EndsWith(qualifiedEnd, StringComparison.OrdinalIgnoreCase));
        }, true);
    }

    // The reads of the variable `name` (a bare name such as PSScriptRoot), ignoring case, nested script blocks included.
    public static IReadOnlyList<VariableExpressionAst> VariableReads(Ast root, string name)
    {
        if (string.IsNullOrEmpty(name)) { throw new ArgumentException("a variable name is required", nameof(name)); }
        return Find<VariableExpressionAst>(root, node =>
        {
            VariableExpressionAst variable = node as VariableExpressionAst;
            return variable != null && variable.VariablePath.UserPath.Equals(name, StringComparison.OrdinalIgnoreCase);
        }, true);
    }

    // The functions defined directly in the script's own blocks, not those nested inside another function or script block.
    public static IReadOnlyList<FunctionDefinitionAst> TopLevelFunctions(ScriptBlockAst root)
    {
        return Find<FunctionDefinitionAst>(root, node => node is FunctionDefinitionAst && node.Parent != null && ReferenceEquals(node.Parent.Parent, root), false);
    }

    private static IReadOnlyList<T> Find<T>(Ast root, Func<Ast, bool> predicate, bool searchNestedScriptBlocks) where T : Ast
    {
        if (root == null) { throw new ArgumentNullException(nameof(root)); }
        List<T> found = new List<T>();
        foreach (Ast node in root.FindAll(predicate, searchNestedScriptBlocks)) { found.Add((T)node); }
        return found;
    }
}
