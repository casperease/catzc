// catzc:
//   path: automation/Catzc.Tooling.Inspiration/types/Inspiration.cs
//   module: Catzc.Tooling.Inspiration

// Root is absolute because an inspiration lives outside the repository; the portable form stays in inspiration.yml.
// [ADR-REPO-INSPIRE#1](/docs/adr/repository/inspiration.md#rule-adr-repo-inspire1),
// [ADR-AUTO-PATH#5](/docs/adr/automation/path-representation.md#rule-adr-auto-path5)
// [comment:1](/docs/references/automation/catzc-tooling-inspiration/types/Inspiration.cs.md#comment1)

using System;

namespace Catzc.Tooling.Inspiration;

public sealed class Inspiration
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The inspiration's id (its inspiration.yml entry).
    public string Id { get; }

    // The root resolved on this machine: a normalized absolute path.
    public string Root { get; }

    // True when the root is an existing folder on this machine.
    public bool Available { get; }

    // What the inspiration is, in one sentence.
    public string Description { get; }

    // The folders inside the root worth reading, relative to it. Empty when the entry names none.
    public string[] Paths { get; }

    public Inspiration(string id, string root, bool available, string description, string[] paths)
    {
        if (string.IsNullOrWhiteSpace(id)) { throw new ArgumentException("Inspiration.Id is required"); }
        if (string.IsNullOrWhiteSpace(root)) { throw new ArgumentException("Inspiration.Root is required"); }
        Id = id;
        Root = root;
        Available = available;
        Description = description;
        Paths = paths ?? new string[0];
    }
}
