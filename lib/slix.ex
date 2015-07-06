defmodule Slix do
  def render(template_string) do
    String.split(template_string, "\n")
    |> Enum.map fn(x) -> detect_indent x end
  end


  def render_nested(template_string) do
    render(template_string) |> group_lines |> render_eex
  end



  def render_eex(nil), do: ""
  def render_eex([]), do: ""
  def render_eex(item) do



    html(item[:line], Enum.map(item[:nesting], &render_eex/1 ))

  end



  def detect_indent(str) do
    stripped = String.lstrip(str)
    %{ indent: String.length(str) - String.length(stripped), line: stripped, nesting: [] }
  end


  def group_lines(%{}) do

  end




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
