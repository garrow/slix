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

    assert Slix.detect_indent(source) == [ indent: 4, line: "p"]
  end

  test "indentation for multiple lines" do
    source_lines = """
    div
      p Hello
        a href="#"
    h3 slim
    """

    assert Slix.render(source_lines) == [
      [ indent: 0, line: "div"],
      [ indent: 2, line: "p Hello"],
      [ indent: 4, line: ~S{a href="#"}],
      [ indent: 0, line: "h3 slim"],
      [ indent: 0, line: ""],
    ]
  end
end
