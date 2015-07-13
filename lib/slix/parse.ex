defmodule Slix.Parse do

  defmodule Html,     do: defstruct tag: "div", attrs: [], children: []
  defmodule HtmlAttr, do: defstruct attr: "", value: ""

  def parse(line) do
    html_tag2 = ~r/
    \A
    (?<tag>\w+)?               # Tag
    ((?:\#)(?<id>\w+))?        # ID
    (?<classes>((?:\.)(\w+))*) # CSS Class
    /x

    cond do
      match = Regex.named_captures(html_tag2, line) ->
        handle_html_tag(match)

      true ->
        :unknown
    end
  end

  def handle_html_tag(%{ "classes" => classes, "id" => id, "tag" => tag}) do
    class_terms = String.replace(classes, ".", " ") |> String.lstrip

    %Html{
      tag: tag,
      attrs: html_attr("id", id) ++ html_attr("class", class_terms)
    }
  end

  def html_attr(_attr, ""), do: []
  def html_attr(attr, value) do
    [%HtmlAttr{attr: attr, value: value}]
  end
end
