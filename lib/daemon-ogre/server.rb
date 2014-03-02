#DaemonOgreBody
begin
  module DaemonOgre

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