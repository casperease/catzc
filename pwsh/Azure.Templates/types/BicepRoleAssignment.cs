using System;

namespace Catzc.Azure.Templates;

// One role assignment a compiled template makes in one slot, as the compliance evaluator reads it offline.
public sealed class BicepRoleAssignment
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The template that makes the assignment. Always present.
    public string template { get; }

    // The slot's coordinate, its customer, environment and slot joined by '.', as its parameters file names it. Always present.
    public string slot { get; }

    // The object id of the group or managed identity that receives the role; the empty string when it does not resolve offline.
    public string principal { get; }

    // The roles.yml name of the role, or its definition id when roles.yml names none; the empty string when it does not resolve offline.
    public string role { get; }

    public string scope { get; }

    // The attribute-based condition that narrows the assignment; the empty string, never null, when it carries none.
    public string condition { get; }

    public BicepRoleAssignment(string template, string slot, string principal, string role, string scope, string condition)
    {
        if (string.IsNullOrWhiteSpace(template)) { throw new ArgumentException("BicepRoleAssignment.template is required"); }
        if (string.IsNullOrWhiteSpace(slot)) { throw new ArgumentException("BicepRoleAssignment.slot is required"); }
        this.template = template;
        this.slot = slot;
        this.principal = principal ?? "";
        this.role = role ?? "";
        this.scope = scope ?? "";
        this.condition = condition ?? "";
    }
}
