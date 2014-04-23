require 'daemon-ogre.rb'

# start as
#   ruby sample_daemon_app.rb --daemon
#
# to check it's running
#   `ps aux | grep $0`

ARGVEXT.show_help
DaemonOgre.init

60.times do

  puts Time.now
  sleep 1

end
