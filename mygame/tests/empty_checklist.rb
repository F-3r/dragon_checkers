Checkers.checklist "#empty" do
    check([]).empty
    check("").empty
    check({}).empty
    check({a: 2}).not.empty
    check("a").not.empty
    check([1]).not.empty
  end
