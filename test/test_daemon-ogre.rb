#Example

require 'daemon-ogre'

DaemonOgre.start :name      => "MySuperAppName!",          #this will be the name of the application
                 :log_path  => "./var/log/log_file_name",  #this will be the logfile place and name
                 :pid_path  => "./var/pid/pid_file_name",  #this will be the pidfile place and name
                 :terminate => true                        #this command not let start your code if it's not started
                                                           # with "start" arguments like :
                                                           #                  ruby my_awsome_app.rb start

#by default all you need to do is require daemon-ogre and than start it in the main file head...
#DaemonOgre.start
#yepp, that's all...

#othere stuffs to use:
#everybody love: require_relative...
#so why should not try require_directory instead all the fuss
#you can tell to it if you want some file to be excluded or just delayed loaded,
#because you want them loaded in the last place
#Example:

require_directory "some_dir_name_from_here_where_are_multi_dir_levels"

#or

require_directory "some_dir_name_from_here_where_are_multi_dir_levels",
                  :delayed => ["files","to","be","delayed","in","load"],
                  :exclude => ["files","to","be","exclude","in","load"]

#and ofc what else what we love if not our beloved yml-s
#we should use a nice Config constant for this(or at least i love to do)

CONFIG = require_ymls "some_dir_name_from_here_where_are_the_yml_files_in_multi_dir_level"
#the file names will be the hash-key and under that , there will be the yml file datas loaded in