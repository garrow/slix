defmodule SlixTest.ParseTest do
  use ExUnit.Case

  test "detects tags" do
    source = "p"

    assert Slix.Parse.parse(source) == %Slix.Parse.Html{tag: "p"}
  end


  test "no tags classes" do
    source = ".cheese"

    assert Slix.Parse.parse(source) == %Slix.Parse.Html{
      tag: "div",
      attrs: [
        %Slix.Parse.HtmlAttr{ attr: "class", value: "cheese"}
        ]
      }
  end
  test "detects classes" do
    source = "p.cheese"

    assert Slix.Parse.parse(source) == %Slix.Parse.Html{
      tag: "p",
      attrs: [
        %Slix.Parse.HtmlAttr{ attr: "class", value: "cheese"}
        ]
      }
  end

  test "multiple classes" do
    source = "p.cheese.tasty"

    assert Slix.Parse.parse(source) == %Slix.Parse.Html{
      tag: "p",
      attrs: [
        %Slix.Parse.HtmlAttr{ attr: "class", value: "cheese tasty"}
        ]
      }
  end

  test "bootstrap typical amount of classes" do
    source = "p.cheese.tasty.is.a.good.type.of.cheese"

    assert Slix.Parse.parse(source) == %Slix.Parse.Html{
      tag: "p",
      attrs: [
        %Slix.Parse.HtmlAttr{ attr: "class", value: "cheese tasty is a good type of cheese"}
        ]
      }
  end

  test "detects tags with IDs" do
    source = "p#good"

    assert Slix.Parse.parse(source) == %Slix.Parse.Html{
      tag: "p",
      attrs: [
        %Slix.Parse.HtmlAttr{ attr: "id",    value: "good"},
        ]
      }
  end

  test "detects tags with ID and classes" do
    source = "p#good.cheese"

    assert Slix.Parse.parse(source) == %Slix.Parse.Html{
      tag: "p",
      attrs: [
        %Slix.Parse.HtmlAttr{ attr: "id",    value: "good"},
        %Slix.Parse.HtmlAttr{ attr: "class", value: "cheese"},
        ]
      }
  end
end
