#DaemonOgreBody
begin
  module DaemonOgre

    #OgreClassMethods
    begin
      class << self
        #Based on the rb location
        def load_directory(directory,*args)
          arg = Hash[*args]

          #directory = File.expand_path(directory)

          if !arg[:delayed].nil?
            raise ArgumentError, "Delayed items must be in an "+\
            "Array! Example:\n:delayed => ['abc']" if arg[:delayed].class != Array
          end

          if !arg[:excluded].nil?
            raise ArgumentError, "Exclude items must be in an "+\
            "Array! Example:\n:exclude => ['abc']" if arg[:excluded].class != Array
          end

          arg[:type]= "rb" if arg[:type].nil?

          #=============================================================================================================

          ### GET Pre path + validation
          begin
          #get method callers path
          pre_path = caller[1].split('.rb:').first+('.rb')
          separator_symbol= String.new
          pre_path.include?('/') ? separator_symbol = '/' : separator_symbol = '\\'
          pre_path= ((pre_path.split(separator_symbol))-([pre_path.split(separator_symbol).pop])).join(separator_symbol)
          puts pre_path
          end

          puts "LOADING_FILES_FROM_"+directory.to_s.split(separator_symbol).last.split('.').first.capitalize if $DEBUG

          delayed_loads = Array.new


          puts File.join("#{pre_path}","#{directory}","**","*.#{arg[:type]}")
          puts Dir[File.join("#{pre_path}","#{directory}","**","*.#{arg[:type]}")].inspect

          Dir[File.join("#{pre_path}","#{directory}","**","*.#{arg[:type]}")].each do |file|


            arg[:delayed]= [nil] if arg[:delayed].nil?
            arg[:excluded]= [nil] if arg[:excluded].nil?

            arg[:excluded].each do |except|
              if file.split(separator_symbol).last.split('.').first == except.to_s.split('.').first
                puts file.to_s + " cant be loaded because it's an exception" if $DEBUG
              else
                arg[:delayed].each do |delay|
                  if file.split(separator_symbol).last.split('.').first == delay.to_s.split('.').first
                    delayed_loads.push(file)
                  else
                    load(file)
                    puts file.to_s if $DEBUG
                  end
                end
              end
            end
          end
          delayed_loads.each do |delayed_load_element|
            load(delayed_load_element)
            puts delayed_load_element.to_s    if $DEBUG
          end
          puts "DONE_LOAD_FILES_FROM_"+directory.to_s.split(separator_symbol).last.split('.').first.capitalize   if $DEBUG

        end

        def get_port(port,max_port=65535 ,host="0.0.0.0")

          require 'socket'
          port     = port.to_i

          begin
            server = TCPServer.new('0.0.0.0', port)
            server.close
            return port
          rescue Errno::EADDRINUSE
            port = port.to_i + 1  if port < max_port+1
            retry
          end

        end

        def error_logger(error_msg,prefix="",log_file=App.log_path)

          ###convert error msg to more human friendly one
          begin
            error_msg= error_msg.to_s.gsub('", "','",'+"\n\"")
          rescue Exception
            error_msg= error_msg.inspect.gsub('", "','",'+"\n\"")
          end

          if File.exists?(File.expand_path(log_file))
            error_log = File.open( File.expand_path(log_file), "a+")
            error_log << "\n#{Time.now} | #{prefix}#{":" if prefix != ""} #{error_msg}"
            error_log.close
          else
            File.new(File.expand_path(log_file), "w").write(
                "#{Time.now} | #{prefix}#{":" if prefix != ""} #{error_msg}"
            )
          end

          return {:error => error_msg}
        end

        def load_ymls(directory)

          require 'yaml'
          #require "hashie"

          yaml_files = Dir["#{directory}/**/*.yml"].each { |f| puts f.to_s  if $DEBUG  }
          puts "\nyaml file found: "+yaml_files.inspect.to_s    if $DEBUG
          @result_hash = {}
          yaml_files.each_with_index do |full_path_file_name|


            file_name = full_path_file_name.split('/').last.split('.').first

            hash_key = file_name
            @result_hash[hash_key] = YAML.load(File.read("#{full_path_file_name}"))

            #@result_hash = @result_hash.merge!(tmp_hash)


            puts "=========================================================="      if $DEBUG
            puts "Loading "+file_name.to_s.capitalize+"\n"                         if $DEBUG
            puts YAML.load(File.read("#{full_path_file_name}"))                    if $DEBUG
            puts "__________________________________________________________"      if $DEBUG

          end

          puts "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"         if $DEBUG
          puts "The Main Hash: \n"+@result_hash.inspect.to_s                       if $DEBUG
          puts "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\n"       if $DEBUG

          return @result_hash
        end

        def create_on_filesystem(route_name,optionable_file_mod="w",optionable_data=nil)
          begin

            #file_name generate
            if !route_name.to_s.split('/').last.nil? || route_name.to_s.split('/').last != ''
              file_name = route_name.to_s.split('/').last
            else
              file_name = nil?
            end

            #path_way
            begin
              raise ArgumentError, "missing route_name: #{route_name}"   if route_name.nil?
              path = File.expand_path(route_name).to_s.split('/')
              path = path - [File.expand_path(route_name).to_s.split('/').last]
              path.shift
            end

            #job
            begin
              if !Dir.exists?('/'+path.join('/'))

                at_now = '/'
                path.each do |dir_to_be_checked|

                  at_now += "#{dir_to_be_checked}/"
                  Dir.mkdir(at_now) if !Dir.exists?(at_now)

                end
              end
            end

            #file_create
            File.new("/#{path.join('/')}/#{file_name}", optionable_file_mod ).write optionable_data

          rescue Exception => ex
            puts ex
          end
        end

        def process_running?(input)
          begin
            Process.getpgid input.chomp.to_i
            return true
          rescue Exception
            return false
          end
        end

        def clone_mpath(original_path,new_name)
          log_path = File.expand_path(original_path)
          log_path = log_path.split('/')
          log_path.pop
          log_path.push(new_name)
          log_path = log_path.join('/')

          return log_path
        end

      end
    end

    #config
    begin
      class App
        class << self
          attr_accessor :log_path,
                        :pid_path,
                        :daemon_stderr,
                        :exceptions,
                        :exlogger,
                        :app_name,
                        :port,
                        :terminate
        end
      end
    end

    #default
    begin
      App.log_path   = "./var/log/logfile.log"
      App.pid_path   = "./var/pid/pidfile.pid"
      App.terminate  = false
      App.port       = 80
      App.app_name   = $0

      begin
        ['daemon_stderr','exceptions','exlogger'].each do |one_log|

          App.__send__(one_log+"=",clone_mpath(App.log_path,one_log+".log"))

        end
      end

    end

    #DaemonEngine
    begin
      class Daemon
        # Checks to see if the current process is the child process and if not
        # will update the pid file with the child pid.
        def self.start pid, pidfile, outfile, errfile
          unless pid.nil?
            raise "Fork failed" if pid == -1
            write pid, pidfile #if kill pidfile
            exit
          else
            redirect outfile, errfile
          end
        end

        # Attempts to write the pid of the forked process to the pid file.
        def self.write pid, pidfile
          DaemonOgre.create_on_filesystem pidfile
          File.open pidfile, "a+" do |new_line|
            new_line.write "#{pid}\n"
          end
        rescue ::Exception => e
          $stderr.puts "While writing the PID to file, unexpected #{e.class}: #{e}"
          Process.kill "HUP", pid
        end

        # Try and read the existing pid from the pid file and signal the
        # process. Returns true for a non blocking status.
        def self.kill(pidfile)
          opid = open("./#{pidfile}").read.strip.to_i
          Process.kill 'HUP', opid.to_i
          true
        rescue Errno::ENOENT
          $stdout.puts "#{pidfile} did not exist: Errno::ENOENT"                        if $DEBUG
          true
        rescue Errno::ESRCH
          $stdout.puts "The process #{opid} did not exist: Errno::ESRCH"                if $DEBUG
          true
        rescue Errno::EPERM
          $stderr.puts "Lack of privileges to manage the process #{opid}: Errno::EPERM" if $DEBUG
          false
        rescue ::Exception => e
          $stderr.puts "While signaling the PID, unexpected #{e.class}: #{e}"           if $DEBUG
          false
        end

        # Send stdout and stderr to log files for the child process
        def self.redirect outfile, errfile
          $stdin.reopen '/dev/null'
          out = File.new outfile, "a"
          err = File.new errfile, "a"
          $stdout.reopen out
          $stderr.reopen err
          $stdout.sync = $stderr.sync = true
        end
      end
    end

    #server_model
    begin
      class Server
        @@startup = false
        class << self

          def daemon
            puts "#{$0} daemon is watching you..."
            DaemonOgre.create_on_filesystem DaemonOgre::App.pid_path,
                                            'a+'
            DaemonOgre.create_on_filesystem DaemonOgre::App.log_path,
                                            'a+'
            DaemonOgre.create_on_filesystem DaemonOgre::App.daemon_stderr,
                                            'a+'


            DaemonOgre::Daemon.start fork,
                         DaemonOgre::App.pid_path,
                         DaemonOgre::App.log_path,
                         DaemonOgre::App.daemon_stderr
          end

          def debug
            $DEBUG = true
          end

          def help
            puts "\nyou can use one of these commands: "+\
            "\nstart	daemon -d	stop	restart	log	-l	pid	-p	port	-tcp	status	reset	help"+\
            "\n==============================================================================DESC======>>"
            puts "start\t\t\t\t=> this will start the #{$0}"+\
             "\ndaemon\t\t\t\t=> this will make is daemon process"+\
             "\nstop\t\t\t\t=> this will kill the last process with pidfile"+\
             "\nrestart\t\tor reset\t=> hard restart"+\
             "\nlog\t\tor -l\t\t=> logfile place"+\
             "\npid\t\tor -p\t\t=> pid file place (if you want set the filename as well, put .pid or .txt in the end)"+\
             "\nport\t\tor -tcp\t\t=> user definiated port"+\
             "\nstatus\t\t\t\t=> last process alive?"+\
             "\ndebug\t\tor -d\t\t=> show debug log (you can make your own by using 'puts 'xy' if $DEBUG' "+\
             "\nhelp\t\t\t\tgive you this msg :)\n"
            DaemonOgre::App.terminate=true
          end

          def start
            if File.exist?(File.expand_path(App.pid_path))
              text = File.open(File.expand_path(App.pid_path)).read
              terminate_on_command = Array.new
              text.each_line do |line|
                terminate_on_command.push DaemonOgre.process_running?(line)
              end
            end

            if !terminate_on_command.nil?
              if !terminate_on_command.include?(true)
                @@startup = true
              else
                puts "sorry but process is already running in this specification"
                Process.exit
              end
            else
              @@startup = true
            end
          end

          def stop
            puts "#{$0} is going to be FacePalmed..."
            Daemon.kill DaemonOgre::App.pid_path
            kill_with_pid
            File.open(DaemonOgre::App.pid_path, "w").write("")
            DaemonOgre::App.terminate=true

          end

          def restart

            Daemon.kill DaemonOgre::App.pid_path
            kill_with_pid
            File.open(DaemonOgre::App.pid_path, "w").write("")
            start

          end

          def kill_with_pid
            begin
              if File.exists?(DaemonOgre::App.pid_path)
                puts "PidFile found, processing..."  if $DEBUG
                File.open(DaemonOgre::App.pid_path).each_line do |row|
                  begin
                    Process.kill 'TERM', row.to_i
                    puts "terminated process at: #{row}" if $DEBUG
                  rescue Exception => ex
                    puts "At process: #{row}, #{ex}"     if $DEBUG
                  end
                end
              else
                system "ps -ef | grep #{$0}"
                #system "netstat --listen"
                #puts "\nLepton is around 10300-10399"
              end
            rescue Exception => ex
              puts "Exception has occured: #{ex}"
            end
          end

          def continue?
            Process.exit if !@@startup
          end

          def set_log(param)
            ARGV.each do |one_parameter|
              if one_parameter == param
                DaemonOgre::App.log_path= ARGV[ARGV.index(one_parameter)+1]
              end
            end
          end

          def set_pid(param)
            ARGV.each do |one_parameter|
              if one_parameter == param
                if ARGV[ARGV.index(one_parameter)+1].to_s.include?(".pid") ||\
                   ARGV[ARGV.index(one_parameter)+1].to_s.include?(".txt")
                  DaemonOgre::App.pid_path= ARGV[ARGV.index(one_parameter)+1]
                else
                  DaemonOgre::App.pid_path= ARGV[ARGV.index(one_parameter)+1].to_s+"lepton.pid"
                end
              end
            end
          end

          def set_port(param)
            ARGV.each do |one_parameter|
              if one_parameter == param
                DaemonOgre::App.port= ARGV[ARGV.index(one_parameter)+1]
              end
            end
          end

          def pid
            begin
              if !DaemonOgre::App.pid_path.nil?
                DaemonOgre::App.pid_path+="lepton.pid"  if !DaemonOgre::App.pid_path.include?(".pid")
                pre_path = File.dirname "#{File.dirname(__FILE__)}/#{DaemonOgre::App.pid_path}"
                pre_path_array = pre_path.split('/') - [ pre_path[0].to_s ]
                if !Dir.exists?(pre_path)
                  at_now = String.new
                  pre_path_array.each do |one_dir_to_be_made|
                    #at_now show the place where we are now
                    at_now == ""  ?  at_now += one_dir_to_be_made  :  at_now += "/"+one_dir_to_be_made
                    if !Dir.exists?("#{File.dirname(__FILE__)}/#{at_now}")
                      Dir.mkdir("#{File.dirname(__FILE__)}/#{at_now}")
                    end
                  end
                end
                File.new("#{File.dirname(__FILE__)}/#{DaemonOgre::App.pid_path}", "a+").write Process.pid.to_s+"\n"
              end
            rescue Exception => ex
              ex.logger
            end
          end

          def pid_check
            if File.exist?(File.expand_path(App.pid_path))
              puts "checking pidfile:"
              text = File.open(File.expand_path(App.pid_path)).read
              text.each_line do |line|
                puts "#{line.chomp}:\t#{DaemonOgre.process_running?(line)}"
              end
            else
              puts "missing pid file (with default path) "+\
              "\nif you specificated one manualy pls type"+\
              " the path first in with '-p xy/xzt.pid'"
            end
            DaemonOgre::App.terminate=true
          end

          def clear

            logs = ['loh_path','daemon_stderr','exceptions','exlogger']

            logs.each do |logname|
              begin
               File.delete DaemonOgre::App.__send__(logname)
              rescue Exception => ex
                puts ex if $DEBUG
              end
            end

          end

        end
      end
    end

  end
end

#monkey patch
begin
  def process_running?(input)
    DaemonOgre.process_running?(input)
  end
  def require_directory(directory,*args)
    DaemonOgre.load_directory(directory,*args)
  end
  def require_ymls(directory)
    DaemonOgre.load_ymls(directory)
  end
  def get_port(port,max_port=65535 ,host="0.0.0.0")
    DaemonOgre.get_port(port,max_port,host)
  end
  def exlogger(error_msg,*args)
    arg=Hash[*args]
    arg[:prefix] = String.new                if arg[:prefix].nil?
    arg[:path]   = DaemonOgre::App.exlogger  if arg[:path].nil?
    DaemonOgre.create_on_filesystem arg[:path],
                         'a+'
    DaemonOgre.error_logger(error_msg,arg[:prefix],arg[:path])
  end
  class Exception
    def logger
      DaemonOgre.create_on_filesystem DaemonOgre::App.exceptions,
                                      'a+'
      DaemonOgre.error_logger(self.backtrace,self,DaemonOgre::App.exceptions)
    end
  end
  class File
    def self.create!(file,optionable_data=nil,optionable_file_mod="w")
      DaemonOgre.create_on_filesystem file,
                                      optionable_file_mod,
                                      optionable_data
    end
  end
  class Class
    def class_methods
      self.methods - Object.methods
    end
    def self.class_methods
      self.methods - Object.methods
    end
  end
  class Rnd
    class << self
      def string(length,amount=1)
        mrg = String.new
        first_string = true
        amount.times do
          a_string = Random.rand(length)
          a_string == 0 ? a_string += 1 : a_string
          mrg_prt  = (0...a_string).map{ ('a'..'z').to_a[rand(26)] }.join
          first_string ? mrg += mrg_prt : mrg+= " #{mrg_prt}"
          first_string = false
        end
        return mrg
      end
      def integer(length)
        Random.rand(length)
      end
      def boolean
        rand(2) == 1
      end
      def date from = Time.at(1114924812), to = Time.now
        rand(from..to)
      end
    end
  end
  class Array
    def index_of(target_element)
      array = self
      hash = Hash[array.map.with_index.to_a]
      return hash[target_element]
    end
  end
  class Hash
    #pass single or array of keys, which will be removed, returning the remaining hash
    def remove!(*keys)
      keys.each{|key| self.delete(key) }
      self
    end
    #non-destructive version
    def remove(*keys)
      self.dup.remove!(*keys)
    end
  end
end

#StartUp
begin
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
end