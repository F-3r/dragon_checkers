require 'lib/checkers.rb'

# In order to avoid asyncronous require issues
# we follow the same strategy we use in games:
# require all the checklist files here:
require 'tests/equality_checks_checklist.rb'
require 'tests/collection_checks_checklist.rb'
require 'tests/string_checks_checklist.rb'
require 'tests/boolean_checks_checklist.rb'
#require 'tests/numeric_checks_checklist.rb'
require 'tests/dragon_ruby_args_checklist.rb'
require 'tests/empty_checklist.rb'
require 'tests/multiple_checklists.rb'

# and last, the script that verifies them all:
require 'tests/run.rb'
