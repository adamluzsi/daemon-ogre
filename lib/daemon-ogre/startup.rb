module DaemonOgre
  def self.start(*args)
    arg = Hash[*args]

    ##defaults:
    #arg[:log_path]
    #arg[:pid_path]

    #arg[:name]
    #arg[:port]

    #arg[:terminate]
    #arg[:clear]

    begin

      begin

        App.pid_path  = arg[:pid_path]  if !arg[:pid_path].nil?
        App.log_path  = arg[:log_path]  if !arg[:log_path].nil?

        $0 = arg[:name]      if !arg[:name].nil?
        App.port      = arg[:port]      if !arg[:port].nil?

        App.terminate = arg[:terminate] if !arg[:terminate].nil?

      end


      if ARGV.nil?
        puts "No server task has been given!"
        DaemonOgre::Server.help
      end
      serv_load = Array.new
      ARGV.each do |one_argv_parameter|
        case one_argv_parameter.downcase
          when "start"    then serv_load.push  "start"
          when "daemon"   then serv_load.push  "daemon"
          when "-d"       then DaemonOgre::Server.debug
          when "stop"     then serv_load.push  "stop"
          when "restart"  then serv_load.push  "restart"
          when "reset"    then serv_load.push  "restart"
          when "debugger" then serv_load.push  "debugger"
          when "log"      then DaemonOgre::Server.set_log  "log"
          when "pid"      then DaemonOgre::Server.set_pid  "pid"
          when "-l"       then DaemonOgre::Server.set_log  "-l"
          when "-p"       then DaemonOgre::Server.set_pid  "-p"
          when "port"     then DaemonOgre::Server.set_port "port"
          when "-tcp"     then DaemonOgre::Server.set_port "-tcp"
          when "status"   then DaemonOgre::Server.pid_check
          when "-s"       then DaemonOgre::Server.pid_check
          when "help"     then DaemonOgre::Server.help
          when "debug"    then DaemonOgre::Server.debug
          when "clear"    then serv_load.push "clear"

        end
      end

      #server_TODO
      begin
        DaemonOgre::Server.restart      if serv_load.include? "restart"
        DaemonOgre::Server.start        if serv_load.include? "start"
        DaemonOgre::Server.stop         if serv_load.include? "stop"
        DaemonOgre::Server.clear        if serv_load.include? "clear"
        DaemonOgre::Server.daemon       if serv_load.include? "daemon"
      end

      #Continue our program ? : )
      DaemonOgre::Server.continue? if DaemonOgre::App.terminate

      begin
        require "debugger" ;debugger if serv_load.include? "debugger"
      rescue Exception => ex
        puts "you need to install debugger gem => gem install debugger\n#{ex}"
      end

    end
  end
  def self.help
    puts "\n##defaults:\narg[:log_path]\tlog path and"+\
    " file name\narg[:pid_path]\tpid path and file n"+\
    "ame\narg[:terminate]\tstart command required to"+\
    " continue? 'ruby xy.rb start'\narg[:name]\tapplication names as daemon process"
  end
end