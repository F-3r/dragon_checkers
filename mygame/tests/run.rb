$gtk.reset 100
$gtk.log_level = :off

#Preflight.before { print "-" * 50 }
#Preflight.after { print "\n#{"-" * 50}" }

Preflight.verify
