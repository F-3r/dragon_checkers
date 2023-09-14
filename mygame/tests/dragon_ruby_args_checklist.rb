Preflight.checklist "DragonRuby args: checklists can access args" do
  check(args).is.instance_of GTK::Args
  check(args.state).is.instance_of GTK::OpenEntity
  check(args.outputs.primitives) == []
end
