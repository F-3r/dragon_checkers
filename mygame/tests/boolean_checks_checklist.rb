Preflight.checklist "Boolean Preflight: #true" do
  check(true).is.true
  check(false).is.not.true
end

Preflight.checklist "Boolean Preflight: #false" do
  check(false).is.false
  check(true).is.not.false
end

Preflight.checklist "Boolean Preflight: #truthy" do
  check(true).is.truthy
  check(Object.new).is.truthy
  check(false).is.not.truthy
  check(nil).is.not.truthy
end

Preflight.checklist "Boolean Preflight: #falsey" do
  check(false).is.falsey
  check(nil).is.falsey
  check(true).is.not.falsey
  check(Object.new).is.not.falsey
end

Preflight.checklist "Boolean Preflight: #nil" do
  check(nil).is.nil
  check(false).is.not.nil
  check(Object.new).is.not.nil
end
