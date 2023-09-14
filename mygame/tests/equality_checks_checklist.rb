Preflight do
  checklist "Equality Preflight: #==" do
    check(1) == 1.0
    check(1) == 1
  end

  checklist "Equality Preflight: #same_as" do
    check(1).is.same_as 1
    check(1).is.not.same_as 1.0
    check(Object.new).is.not.same_as(Object.new)
  end

  checklist "Equality Preflight: #same_value_and_type" do
    check(1).is.same_value_and_type_than 1
    check(1).not.same_value_and_type_than 2.0
    check(1).not.same_value_and_type_than 1.0
  end

  checklist "Equality Preflight: #not" do
    check(1).not == 2
    check(1).not == 2
  end
end
