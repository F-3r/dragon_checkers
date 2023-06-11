Checkers.checklist "checklists hold an instance of DragonRuby args" do
  check(args).is.instance_of GTK::Args
  check(args.state).is.instance_of GTK::OpenEntity
  check(args.outputs.primitives).equals []
end
