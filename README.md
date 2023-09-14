# Preflight

_No one likes their dragon crashing in mid-flight..._

## What is this thing?

Dragon Checkers is a small testing library for [DragonRuby](dragonruby.itch.io/) with a checklist-oriented DSL

## How can I install it?

You can install it with `$gtk.download_stb_rb "f-3r", "dragon-checkers", "lib/checkers.rb"` or you can
copy `lib/checkers.rb` into to your project.

(You probably want to copy `tests/tests.rb` and `tests/run.rb` too (see following section))

## How to use it?

As requires are async in DR, it is recommended to follow the directory and files structure in this repo.
(see `tests` directory).

Besides that, you an organize your checklists as you wish.
(EG: single focused checklist per file or many in a single file)

An example will work better for explaining than code journalism, so...
we encourage you to take a look into the checklists in `/tests/*_checklist.rb`.
There you will find the complete list of checks currently supported and how to define checklists.

## How to test your game?
Each checklist holds an instance of `GTK::Args` (like the one you receive as parameters on DR native tests) that you can access with `#args`.

Here an example transcribed from [DragonRuby docs](http://docs.dragonruby.org.s3-website-us-east-1.amazonaws.com/#----physics-and-collisions---collision-with-object-removal---tests-rb):

```ruby
Checkers.checklist do
  game = MySuperHappyFunGame.new
  game.args = args
  game.tick

  check(args.outputs.solids).counts 1
  check(1).not == 2

  puts "test_universe completed successfully"
end
```

## can I add my own checks?

well yeah. Just open the `Checkers::Checks` module and add methods there, those will be available to send to your checks.

Take a look to the checks already implemented there, should be easy to add new ones!

## How can I change the reporting formatting?
Similarly, open the `Checkers::Printer` class and override or replace methods in there. Ugly and effective :rofl:
