// One inspiration as Get-Inspiration reports it on this machine: its id, where its root resolves here, whether that
// root exists, what it is, and the folders inside it worth reading
// ([ADR-REPO-INSPIRE#1](/docs/adr/repository/inspiration.md#rule-adr-repo-inspire1)). An inspiration that is absent is
// reported with Available false, never thrown on: the work carries on without it.
//
// Root is absolute. An inspiration lives outside the repository, so no repository-relative form exists and the path
// degrades to a normalized absolute ([ADR-AUTO-PATH#5](/docs/adr/automation/path-representation.md#rule-adr-auto-path5));
// the stored, portable form stays in inspiration.yml.

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
