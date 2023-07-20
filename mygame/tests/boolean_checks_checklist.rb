Checkers.checklist "Boolean Checkers: #true" do
  check(true).is.true
  check(false).is.not.true
end

Checkers.checklist "Boolean Checkers: #false" do
  check(false).is.false
  check(true).is.not.false
end

Checkers.checklist "Boolean Checkers: #truthy" do
  check(true).is.truthy
  check(Object.new).is.truthy
  check(false).is.not.truthy
  check(nil).is.not.truthy
end

Checkers.checklist "Boolean Checkers: #falsey" do
  check(false).is.falsey
  check(nil).is.falsey
  check(true).is.not.falsey
  check(Object.new).is.not.falsey
end

Checkers.checklist "Boolean Checkers: #nil" do
  check(nil).is.nil
  check(false).is.not.nil
  check(Object.new).is.not.nil
end
