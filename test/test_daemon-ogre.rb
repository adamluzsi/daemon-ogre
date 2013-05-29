require_relative "../lib/daemon-ogre.rb"

DaemonOgre.start :name      => "api_one",          #this will be the name of the application
                 :log_path  => "./var/log/log_file_name",  #this will be the logfile place and name
                 :pid_path  => "./var/pid/pid_file_name",  #this will be the pidfile place and name
                 :terminate => true                        #this command not let start your code if it's not started
                                                           # with "start" arguments like :
                                                           #                  ruby my_awsome_app.rb start



#my awesome Hello App
puts "hello App!"

i=0
until i > 1200
  sleep 1
  puts "hello, there! A wonderful day for the #{i}. time! isn't it?"
  i+=1
end

puts "-=end=-"