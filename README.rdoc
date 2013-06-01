daemon-ogre
===========

Description
-----------

This gem is made for one purpose. 

Ruby meant to be for easy use, not hardcore coding! 
And in terms for this, ogre will aid you in the brute way, so you can relax... 

Are you need load a whole bunch of folders to your rack application ? 
Do it! You want one nice hash for config constant 
from ymls all over your dirs? sure you can! you want have 
start/stop/status/restart/daemon/etc argument commands from 
terminal to control your application without any fuss? 
There you go! Are you need an easy way, 
to do the classic way of daemonise your awsome app? 
There will be no problem at all, let the Ogre do the job!

so all you need is enjoy your code! 
Follow me on Github and send request, 
if you have idea what can be usefull in creating your app :) 



Installation
------------

### [RubyGems](http://rubygems.org/)

$ gem install 'daemon-ogre'


require 'daemon-ogre'
DaemonOgre.start


but we love config our beloved App!
-----------------------------------


    DaemonOgre.start :name      => "MySuperAppName!",          #this will be the name of the application
                     :log_path  => "./var/log/log_file_name",  #this will be the logfile place and name
                     :pid_path  => "./var/pid/pid_file_name",  #this will be the pidfile place and name
                     :terminate => true                        #this command not let start your code if it's not started
                                                               # with "start" arguments like :
                                                               #                  ruby my_awsome_app.rb start

In use?
-------


you can simply use your terminal with arguments like
* start - for start the process if you choosed :terminate => true in code like above
start command will check does the application already running or not, so you dont have to worry about

* stop     - will terminate the running application
* restart  - will stop the process if that is already running than start again
* debug    - this will show the fancy loadings if you want look busy by coding big stuffs :) (or debug your code)
* debugger - this will call the ruby debugger gem to aid you in trouble
you should use these commands:


    set autolist on   #show the code, and the position like and editor, in every step. 
    s                 #step in any kind of method, beware to use carefully because you end up in really deep somewhere in Alice world
    n                 #step to next code/codeblock etc, without enter it (usefull when you find the right place)
    l                 #list your current position
                      #simply hit enter to repeate the last one
    
    
* daemon or -d -this will fork a child process by the given parameters
* log    or -l -you can set the log file position n by terminal for one time run
* pid    or -p -you can set the pid file position n name by terminal for one time run
* status or -s -this will tell you ,does your process is running not 
* help         -this will invoke some help to the terminal if you out of luck and forget everything from this page
* clear        -this will remove every log by the prev given paths, usefull in debugging

example:

    ruby my_awsome_app.rb start debugger
    ruby my_awsome_app.rb start clear
    ruby my_awsome_app.rb status
    ruby my_awsome_app.rb stop
    ruby my_awsome_app.rb debug
   
   
or if you dont use terminate command , than you can start simply as how you do normaly



othere stuffs to use:
---------------------
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



Helpers
-------

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
        exlogger ex,            #error_msg
                 prefix,        #this is optionable! but i usualy use: "#{__FILE__}/#{__LINE__}"
                 log_file       #this is optionable!
    end
    
    #or with less fuss
    
    
    begin
    
    rescue Exception => ex
        ex.logger
    end
    
    
    


if you need methods from any kind of class without the object methods, you should try this!


    Xyclassname.class_methods


you want make some test script with rnd numbers, strings, dates, bools etc? use the Rnd class at your command


    Rnd
    -string
    -number
    -boolean
    -date


examples:


    Rnd.number(100)
    Rnd.string(15,2) #for rnd bla bla names
    


You need get the index of an Array element? you can use:



    array_variable.index_of("something)


Do you wanted to know , does that process running on that pid or not?



    process_running?(nmbr)




in Short:
---------

    require 'daemon-ogre'
    DaemonOgre.start
    your_Super_app_code!





Contributing to daemon-ogre
---------------------------

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

Copyright
---------

Right to copy and use at your service fellow coder
Copyright (c) 2013 adam.luzsi. See LICENSE.txt for
further details.


daemon-ogre
