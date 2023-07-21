class Who
  attr_reader :name
  def initialize
    @name = "who?"
  end

  def reverse!
    @name = @name.reverse
  end
end

Checkers.checklist "Changes checkers: #changes" do
  a = Who.new
  check(-> { a.reverse! }).changes(-> { a.name })
end
