/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-tooling-inspiration/types/Inspiration.cs.md"
  header: "generated"
---
*/

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
