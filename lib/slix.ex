defmodule Slix do
  def render(template_string) do
    String.split(template_string, "\n")
    |> Enum.map fn(x) -> detect_indent x end
  end

  def render_nested(template_string) do
    render(template_string) |> group_lines |> render_eex
  end

  def detect_indent([]),  do: %{ indent: 0, line: "", nesting: [] }
  def detect_indent(str) do
    stripped = String.lstrip(str)
    %{ indent: String.length(str) - String.length(stripped), line: stripped, nesting: [] }
  end

  def group_lines([]), do: []
  def group_lines([ h = %{indent: _, line: _, nesting: _} | t ]) do
    { nesting, rest } = children_of(h[:indent], t)
    [ %{ h | nesting: group_lines(nesting) } | group_lines(rest) ]
  end

  def children_of(_, []), do: { [],[] }
  def children_of(depth, list) do
    Enum.split_while(list, fn(x) -> x[:indent] > depth end)
  end
end
