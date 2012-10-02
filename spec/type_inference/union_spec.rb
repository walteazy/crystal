require 'spec_helper'

describe "Type inference: union" do
  it "types union when obj is union" do
    assert_type("a = 1; a = 2.3; a + 1") { UnionType.new(int, float) }
  end

  it "types union when arg is union" do
    assert_type("a = 1; a = 2.3; 1 + a") { UnionType.new(int, float) }
  end

  it "types union when both obj and arg are union" do
    assert_type("a = 1; a = 2.3; a + a") { UnionType.new(int, float) }
  end

  it "unifies unions when instance var changes" do
    assert_type(%Q(
      class A
        def next=(n)
          @next = n
        end
        def next
          @next
        end
      end

      a = A.new
      a.next = 1

      a = A.new
      a.next = 2.3
      a
    )) { ObjectType.new("A").with_var("@next", UnionType.new(int, float)) }
  end
end