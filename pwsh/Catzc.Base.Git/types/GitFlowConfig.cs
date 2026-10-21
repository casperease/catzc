/*
---
catzc:
  immutable:
    with_body_sha: "88a709629058"
  edges:
    test: pwsh/Catzc.Base.Git/tests/types/GitFlowConfig.Tests.ps1
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Text.RegularExpressions;

namespace Catzc.Base.Git;

public sealed class GitFlowConfig
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    private const string Failed = "git configuration validation failed:\n";
    private static readonly string[] AllowedKeys = { "remote", "main_branches", "bvt_mark", "user_commands" };
    private static readonly string[] MarkKeys = { "ref" };

    // The mark kind when the server records no BVT-verified head: every sync falls back to the current server HEAD and says so.
    public const string NoMark = "none";
    // The mark kind when the server keeps the BVT-verified head as a ref.
    public const string RefMark = "ref";

    public const string DefaultRemote = "origin";
    public static readonly IReadOnlyList<string> DefaultMainBranches = new[] { "main", "master" };
    public static readonly IReadOnlyList<string> DefaultUserCommands = new[] { "Sync-Topic", "Save-Topic", "Push-Topic" };

    // The server remote the flow reads and pushes.
    public string remote { get; } = DefaultRemote;

    // The branch names that are the server's main, first match wins; a topic is never one of them in main-via-pr.
    public IReadOnlyList<string> main_branches { get; } = DefaultMainBranches;

    // How the server marks its BVT-verified head: `none`, or the ref that points at it.
    public string bvt_mark_kind { get; } = NoMark;
    public string bvt_mark_ref { get; }

    // The commands that change a repository and so run only at the user's hand; the Bash hook denies them to an agent.
    public IReadOnlyList<string> user_commands { get; } = DefaultUserCommands;

    public GitFlowConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        if (raw == null) { raw = new Hashtable(); }
        foreach (object k in raw.Keys)
        {
            string key = k == null ? null : k.ToString();
            if (Array.IndexOf(AllowedKeys, key) < 0)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "unknown top-level key '{0}' (allowed: {1})", key, string.Join(", ", AllowedKeys)));
            }
        }
        if (raw.Contains("remote") && raw["remote"] != null)
        {
            string value = raw["remote"].ToString().Trim();
            if (value.Length == 0 || value.IndexOf(' ') >= 0) { errors.Add("remote must be a remote name"); }
            else { remote = value; }
        }
        if (raw.Contains("main_branches") && raw["main_branches"] != null)
        {
            main_branches = Names("main_branches", raw["main_branches"], errors) ?? main_branches;
        }
        if (raw.Contains("user_commands") && raw["user_commands"] != null)
        {
            user_commands = Names("user_commands", raw["user_commands"], errors) ?? user_commands;
        }
        if (raw.Contains("bvt_mark") && raw["bvt_mark"] != null)
        {
            object mark = raw["bvt_mark"];
            if (mark is IDictionary map)
            {
                foreach (object k in map.Keys)
                {
                    if (Array.IndexOf(MarkKeys, k == null ? null : k.ToString()) < 0)
                    {
                        errors.Add(string.Format(CultureInfo.InvariantCulture, "bvt_mark: unknown mark kind '{0}' (allowed: {1}, {2})", k, NoMark, RefMark));
                    }
                }
                string reference = map.Contains("ref") && map["ref"] != null ? map["ref"].ToString().Trim() : string.Empty;
                if (reference.Length == 0 || reference.IndexOf(' ') >= 0) { errors.Add("bvt_mark: ref must name the ref that points at the BVT-verified head"); }
                else
                {
                    bvt_mark_kind = RefMark;
                    bvt_mark_ref = reference;
                }
            }
            else if (!string.Equals(mark.ToString(), NoMark, StringComparison.Ordinal))
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "bvt_mark: unknown mark kind '{0}' (allowed: {1}, or a map with {2})", mark, NoMark, RefMark));
            }
        }
        if (errors.Count > 0) { throw new ArgumentException(Failed + string.Join("\n", errors)); }
    }

    // Where the config sits under the modules folder, so the Bash hook finds it without a PowerShell session.
    public const string ConfigModulePath = "Catzc.Base.Git/configs/git.yml";

    // The config file under the one top-level folder of the repository that holds it, or null when none does.
    public static string FindConfig(string repositoryRoot)
    {
        if (string.IsNullOrEmpty(repositoryRoot)) { throw new ArgumentNullException("repositoryRoot"); }
        foreach (string folder in Directory.GetDirectories(repositoryRoot))
        {
            string candidate = Path.Combine(folder, ConfigModulePath);
            if (File.Exists(candidate)) { return candidate; }
        }
        return null;
    }

    // The first user command a shell command line invokes, or null: a name counts only as a word of its own, so a path or file name
    // that holds it (tests/Sync-Topic.Tests.ps1) is no invocation.
    public string UserCommandIn(string commandLine)
    {
        if (string.IsNullOrEmpty(commandLine)) { return null; }
        foreach (string name in user_commands)
        {
            if (Regex.IsMatch(commandLine, @"(?<![\w./\\-])" + Regex.Escape(name) + @"(?![\w.\\/-])", RegexOptions.IgnoreCase | RegexOptions.CultureInvariant))
            {
                return name;
            }
        }
        return null;
    }

    // True when the branch is one of the server's main branches.
    public bool IsMain(string branch)
    {
        foreach (string main in main_branches)
        {
            if (string.Equals(main, branch, StringComparison.Ordinal)) { return true; }
        }
        return false;
    }

    static IReadOnlyList<string> Names(string name, object value, List<string> errors)
    {
        List<string> items = new List<string>();
        if (value is string || !(value is IEnumerable list))
        {
            errors.Add(name + " must be a non-empty list of names");
            return null;
        }
        foreach (object item in list)
        {
            string text = item == null ? string.Empty : item.ToString().Trim();
            if (text.Length == 0 || text.IndexOf(' ') >= 0)
            {
                errors.Add(name + " must be a non-empty list of names");
                return null;
            }
            items.Add(text);
        }
        if (items.Count == 0)
        {
            errors.Add(name + " must be a non-empty list of names");
            return null;
        }
        return items.ToArray();
    }
}
