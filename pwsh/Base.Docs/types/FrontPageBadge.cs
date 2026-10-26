using System;
using System.Collections;

namespace Catzc.Base.Docs;

// One badge under the front page's title: a shields.io label/message/color, or an explicit image such as a CI status.
public sealed class FrontPageBadge : Catzc.Base.Objects.DictionaryRecord
{
    public string label { get; }

    public string message { get; }

    public string color { get; }

    // An explicit image URL in place of the shields.io triple.
    public string image { get; }

    // Where the badge leads: a section id of the page, or a URL.
    public string to { get; }

    public FrontPageBadge(IDictionary d)
    {
        if (d == null) { throw new ArgumentException("FrontPageBadge requires a dictionary"); }
        label = Req(d, "label");
        to = Req(d, "to");
        image = OptStr(d, "image");
        message = OptStr(d, "message");
        color = OptStr(d, "color");
        if (image == null && (message == null || color == null))
        {
            throw new ArgumentException(string.Format("badge '{0}' needs either 'image' or both 'message' and 'color'", label));
        }
        if (image != null && (message != null || color != null))
        {
            throw new ArgumentException(string.Format("badge '{0}' takes 'image' or 'message' and 'color', never both", label));
        }
    }

    // The image a renderer shows: the explicit one, or the shields.io static badge.
    public string ImageUrl()
    {
        if (image != null) { return image; }
        return "https://img.shields.io/badge/" + Escape(label) + "-" + Escape(message) + "-" + color + "?style=flat-square";
    }

    // shields.io reads '-' as a separator and '_' as a space, so both are doubled, and a space becomes '_'.
    private static string Escape(string text) => Uri.EscapeDataString(text.Replace("-", "--").Replace("_", "__").Replace(" ", "_"));
}
