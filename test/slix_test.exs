defmodule SlixTest do
  use ExUnit.Case

  test "html tags" do
    assert Slix.html("br") == "<br>"
  end

  test "html tags with content" do
    assert Slix.html("p", "content") == "<p>content</p>"
  end

  test "html tags with content fn" do
    f = fn -> "some whatever content" end;
    assert Slix.html("p", f) == "<p>some whatever content</p>"
  end

  test "detects indentation" do
    source = "    p"

    assert Slix.detect_indent(source) ==  %{ indent: 4, line: "p", nesting: []}
  end

  test "indentation for multiple lines" do
    source_lines = """
    div
      p Hello
        a href="#"
    h3 slim
    """

    assert Slix.render(source_lines) == [
      %{ indent: 0, line: "div"},
      %{ indent: 2, line: "p Hello"},
      %{ indent: 4, line: ~S{a href="#"}},
      %{ indent: 0, line: "h3 slim"},
      %{ indent: 0, line: ""},
    ]
  end


  test "render nested" do
    source_lines = """
    div
      p Hello
        a href="#"
    h3 slim
    """




    assert Slix.render_nested(source_lines) == [
      %{ indent: 0, line: "div"},
      %{ indent: 2, line: "p Hello"},
      %{ indent: 4, line: ~S{a href="#"}},
      #%{ indent: 0, line: "h3 slim"},
      #%{ indent: 0, line: ""},
    ]
  end



  test "grouping lines with simple indentation" do
    lines = [
      %{ indent: 0, line: "div"},
      %{ indent: 2, line: "p Hello"},
      %{ indent: 4, line: ~S{a href="#"}},
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

    [ h | tail ] = lines

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



  @tag :pending
  test "grouping lines with reducing indentation" do
    lines = [
      [ indent: 0, line: "div"],
      [ indent: 2, line: "p Hello"],
      [ indent: 4, line: ~S{a href="#"}],
      [ indent: 0, line: "h3 slim"],
      [ indent: 0, line: ""],
    ]

    output = [
      %{ indent: 0, line: "div", nesting: [
        %{ indent: 2, line: "p Hello", nesting: [
            %{ indent: 4, line: ~S{a href="#"}, nesting: [] }
          ]
       }
    ]
  },
      [ indent: 0, line: "h3 slim", nesting: []],
      [ indent: 0, line: "", nesting: []],
    ]

    assert Slix.group_lines(lines) == output

  end


end
