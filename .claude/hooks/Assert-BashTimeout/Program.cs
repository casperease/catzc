/*
---
catzc:
  docs: "../../../docs/references/pwsh/claude-hooks/Assert-BashTimeout/Program.cs.md"
  header: "generated"
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Text.Json;
using System.Text.RegularExpressions;
using Catzc.Base.Git;
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
            string payload = Console.In.ReadToEnd();

            string userCommand = UserCommandIn(payload, repositoryRoot);
            if (userCommand != null)
            {
                Console.Out.Write(BashSafeguard.DenyOutput(
                    userCommand + " changes the repository and runs only at the user's hand (FDR-GIT-USERRUNSGIT): name it to the user to run, and run only its tests."));
                return 0;
            }

            TimeoutsConfig config = new TimeoutsConfig(LoadYaml(BashSafeguard.FindConfig(repositoryRoot)));
            string environment = BashSafeguard.EnvironmentOf(
                Environment.GetEnvironmentVariable("TF_BUILD"), Environment.GetEnvironmentVariable("GITHUB_ACTIONS"));

            string logLine;
            string reason = BashSafeguard.Decide(payload, config, environment, out logLine);
            if (reason != null)
            {
                Console.Out.Write(BashSafeguard.DenyOutput(reason));
                AppendLog(Path.Combine(repositoryRoot, "out", "time-safeguard.log"), logLine);
            }
            return 0;
        }
        catch (Exception e)
        {
            Console.Out.Write(BashSafeguard.DenyOutput("Bash time safeguard hook failed, so the call is denied: " + e.Message));
            return 0;
        }
    }

    // The git topic command the call invokes, or null. A broken git.yml falls back to the type's defaults, never to denying every call.
    private static string UserCommandIn(string payload, string repositoryRoot)
    {
        GitFlowConfig gitFlow;
        try
        {
            string path = GitFlowConfig.FindConfig(repositoryRoot);
            gitFlow = new GitFlowConfig(path == null ? null : LoadYaml(path));
        }
        catch (Exception)
        {
            gitFlow = new GitFlowConfig(null);
        }
        return gitFlow.UserCommandIn(CommandOf(payload));
    }

    // The Bash command line of a hook payload, or null when it carries none.
    private static string CommandOf(string payload)
    {
        using (JsonDocument document = JsonDocument.Parse(payload))
        {
            JsonElement input;
            JsonElement command;
            return document.RootElement.ValueKind == JsonValueKind.Object && document.RootElement.TryGetProperty("tool_input", out input) &&
                input.ValueKind == JsonValueKind.Object && input.TryGetProperty("command", out command) && command.ValueKind == JsonValueKind.String
                ? command.GetString()
                : null;
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
