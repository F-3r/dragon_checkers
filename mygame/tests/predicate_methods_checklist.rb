Checkers do
  checklist "Dynamic predicate methods checkers: Hash#has_value" do
    check({a: 1}).has_value 1
    check({a: nil}).has_value nil
  end

  checklist "Dynamic predicate methods checkers: Hash#has_key" do
    check({a: 1}).has_key :a
    check({a: 1, b: nil}).has_key :b
  end

  checklist "Dynamic predicate methods checkers: Object#instance_of" do
    check({a: 1}).instance_of Hash
    check({a: 1}).not.instance_of Array
  end

  checklist "Dynamic predicate methods checkers: Object#responds_to" do
    check([]).respond_to :size
    check([]).not.respond_to :asdf
  end
end
