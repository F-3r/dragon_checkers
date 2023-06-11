$gtk.reset 100
$gtk.log_level = :off

Checkers.before { print "-" * 50 }
Checkers.after { print "\n#{"-" * 50}\n\n" }

Checkers.verify
