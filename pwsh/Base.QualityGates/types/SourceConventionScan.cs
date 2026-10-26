using System;
using System.Collections.Generic;
using System.Management.Automation.Language;

namespace Catzc.Base.QualityGates;

public sealed class SourceConventionScan : AstVisitor2
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    static readonly HashSet<string> BlockCommandNames = new HashSet<string>(StringComparer.OrdinalIgnoreCase) { "Describe", "Context", "It" };

    // The attributes, array literals and switch statements, in the order Ast.FindAll returns them.
    public List<Ast> ListNodes { get; } = new List<Ast>();

    // The Describe, Context and It commands, in the order Ast.FindAll returns them.
    public List<CommandAst> BlockCommands { get; } = new List<CommandAst>();

    // The string constants and expandable strings, nested ones too, in the order Ast.FindAll returns them.
    public List<Ast> Strings { get; } = new List<Ast>();

    SourceConventionScan()
    {
    }

    public static SourceConventionScan Scan(Ast root)
    {
        if (root == null) { throw new ArgumentNullException(nameof(root)); }
        var scan = new SourceConventionScan();
        root.Visit(scan);
        return scan;
    }

    public override AstVisitAction VisitAttribute(AttributeAst attributeAst)
    {
        ListNodes.Add(attributeAst);
        return AstVisitAction.Continue;
    }

    public override AstVisitAction VisitArrayLiteral(ArrayLiteralAst arrayLiteralAst)
    {
        ListNodes.Add(arrayLiteralAst);
        return AstVisitAction.Continue;
    }

    public override AstVisitAction VisitSwitchStatement(SwitchStatementAst switchStatementAst)
    {
        ListNodes.Add(switchStatementAst);
        return AstVisitAction.Continue;
    }

    public override AstVisitAction VisitCommand(CommandAst commandAst)
    {
        string name = commandAst.GetCommandName();
        if (name != null && BlockCommandNames.Contains(name)) { BlockCommands.Add(commandAst); }
        return AstVisitAction.Continue;
    }

    public override AstVisitAction VisitStringConstantExpression(StringConstantExpressionAst stringConstantExpressionAst)
    {
        Strings.Add(stringConstantExpressionAst);
        return AstVisitAction.Continue;
    }

    public override AstVisitAction VisitExpandableStringExpression(ExpandableStringExpressionAst expandableStringExpressionAst)
    {
        Strings.Add(expandableStringExpressionAst);
        return AstVisitAction.Continue;
    }
}
