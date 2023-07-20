Checkers do
  checklist "#==" do
    check(1) == 1.0
    check(1) == 1
  end

  checklist "#same_as" do
    check(1).is.same_as 1
    check(1).is.not.same_as 1.0
    check(Object.new).is.not.same_as(Object.new)
  end

  checklist "#same_value_and_type" do
    check(1).is.same_value_and_type_than 1
    check(1).not.same_value_and_type_than 2.0
    check(1).not.same_value_and_type_than 1.0
  end
end
