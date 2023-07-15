Checkers do
  checklist "single check" do
    check(true).not == false
  end

  group "named group" do
    checklist do
      check(true).not == false
    end

    group "nested" do
      checklist "checklist inside nested group" do
        check(true).not == false
        check([]).empty
      end
    end
  end

  group do
    checklist do
      check(true).not == false
      check([]).empty
    end
  end
end
