daemon-ogre
===========

= daemon-ogre


gem install 'daemon-ogre'


require 'daemon-ogre'
DaemonOgre.start


 but we love config our beloved App!
-======================================================================================================================-
DaemonOgre.start :name      => "MySuperAppName!",          #this will be the name of the application
                 :log_path  => "./var/log/log_file_name",  #this will be the logfile place and name
                 :pid_path  => "./var/pid/pid_file_name",  #this will be the pidfile place and name
                 :terminate => true                        #this command not let start your code if it's not started
                                                           # with "start" arguments like :
                                                           #                  ruby my_awsome_app.rb start


-======================================================================================================================-
 othere stuffs to use:
 everybody love: require_relative...
 so why should not try require_directory instead all the fuss
 you can tell to it if you want some file to be excluded or just delayed loaded,
 because you want them loaded in the last place
 Example:

require_directory "some_dir_name_from_here_where_are_multi_dir_levels"

 or

require_directory "some_dir_name_from_here_where_are_multi_dir_levels",
                  :delayed => ["files","to","be","delayed","in","load"],
                  :exclude => ["files","to","be","exclude","in","load"]


-======================================================================================================================-
and ofc what else what we love if not our beloved yml-s
we should use a nice Config constant for this(or at least i love to do)

CONFIG = require_ymls "some_dir_name_from_here_where_are_the_yml_files_in_multi_dir_level"
 the file names will be the hash-key and under that , there will be the yml file datas loaded in

 if you need get a free port in a range or from, you can use this:
get_port(from_nmb,to_nmb,host)

 or by simply

get_port(number)


 and if you hate find all the bugs... you can use error_logger at your command like this:


begin

    your awsome code!

rescue xyexception => ex
    logger ex,            #error_msg
           prefix,        #this is optionable! but i usualy use: "#{__FILE__}/#{__LINE__}"
           log_file       #this is optionable!
end


if you need methods from any kind of class without the object methods, you should try this!
Xyclassname.class_methods


you want make some test script with rnd numbers, strings, dates, bools etc? use the Rnd class at your command
Rnd
-string
-number
-boolean
-date

example: Rnd.number(100)
or       Rnd.string(15,2) #for rnd bla bla names


You need get the index of an Array element? you can use:
array_variable.index_of("something)



-=========================================================-



in Short:
require 'daemon-ogre'
DaemonOgre.start

for boot your files and ymls, helpers above :)
your_Super_app_code!




== Contributing to daemon-ogre

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

== Copyright

Copyright (c) 2013 adam.luzsi. See LICENSE.txt for
further details.



daemon-ogre
