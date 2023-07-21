Checkers.checklist "Strings Checkers: #includes" do
  check("Hello Dragon Ruby").includes "Dragon"
  check("Hello Dragon Ruby").not.includes "slow"
end

Checkers.checklist "Strings Checkers: #starts_with" do
  check("Hello Dragon Ruby").starts_with "Hell"
  check("Hello Dragon Ruby").not.starts_with "Dragon"
end

Checkers.checklist "Strings Checkers: #starts_with" do
  check("Hello Dragon Ruby").ends_with "uby"
  check("Hello Dragon Ruby").not.ends_with "Dragon"
end
