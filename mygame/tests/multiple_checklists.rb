Checkers do
  checklist "An exception in checklist counts as failure but must continue with the other checklists" do
    raise "This is an Expected Exception. If you don't see it, you broke something :P"
  end

  checklist "#==" do
    check(1) == 1.0
    check(1) == 1
  end

  checklist "#not" do
    check(1).not == 2
    check(1).not == 2
  end

  checklist "#raises" do
    code = -> { raise "A" }

    check(code).raises StandardError
  end
end
