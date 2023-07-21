Checkers.checklist "Collection Checkers: #counts" do
  check([]).counts 0
  check(1..10).counts 10
end

Checkers.checklist "Collection Checkers: #includes" do
  check([1, 2, 3, 4, 5, 6]).includes 3
  check([1, 2, 3, 4, 5, 6]).not.includes 10
end

Checkers.checklist "Collection Checkers: #contains" do
  check([1, 2, 3]).contains [3, 1, 2]
  check([1, 2, 3]).not.contains [3, 1]
  check([1, 2, 3]).not.contains [0, 4]
end

Checkers.checklist "Collection Checkers: #covers" do
  check(1..10).covers 3
  check(1..10).not.covers 11
  check(1..10).not.covers 0
end

Checkers.checklist "Collection Checkers: #empty" do
  check([]).empty
  check("").empty
  check({}).empty
  check({a: 2}).not.empty
  check("a").not.empty
  check([1]).not.empty
end
