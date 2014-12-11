require 'daemon-ogre'

# start as
#   ruby sample_daemon_app.rb --daemon
# puts "app name: #{$0}"

DaemonOgre.init

60.times do

  puts Time.now
  sleep 1

end

sleep 1
# to check it's running
`ps aux | grep $0`
