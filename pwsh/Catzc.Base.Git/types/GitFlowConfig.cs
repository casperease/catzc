/*
---
catzc:
  immutable:
    with_body_sha: "72f978c62e2c"
  edges:
    test: pwsh/Catzc.Base.Git/tests/types/GitFlowConfig.Tests.ps1
    docs: "[GitFlowConfig.cs.md](docs/references/pwsh/catzc-base-git/types/GitFlowConfig.cs.md)"
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

    public string UserCommandIn(string commandLine)
    {
        if (string.IsNullOrEmpty(commandLine)) { return null; }
        return InvokedIn(WithoutHeredocBodies(commandLine), 0);
    }

    private static readonly Regex HeredocStart = new Regex(@"<<-?\s*['""]?(\w+)['""]?", RegexOptions.CultureInvariant);
    private static readonly Regex Assignment = new Regex(@"^[A-Za-z_]\w*=", RegexOptions.CultureInvariant);
    private static readonly Regex CommandSwitch = new Regex(@"^-(c|com|comm|comma|comman|command)$", RegexOptions.IgnoreCase | RegexOptions.CultureInvariant);

    private string InvokedIn(string script, int depth)
    {
        if (depth > 3) { return null; }
        foreach (string segment in Segments(script))
        {
            List<string> words = Words(segment);
            int first = 0;
            // A wrapper runs the command that follows it: timeout and its duration, env, a variable assignment, cats.
            while (first < words.Count)
            {
                string word = words[first];
                if (string.Equals(word, "timeout", StringComparison.Ordinal)) { first += 2; continue; }
                if (string.Equals(word, "env", StringComparison.Ordinal) || string.Equals(word, "cats", StringComparison.Ordinal) || Assignment.IsMatch(word)) { first++; continue; }
                break;
            }
            if (first >= words.Count) { continue; }
            string command = words[first];
            foreach (string name in user_commands)
            {
                if (string.Equals(Plain(command), Plain(name), StringComparison.OrdinalIgnoreCase)) { return name; }
            }
            if (Regex.IsMatch(command, @"^(pwsh|powershell)(\.exe)?$", RegexOptions.IgnoreCase | RegexOptions.CultureInvariant))
            {
                for (int i = first + 1; i < words.Count; i++)
                {
                    if (CommandSwitch.IsMatch(words[i]))
                    {
                        string found = InvokedIn(string.Join(" ", words.GetRange(i + 1, words.Count - i - 1)), depth + 1);
                        if (found != null) { return found; }
                        break;
                    }
                }
            }
        }
        return null;
    }

    // A command name as cats takes it (push-topic) and as pwsh does (Push-Topic) compare alike.
    private static string Plain(string name) => name.Replace("-", "").Replace("_", "");

    private static string WithoutHeredocBodies(string text)
    {
        string[] lines = text.Replace("\r\n", "\n").Split('\n');
        var kept = new List<string>();
        string delimiter = null;
        foreach (string line in lines)
        {
            if (delimiter != null)
            {
                if (string.Equals(line.Trim(), delimiter, StringComparison.Ordinal)) { delimiter = null; }
                continue;
            }
            kept.Add(line);
            Match start = HeredocStart.Match(line);
            if (start.Success) { delimiter = start.Groups[1].Value; }
        }
        return string.Join("\n", kept);
    }

    // The script cut at every separator outside quotes: ; & | ( ) { } and a line end.
    private static List<string> Segments(string script)
    {
        var segments = new List<string>();
        var current = new System.Text.StringBuilder();
        char quote = '\0';
        foreach (char c in script)
        {
            if (quote != '\0')
            {
                if (c == quote) { quote = '\0'; }
                current.Append(c);
                continue;
            }
            if (c == '\'' || c == '"') { quote = c; current.Append(c); continue; }
            if (";&|(){}\n".IndexOf(c) >= 0)
            {
                segments.Add(current.ToString());
                current.Clear();
                continue;
            }
            current.Append(c);
        }
        segments.Add(current.ToString());
        return segments;
    }

    // A segment's words, split at white space outside quotes, each without its quotes.
    private static List<string> Words(string segment)
    {
        var words = new List<string>();
        var current = new System.Text.StringBuilder();
        char quote = '\0';
        bool started = false;
        foreach (char c in segment)
        {
            if (quote != '\0')
            {
                if (c == quote) { quote = '\0'; } else { current.Append(c); }
                continue;
            }
            if (c == '\'' || c == '"') { quote = c; started = true; continue; }
            if (char.IsWhiteSpace(c))
            {
                if (started) { words.Add(current.ToString()); current.Clear(); started = false; }
                continue;
            }
            current.Append(c);
            started = true;
        }
        if (started) { words.Add(current.ToString()); }
        return words;
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
