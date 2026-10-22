using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text.RegularExpressions;

namespace Catzc.Tooling.Claude;

public sealed class ClaudeWorkerConfig
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public const string DefaultAgent = "catzc-drone";
    public const string DefaultLauncher = "windows-terminal";

    public static IReadOnlyList<string> Launchers { get; } = Array.AsReadOnly(new[] { "windows-terminal", "pwsh" });

    private static readonly string[] AllowedKeys = { "agent", "launcher" };
    private static readonly Regex AgentName = new Regex("^[a-z0-9][a-z0-9-]*$", RegexOptions.Compiled | RegexOptions.CultureInvariant);

    // The agent a worker session starts as, the name of a file in .claude/agents.
    public string agent { get; }

    // The terminal a worker session opens in: windows-terminal (wt.exe new-tab) or pwsh (a pwsh -NoExit window).
    public string launcher { get; }

    public ClaudeWorkerConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        string agentValue = DefaultAgent;
        string launcherValue = DefaultLauncher;

        if (raw != null)
        {
            foreach (object key in raw.Keys)
            {
                string name = Convert.ToString(key, CultureInfo.InvariantCulture);
                if (Array.IndexOf(AllowedKeys, name) < 0)
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "unknown key '{0}' (allowed: {1})", name, string.Join(", ", AllowedKeys)));
                }
            }

            if (raw.Contains("agent") && raw["agent"] != null)
            {
                string candidate = raw["agent"] as string;
                if (candidate == null || !AgentName.IsMatch(candidate))
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "agent '{0}' must be a kebab-case agent name", raw["agent"]));
                }
                else
                {
                    agentValue = candidate;
                }
            }

            if (raw.Contains("launcher") && raw["launcher"] != null)
            {
                string candidate = raw["launcher"] as string;
                if (candidate == null || !Launchers.Contains(candidate))
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "launcher '{0}' must be one of: {1}", raw["launcher"], string.Join(", ", Launchers)));
                }
                else
                {
                    launcherValue = candidate;
                }
            }
        }

        if (errors.Count > 0)
        {
            throw new ArgumentException("claude-worker configuration validation failed:\n" + string.Join("\n", errors));
        }

        agent = agentValue;
        launcher = launcherValue;
    }
}
