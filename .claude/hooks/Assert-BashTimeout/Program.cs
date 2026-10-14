// Claude Code PreToolUse hook: denies a Bash call that does not run inside the time safeguard
// ([ADR-AUTO-FAILFAST#7](/docs/adr/automation/fail-fast-with-asserts.md#rule-adr-auto-failfast7)).
//
// The decision is Catzc.Base.Timeouts.BashSafeguard and the limits are Catzc.Base.Timeouts.TimeoutsConfig — the
// module's own source files, compiled into this program (see the .csproj), so the hook, Get-TimeoutSeconds and the
// L0 tests share one parser, one set of defaults and one verdict. This file only does the I/O: read the payload
// from stdin, load timeouts.yml, detect the run environment, print a denial, and append each denial to
// out/time-safeguard.log — the list of blockers to tune.
//
// A compiled program because it runs before every Bash call: it starts in about a third of the time a pwsh script
// does. Build-BashTimeoutHook publishes it to .claude/hooks/bin/, from where the repository root is three folders up.

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Text.RegularExpressions;
using Catzc.Base.Timeouts;
using YamlDotNet.RepresentationModel;

namespace Catzc.Hooks;

public static class AssertBashTimeout
{
    private static readonly Regex PlainInteger = new Regex(@"^[-+]?\d+$", RegexOptions.CultureInvariant);
    private static readonly Regex PlainFloat = new Regex(@"^[-+]?(\d+\.\d*|\.\d+)([eE][-+]?\d+)?$", RegexOptions.CultureInvariant);

    public static int Main()
    {
        try
        {
            string repositoryRoot = Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, "..", "..", ".."));
            TimeoutsConfig config = new TimeoutsConfig(LoadYaml(Path.Combine(repositoryRoot, BashSafeguard.ConfigRelativePath)));
            string environment = BashSafeguard.EnvironmentOf(
                Environment.GetEnvironmentVariable("TF_BUILD"), Environment.GetEnvironmentVariable("GITHUB_ACTIONS"));

            string logLine;
            string reason = BashSafeguard.Decide(Console.In.ReadToEnd(), config, environment, out logLine);
            if (reason != null)
            {
                Console.Out.Write(BashSafeguard.DenyOutput(reason));
                AppendLog(Path.Combine(repositoryRoot, "out", "time-safeguard.log"), logLine);
            }
            return 0;
        }
        catch (Exception e)
        {
            // A non-blocking hook error: the call goes ahead and the person sees why the safeguard did not run.
            Console.Error.WriteLine("Bash time safeguard hook failed: " + e.Message);
            return 1;
        }
    }

    private static void AppendLog(string path, string line)
    {
        try
        {
            Directory.CreateDirectory(Path.GetDirectoryName(path));
            File.AppendAllText(path, line + Environment.NewLine);
        }
        catch (IOException)
        {
            // The log is a tuning aid; a locked or missing out/ never turns a denial into a hook error.
        }
    }

    // timeouts.yml as the nested IDictionary TimeoutsConfig takes, typed the way the module's YAML loader types it:
    // a plain integer is a number, a plain float a double, a quoted scalar stays a string.
    private static IDictionary LoadYaml(string path)
    {
        YamlStream stream = new YamlStream();
        using (StreamReader reader = new StreamReader(path))
        {
            stream.Load(reader);
        }
        if (stream.Documents.Count == 0)
        {
            return null;
        }
        object root = Convert(stream.Documents[0].RootNode);
        return root as IDictionary;
    }

    private static object Convert(YamlNode node)
    {
        YamlMappingNode mapping = node as YamlMappingNode;
        if (mapping != null)
        {
            Hashtable table = new Hashtable(StringComparer.Ordinal);
            foreach (KeyValuePair<YamlNode, YamlNode> entry in mapping.Children)
            {
                table[((YamlScalarNode)entry.Key).Value] = Convert(entry.Value);
            }
            return table;
        }
        YamlSequenceNode sequence = node as YamlSequenceNode;
        if (sequence != null)
        {
            ArrayList list = new ArrayList();
            foreach (YamlNode item in sequence.Children)
            {
                list.Add(Convert(item));
            }
            return list;
        }
        YamlScalarNode scalar = (YamlScalarNode)node;
        string value = scalar.Value;
        if (scalar.Style != YamlDotNet.Core.ScalarStyle.Plain || value == null)
        {
            return value;
        }
        if (value.Length == 0 || value == "~" || value == "null")
        {
            return null;
        }
        long integer;
        if (PlainInteger.IsMatch(value) && long.TryParse(value, NumberStyles.AllowLeadingSign, CultureInfo.InvariantCulture, out integer))
        {
            return integer;
        }
        if (PlainFloat.IsMatch(value))
        {
            return double.Parse(value, CultureInfo.InvariantCulture);
        }
        return value;
    }
}
