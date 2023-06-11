Checkers.checklist "#includes" do
  check([1, 2, 3, 4, 5, 6]).includes 3
  check([1, 2, 3, 4, 5, 6]).not.includes 10
end
