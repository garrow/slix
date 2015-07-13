defmodule SlixTest do
  use ExUnit.Case

  test "detects indentation" do
    source = "    p"

    assert Slix.detect_indent(source)[:indent] == 4
  end

  test "indentation for multiple lines" do
    source_lines = """
    div
      p Hello
        a href="#"
    h3 slim
    """

    assert Slix.render(source_lines) == [
      %{ indent: 0, line: "div", nesting: []},
      %{ indent: 2, line: "p Hello", nesting: []},
      %{ indent: 4, line: ~S{a href="#"}, nesting: []},
      %{ indent: 0, line: "h3 slim", nesting: []},
      %{ indent: 0, line: "", nesting: []},
    ]
  end

 test "grouping lines with simple indentation" do
   lines = [
     %{ indent: 0, line: "div", nesting: []},
     %{ indent: 2, line: "p Hello", nesting: []},
     %{ indent: 4, line: ~S{a href="#"}, nesting: []},
   ]

   output = [
     %{ indent: 0, line: "div", nesting: [
       %{ indent: 2, line: "p Hello", nesting: [
         %{ indent: 4, line: ~S{a href="#"}, nesting: [ ]} ]} ]},
   ]

   assert Slix.group_lines(lines) == output
 end

  test "children of" do

    lines = [
      [ indent: 0, line: "div"],
      [ indent: 2, line: "p Hello"],
      [ indent: 4, line: ~S{a href="#"}],
      [ indent: 0, line: "h3 slim"],
      [ indent: 0, line: ""],
    ]

    [ _h | tail ] = lines

    assert Slix.children_of(0, tail) == {
      [
        #[ indent: 0, line: "div"],
        [ indent: 2, line: "p Hello"],
        [ indent: 4, line: ~S{a href="#"}],
      ],
      [
        [ indent: 0, line: "h3 slim"],
        [ indent: 0, line: ""],
      ]
    }

  end
end
