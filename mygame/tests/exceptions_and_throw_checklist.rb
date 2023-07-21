checklist "#raises" do
  check(-> { raise "error" }).raises StandardError
end

checklist "#throws" do
  check(-> { throw :result }).throws :result
end
