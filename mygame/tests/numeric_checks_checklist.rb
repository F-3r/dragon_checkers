Checkers do
  checklist "Numeric Checkers: #>" do
    check(2).is > 1
    check(1).is.not > 2
  end

  checklist "Numeric Checkers: #>=" do
    check(1).is >= 1
    check(1).is.not >= 2
  end

  checklist "Numeric Checkers: #<" do
    check(1).is < 2
    check(1).is.not < 0
  end

  checklist "Numeric Checkers: #<=" do
    check(1).is <= 1
    check(1).is <= 2
    check(1).is.not <= 0
  end

  checklist "Numeric Checkers: #<=" do
    check(1).is.between 0, 2
    check(1).is.between 1, 2
    check(1).is.between 0, 2
    check(1).is.not.between 2, 3
  end

  checklist "Numeric Checkers: #within" do
    check(1.2).is.within 0.2, 1
    check(0.8).is.within 0.2, 1
    check(1).is.not.within 1, 5
  end
end
