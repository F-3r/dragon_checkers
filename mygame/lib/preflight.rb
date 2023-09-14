module Preflight
  module Sugar
    def not
      @inverted = !inverted
      self
    end

    def is
      self
    end

    def are
      self
    end
  end

  module Checks
    # Equality
    def ==(other)
      check subject == other, "#{subject.inspect} should have been equal to #{other.inspect}, but it wasn't"
    end

    def same_as(o)
      check subject.equal?(o), "#{subject.inspect} should have been the same object as #{o.inspect}, but it wasn't"
    end

    def same_value_and_type_than(o)
      check subject.eql?(o), "#{subject.inspect} should have had the same value and type than #{o.inspect}, but it hadn't"
    end

    # Collections
    def includes(o)
      check subject.include?(o), "#{subject.inspect} should have included #{o.inspect}, but didn't"
    end

    def contains(o)
      check (subject - o).empty?, "#{subject.inspect} should have contained #{o.inspect}, but didn't"
    end

    def covers(o)
      check (subject.respond_to?(:cover?) && subject.cover?(o)), "#{subject.inspect} should have contained #{o.inspect}, but didn't"
    end

    def empty
      check subject.empty?, "#{subject.inspect} should be empty, but wasn't"
    end

    def counts(n)
      check subject.count == n, "#{subject.inspect} count should equal  #{n.inspect}, but was #{subject.count}"
    end

    # Strings
    def starts_with(o)
      check subject.start_with?(o), "#{subject.inspect} should have started with #{o.inspect}, but didn't"
    end

    def ends_with(o)
      check subject.end_with?(o), "#{subject.inspect} should have ended with #{o.inspect}, but didn't"
    end

    # DR does not have regex (yet)
    # def matches(pattern)
    #   check subject.match(pattern), "#{subject.inspect} should match with #{pattern.inspect}, but didn't"
    # end

    # Booleans & nils
    def true
      check subject.equal?(true), "#{subject.inspect} should have been true, but wasn't"
    end

    def false
      check subject.equal?(false), "#{subject.inspect} should have been false, but wasn't"
    end

    def truthy
      check (!!subject).equal?(true), "#{subject.inspect} should have been truthy, but wasn't"
    end

    def falsey
      check (!!subject).equal?(false), "#{subject.inspect} should have been falsey, but wasn't"
    end

    def nil
      check subject.nil?, "#{subject.inspect} should have been nil, but wasn't"
    end

    # Numerics
    def >(other)
      check subject > other, "#{subject.inspect} should have been greater than #{other.inspect}, but wasn't"
    end

    def >=(other)
      check subject >= other, "#{subject.inspect} should have been greater or equal than #{other.inspect}, but wasn't"
    end

    def <(other)
      check subject < other, "#{subject.inspect} should have been less than #{other.inspect}, but wasn't"
    end

    def <=(other)
      check subject <= other, "#{subject.inspect} should have been less or equal than #{other.inspect}, but wasn't"
    end

    def between(o1, o2)
      check subject.between?(o1, o2), "#{subject.inspect} should have been between #{o1.inspect} and #{o2.inspect}, but wasn't"
    end

    def within(diff, o)
      v1 = o - diff
      v2 = o + diff

      check subject.between?(v1, v2), "#{subject.inspect} should have been within #{diff} of #{v1.inspect} and #{v2.inspect}, but wasn't"
    end

    ## Exceptions & throw
    def raises(e)
      subject.call
      self.message = "#{subject.inspect} should have raised #{e.inspect}, but didn't"
      run.fail(self)
    rescue e
      run.pass(self)
    end

    def throws(symbol)
      catch(symbol) do
        subject.call
        self.message = "#{subject.inspect} should have thrown #{symbol.inspect}, but didn't"
        run.fail(self)
      end
      run.pass(self)
    end

    # Predicate Methods
    def method_missing(method, *args)
      if subject.respond_to?("#{method}?")
        check subject.send("#{method}?", *args), "#{subject.inspect} should have been #{method} #{args}, but wasn't"
      else
        raise NoMethodError, "method"
      end
    end

    def changes(result)
      previous_result = result.call
      subject.call
      current_result = result.call
      check previous_result != current_result, "#{subject.inspect} should have changed #{previous_result}, but didn't"
    end

    ## changes
    # check(-> { ... }).changes(-> {})

    # def instance_of(klass)
    #   check subject.instance_of?(klass), "#{subject.inspect} should be instance of #{klass.inspect} instead of #{subject.class}"
    # end
  end

  class Check
    include Sugar
    include Checks
    attr_reader :subject, :caller, :message, :inverted, :run

    def initialize(subject, caller, run = Preflight.run)
      @subject = subject
      @caller = caller
      @message = ""
      @inverted = false
      @run = run
    end

    def check(condition, msg = "Check failed.")
      self.message = msg
      condition = !condition if inverted
      condition ? run.pass(self) : run.fail(self)
    rescue => e
      self.message = e.message
      run.fail(self)
    end

    private

    attr_writer :message
  end

  class Checklist
    attr_reader :name, :caller, :block, :error, :printer, :run, :args

    def initialize(name, caller, printer = Preflight.printer, run = Preflight.run, &block)
      @name = name
      @caller = caller
      @block = block
      @printer = printer
      @run = run
      GTK::Entity.__reset_id__!
      @args = GTK::Args.new $gtk, nil
    end

    def verify
      printer.checklist self
      instance_eval(&block)
    rescue => e
      @error = e
      run.fail(self)
    end

    def check(subject)
      Check.new(subject, caller)
    end
  end

  class Printer
    COLORS = {red: 31, green: 32, yellow: 33, blue: 34, magenta: 35, cyan: 36, gray: 90}.freeze

    def color(color, string)
      "\e[#{COLORS[color]}m#{string}\e[0m"
    end

    def print(m)
      $stdout.print m
    end

    COLORS.each do |name, _|
      define_method name, ->(string) { color(name, string) }
    end

    def pass(check)
      print green "+"
    end

    def fail(check)
      print red "F"
    end

    def checklist(checklist)
      name = blue(checklist.name || checklist.caller.first.split(":in").first)
      print "\nChecking #{name}:  "
    end

    def summary passes, failures
      failed = failures.count
      passed = passes.count
      total = failed + passed

      print "\n\n#{blue total} checks verified:  #{green passed} Passed   #{red failed} Failed\n\n"

      failures.each.with_index do |check, i|
        print red "#{i}) "

        if check.is_a? Check
          print check.message.to_s << gray(" (#{check.caller.first})")
        elsif check.is_a? Checklist
          name = check.name ? "'#{check.name}'" : ""
          trace = format_trace(check.error.backtrace)
          print "In checklist #{blue name.to_s} #{gray "(#{check.caller.first})"}: #{red check.error.message} \n\n#{trace}\n\n"
        end
      end
      print green "All good!" if failures.empty? && total > 0
    end

    def format_trace(trace)
      trace.reject { |frame| frame.include? "Preflight.rb" }.join("\n").gsub(":in ", " in ")
    end
  end

  class Run
    attr_reader :failures, :passes, :printer

    def initialize(printer)
      @failures = []
      @passes = []
      @printer = printer
    end

    def pass(check)
      passes << check
      printer.pass check
    end

    def fail(check)
      failures << check
      printer.fail check
    end

    def failed?
      !failures.empty?
    end

    def status
      failed? ? 0 : 1
    end

    def results
      printer.summary passes, failures
    end
  end

  def self.checklists
    @@checklists ||= []
  end

  def self.before_blocks
    @@before_blocks ||= []
  end

  def self.after_blocks
    @@after_blocks ||= []
  end

  def self.before(&block)
    before_blocks << block
  end

  def self.after(&block)
    after_blocks << block
  end

  def self.run
    @@run ||= Run.new printer
  end

  def self.run=(r)
    @@run = r
  end

  def self.printer=(printer)
    @@printer = printer
  end

  def self.printer
    @@printer ||= Printer.new
  end

  def self.checklist(name = nil, &block)
    Preflight.checklists << Checklist.new(name, caller, &block)
  end

  def self.define(&block)
    class_eval(&block)
  end

  def self.verify(&block)
    Preflight.checklists.each do |checklist|
      Preflight.before_blocks.each(&:call)
      checklist.verify
      Preflight.after_blocks.each(&:call)
    end

    Preflight.run.results
  end
end

def Preflight(&block)
  Preflight.define(&block)
end
