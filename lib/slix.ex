defmodule Slix do
  def render(template_string) do
    String.split(template_string, "\n")
    |> Enum.map fn(x) -> detect_indent x end
  end

  def detect_indent(str) do
    stripped = String.lstrip(str)
    [ indent: String.length(str) - String.length(stripped) , line: stripped ]
  end

  def html(tag) do
    "<#{tag}>"
  end

  def closing_tag(tag) do
    html("/#{tag}")
  end

  def html(tag, content) when is_function(content) do
    html(tag, content.())
  end

  def html(tag, content) do
    "#{html(tag)}#{content}#{closing_tag(tag)}"
  end
end
