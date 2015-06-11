$LOAD_PATH.unshift(File.join(File.dirname(__FILE__),'..','lib'))
require 'daemon-ogre'

# start as
#   ruby sample_daemon_app.rb --daemon
# puts "app name: #{$0}"
ARGV.unshift '--daemon'
puts "ps aux | grep #{$0}"
puts "tail -f #{DaemonOgre::OPTS.tmp_folder_path}/*"

DaemonOgre.init

10.times do

  puts Time.now
  sleep 1

end

raise('some err')