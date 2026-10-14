// The stored form of an inspiration's root and its resolution to binding form. A root is stored in communication
// form ([ADR-AUTO-PATH#6](/docs/adr/automation/path-representation.md#rule-adr-auto-path6)): repository-relative, or
// anchored on the {workspace} anchor — the parent folder of the repository root, where sibling checkouts live
// ([ADR-AUTO-PATH#11](/docs/adr/automation/path-representation.md#rule-adr-auto-path11)). Resolve turns either into a
// '/'-separated absolute path, the binding form ([ADR-AUTO-PATH#3](/docs/adr/automation/path-representation.md#rule-adr-auto-path3)).
//
// The repository root reaches the resolver in the view of the shell that set it: 'C:\projects\catzc' under pwsh,
// '/c/projects/catzc' under Git Bash. ToNative maps both to one form, so the two shells resolve a root identically.
// The platform is a parameter, not a probe, so every branch is deterministic and testable on any OS.

using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Catzc.Tooling.Inspiration;

public static class InspirationRoot
{
    // The workspace anchor token, the parent folder of the repository root.
    public const string WorkspaceAnchor = "{workspace}";

    private static readonly Regex DriveLetter = new Regex("^[A-Za-z]:");
    private static readonly Regex MsysDrive = new Regex("^/([A-Za-z])(/|$)");

    // True when the stored root is anchored on {workspace}.
    public static bool IsWorkspaceAnchored(string root)
    {
        return root != null && root.StartsWith(WorkspaceAnchor + "/", StringComparison.Ordinal);
    }

    // Every way a stored path breaks communication form, as messages naming 'label'. A root may carry the
    // {workspace} anchor as its first segment (allowAnchor); a path inside a root never does. Empty when valid.
    public static string[] Violations(string label, string value, bool allowAnchor)
    {
        List<string> errors = new List<string>();
        if (string.IsNullOrWhiteSpace(value))
        {
            errors.Add(string.Format("{0} is empty", label));
            return errors.ToArray();
        }
        if (value.Contains("\\")) { errors.Add(string.Format("{0} '{1}' contains a backslash (use '/')", label, value)); }
        if (DriveLetter.IsMatch(value)) { errors.Add(string.Format("{0} '{1}' has a drive letter (store a relative or {2}-anchored path)", label, value, WorkspaceAnchor)); }
        else if (value.StartsWith("/", StringComparison.Ordinal)) { errors.Add(string.Format("{0} '{1}' is absolute (store a relative or {2}-anchored path)", label, value, WorkspaceAnchor)); }

        string rest = value;
        if (allowAnchor && IsWorkspaceAnchored(value)) { rest = value.Substring(WorkspaceAnchor.Length + 1); }
        else if (allowAnchor && value == WorkspaceAnchor) { errors.Add(string.Format("{0} '{1}' names no folder under the anchor", label, value)); return errors.ToArray(); }

        if (rest.Contains("{") || rest.Contains("}"))
        {
            errors.Add(allowAnchor
                ? string.Format("{0} '{1}' has an anchor other than a leading '{2}/'", label, value, WorkspaceAnchor)
                : string.Format("{0} '{1}' has an anchor (a path inside a root is relative to it)", label, value));
        }
        foreach (string segment in rest.Split('/'))
        {
            if (segment == "..") { errors.Add(string.Format("{0} '{1}' has a '..' segment", label, value)); break; }
            if (segment == ".") { errors.Add(string.Format("{0} '{1}' has a '.' segment", label, value)); break; }
            if (segment.Length == 0 && !value.StartsWith("/", StringComparison.Ordinal)) { errors.Add(string.Format("{0} '{1}' has an empty segment", label, value)); break; }
        }
        return errors.ToArray();
    }

    // Maps a path in either shell's view to the platform's own form, '/'-separated: backslashes become '/', and on
    // Windows a Git Bash drive path ('/c/projects') becomes a drive path ('C:/projects'). Elsewhere a '/c/...'
    // path is a real path and is left as it is.
    public static string ToNative(string path, bool windows)
    {
        if (path == null) { throw new ArgumentNullException(nameof(path)); }
        string forward = path.Replace('\\', '/');
        if (!windows) { return forward; }
        Match drive = MsysDrive.Match(forward);
        if (!drive.Success) { return forward; }
        return drive.Groups[1].Value.ToUpperInvariant() + ":/" + forward.Substring(drive.Length);
    }

    // The workspace folder of a repository root (in either shell's view): its parent, '/'-separated.
    public static string Workspace(string repositoryRoot, bool windows)
    {
        if (string.IsNullOrWhiteSpace(repositoryRoot)) { throw new ArgumentException("The repository root is not set, so the workspace anchor cannot resolve."); }
        string root = ToNative(repositoryRoot, windows).TrimEnd('/');
        int cut = root.LastIndexOf('/');
        if (cut < 0)
        {
            throw new ArgumentException(string.Format("The repository root '{0}' has no parent folder, so the workspace anchor cannot resolve.", repositoryRoot));
        }
        string parent = root.Substring(0, cut);
        if (parent.Length == 0) { return "/"; }
        if (windows && parent.Length == 2 && DriveLetter.IsMatch(parent)) { return parent + "/"; }
        return parent;
    }

    // A {workspace}-anchored root resolved against the repository root's workspace, '/'-separated and absolute.
    public static string ResolveWorkspace(string root, string repositoryRoot, bool windows)
    {
        if (!IsWorkspaceAnchored(root)) { throw new ArgumentException(string.Format("'{0}' is not anchored on {1}/", root, WorkspaceAnchor)); }
        string workspace = Workspace(repositoryRoot, windows);
        string rest = root.Substring(WorkspaceAnchor.Length + 1);
        return workspace.EndsWith("/", StringComparison.Ordinal) ? workspace + rest : workspace + "/" + rest;
    }
}
