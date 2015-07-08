defmodule Slix do
  def render(template_string) do
    String.split(template_string, "\n")
    |> Enum.map fn(x) -> detect_indent x end
  end

  def render_nested(template_string) do
    render(template_string) |> group_lines |> render_eex
  end


  def reindent(content, 0), do: content
  def reindent(content, i) do
     reindent(" #{content}", i-1)
  end


  def render_eex([]), do: ""
  def render_eex([h | []]), do: render_eex(h)
  def render_eex([h | t]) do
    "#{render_eex(h)}#{render_eex(t)}"
    #render_eex(h)
  end

  def render_eex(%{ indent: indent, line: line, nesting: nesting }) do


    cond do
      line  =~ ~r{^$} -> ""
      match = Regex.run(~r{^('\s?)(.+)$}, line) ->
        [_, _prefix, text_content] = match
        r = text_content


      true ->
        r = html(line, render_eex(nesting))
    end

    reindent(r, indent)
    #render_slim(line, render_eex(nesting))#, Enum.map(item[:nesting], &render_eex/1 ))
    #html(item[:line], Enum.map(item[:nesting], &render_eex/1 ))
  end



  def detect_indent(str) do
    stripped = String.lstrip(str)
    %{ indent: String.length(str) - String.length(stripped), line: stripped, nesting: [] }
  end

  def group_lines([]), do: []
  def group_lines([ h | t ]) do

    {nesting, rest} = children_of(h[:indent], t)

    [ %{ h | nesting: group_lines(nesting) } | group_lines(rest)]
      #cond do
    #h[:indent] == depth ->
    # h[:indent] > depth ->
        #[ h ++ [nesting: group_lines(h[:indent], t)] ]
      #h[:indent] < depth ->
        #[ ] # shit, this approach is broken
        #end

#    cond do
#      h[:indent] == depth ->
#        [h | group_lines(h[:indent], t)]
#      h[:indent] > depth ->
#        [ h ++ [nesting: group_lines(h[:indent], t)] ]
#      h[:indent] < depth ->
#        [ ] # shit, this approach is broken
#    end
  end


  def children_of(depth, list) do
    Enum.split_while(list, fn(x) -> x[:indent] > depth end)
  end

  def children_of(_, []) do
    [[],[]]
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
