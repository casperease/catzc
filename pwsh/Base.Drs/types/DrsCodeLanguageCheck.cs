/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-drs/types/DrsCodeLanguageCheck.cs.md"
  header: "generated"
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;

using Catzc.Base.Reports;

namespace Catzc.Base.Drs;

public sealed class DrsCodeLanguageCheck
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public const DrsCapitalization DefaultCapitalization = DrsCapitalization.On;
    public const int DefaultMaxRuleChars = 24;

    private static readonly string[] AllowedKeys = { "mode", "capitalization", "max_rule_chars" };
    private static readonly Regex Capitalized = new Regex("^" + DrsCodeForm.AnyKindShape + "(?:-[A-Z][A-Z0-9]*)*\\z", RegexOptions.CultureInvariant);

    public CheckMode mode { get; }
    public DrsCapitalization capitalization { get; }
    public int max_rule_chars { get; }

    public DrsCodeLanguageCheck(DrsCapitalization capitalization, int maxRuleChars)
    {
        if (maxRuleChars < 1) { throw new ArgumentOutOfRangeException(nameof(maxRuleChars), "max_rule_chars must be 1 or more"); }
        this.capitalization = capitalization;
        max_rule_chars = maxRuleChars;
    }

    internal DrsCodeLanguageCheck(IDictionary raw, string where, List<string> errors)
    {
        mode = default(CheckMode);
        capitalization = DefaultCapitalization;
        max_rule_chars = DefaultMaxRuleChars;
        if (raw == null) { return; }
        DrsChecksConfig.CheckKeys(raw, AllowedKeys, where, errors);
        mode = DrsChecksConfig.ParseMode(raw, where, errors);

        if (raw.Contains("capitalization") && raw["capitalization"] != null)
        {
            string value = raw["capitalization"].ToString();
            if (!Enum.TryParse(value, true, out DrsCapitalization parsed) || !Enum.IsDefined(typeof(DrsCapitalization), parsed))
            {
                errors.Add(string.Format("{0}: capitalization '{1}' is not a mode (allowed: {2})", where, value,
                    string.Join(", ", Enum.GetNames(typeof(DrsCapitalization))).ToLowerInvariant()));
            }
            else
            {
                capitalization = parsed;
            }
        }

        if (raw.Contains("max_rule_chars") && raw["max_rule_chars"] != null)
        {
            if (!int.TryParse(raw["max_rule_chars"].ToString(), System.Globalization.NumberStyles.None,
                    System.Globalization.CultureInfo.InvariantCulture, out int chars) || chars < 1)
            {
                errors.Add(string.Format("{0}: max_rule_chars '{1}' must be a whole number of 1 or more", where, raw["max_rule_chars"]));
            }
            else
            {
                max_rule_chars = chars;
            }
        }
    }

    // Why the text is not a code in this casing, or not a rule's code within the budget; null when it is.
    public string Violation(string code, bool isRule)
    {
        if (string.IsNullOrEmpty(code)) { return "the code is empty"; }
        if (capitalization == DrsCapitalization.On && !Capitalized.IsMatch(code))
        {
            return "'" + code + "' is not a kind of 2-4 upper-case letters followed by upper-case segments (capitalization on)";
        }
        if (!isRule) { return null; }

        string[] segments = code.Split('-');
        if (segments.Length < 3) { return "'" + code + "' is no rule's code: a rule has a record and a rule segment after its kind"; }
        string rule = segments[segments.Length - 1];
        if (rule.Length > max_rule_chars)
        {
            return "'" + code + "': the rule segment " + rule + " has " + rule.Length + " characters, over the budget of " + max_rule_chars;
        }
        return null;
    }
}
