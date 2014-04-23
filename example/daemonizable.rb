require_relative File.join '..','lib','daemon-ogre.rb'

# start as
#   ruby sample_daemon_app.rb --daemon
#
# to check it's running
#   `ps aux | grep $0`

DaemonOgre.init

10.times do

  puts Time.now
  sleep 1

end
