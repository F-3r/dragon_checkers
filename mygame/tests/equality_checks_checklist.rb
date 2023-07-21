Checkers do
  checklist "Equality Checkers: #==" do
    check(1) == 1.0
    check(1) == 1
  end

  checklist "Equality Checkers: #same_as" do
    check(1).is.same_as 1
    check(1).is.not.same_as 1.0
    check(Object.new).is.not.same_as(Object.new)
  end

  checklist "Equality Checkers: #same_value_and_type" do
    check(1).is.same_value_and_type_than 1
    check(1).not.same_value_and_type_than 2.0
    check(1).not.same_value_and_type_than 1.0
  end

  checklist "Equality Checkers: #not" do
    check(1).not == 2
    check(1).not == 2
  end
end
