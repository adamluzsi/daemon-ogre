require_relative File.join '..','lib','daemon-ogre.rb'

# start as
#   ruby sample_daemon_app.rb start daemon
#
# to check it's running
#   ps aux | grep MySuperAppName

DaemonOgre.start :name      => "MySuperAppName",
                 :log_path  => File.join('.','var','log','log_file_name'),
                 :pid_path  => File.join('.','var','pid','pid_file_name'),
                 :terminate => true

10.times do

  puts Time.now
  sleep 1

end
