module Checkers
  module Sugar
    def not; @inverted = !inverted; self; end
    def is; self; end
    def are; self; end
  end

  module Checks
    def empty
      check subject.empty?, "#{subject.inspect} should be empty, but wasn't"
    end

    def ==(o)
      check subject == o, "#{subject.inspect} should be equal to #{o.inspect}, but wasn't"
    end
    alias :equals :==

    def matches(pattern)
      check subject.match(pattern), "#{subject.inspect} should match with #{pattern.inspect}, but didn't"
    end

    def includes(o)
      check subject.include?(o), "#{subject.inspect} should include #{o.inspect}, but doesn't"
    end

    def counts(n)
      check subject.count == n, "#{subject.inspect} count should equal  #{n.inspect}, but was #{subject.count}"
    end

    def instance_of(klass)
      check subject.instance_of?(klass), "#{subject.inspect} should be instance of #{klass.inspect} instead of #{subject.class}"
    end

    def raises(e)
      subject.call
      self.message = "#{subject.inspect} should raise #{e.inspect}, but didn't"
      run.fail(self)
    rescue e
      run.pass(self)
    end
  end

  class Check
    include Checks, Sugar
    attr_reader :subject, :caller, :message, :inverted, :run

    def initialize(subject, caller, run = Checkers.run)
      @subject = subject
      @caller = caller
      @message = ''
      @inverted = false
      @run = run
    end

    def check(condition, msg = 'Check failed.')
      self.message = msg
      condition = !condition if inverted
      condition ? run.pass(self) : run.fail(self)
    rescue StandardError => e
      self.message = e.message
      run.fail(self)
    end

    private
    attr_writer :message
  end

  class Checklist
    attr_reader :name, :caller, :block, :error, :printer, :run, :args

    def initialize(name, caller, printer = Checkers.printer, run = Checkers.run, &block)
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
    rescue StandardError => e
      @error = e
      run.fail(self)
    end

    def check(subject)
      Check.new(subject, caller)
    end
  end

  class Printer
    COLORS = { red: 31, green: 32, yellow: 33, blue: 34, magenta: 35, cyan: 36, gray:  90 }.freeze

    def color(color, string)
      "\e[#{COLORS[color]}m#{string}\e[0m"
    end

    def print(m)
      STDOUT.print m
    end

    COLORS.each do |name, _|
      define_method name, ->(string) { color(name, string) }
    end

    def pass(check)
      print green '+'
    end

    def fail(check)
      print red "F"
    end

    def checklist(checklist)
      name = checklist.name ? blue(checklist.name) : blue(checklist.caller.first.split(":in").first)
      print "\nChecking #{name}:  "
    end

    def summary passes, failures
      failed = failures.count
      passed = passes.count
      total  = failed + passed

      print "\n\n#{blue total} checks verified:  #{green passed} Passed   #{red failed} Failed\n\n"

        failures.each.with_index do  |check, i|
          print red "#{i}) "

          if check.is_a? Check
            print "#{check.message}" << gray(" (#{check.caller.first})")
          elsif check.is_a? Checklist
            name = check.name ? "'#{check.name}'" : ""
            trace = format_trace(check.error.backtrace)
            print "In checklist #{ blue "#{name}" } #{ gray "(#{check.caller.first})" }: #{red check.error.message} \n\n#{trace}\n\n"
          end
        end
        print green "All good!" if failures.empty? && total > 0
    end

    def format_trace(trace)
      trace.reject { |frame| frame.include? "checkers.rb" }.join("\n").gsub(":in ", " in ")
    end
  end

  class Run
    attr_reader :failures, :passes, :printer

    def initialize(printer)
      @failures = []
      @passes   = []
      @printer  = printer
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
    Checkers.checklists << Checklist.new(name, caller, &block)
  end

  def self.define(&block)
    class_eval(&block)
  end

  def self.verify(&block)
    Checkers.checklists.each do |checklist|
      Checkers.before_blocks.each(&:call)
      checklist.verify
      Checkers.after_blocks.each(&:call)
    end

    Checkers.run.results
  end
end

def Checkers(&block)
  Checkers.define(&block)
end
