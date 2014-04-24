# use Daemon.daemonize or Process.daemonize
module DaemonOgre

  module Daemon

    class << self


      # Checks to see if the current process is the child process and if not
      # will update the pid file with the child pid.
      def start pid
        unless pid.nil?
          raise "Fork failed" if pid == -1
          OPTS.pidfile= pid
          ::Kernel.exit
        else
          redirect
        end
      end

      # Attempts to write the pid of the forked process to the pid file.
      def write pid
        OPTS.pid= pid

        File.open pidfile, "a+" do |new_line|
          new_line.write "#{pid}\n"
        end

      rescue ::Exception => e
        $stderr.puts "While writing the PID to file, unexpected #{e.class}: #{e}"
        Process.kill "HUP", pid
      end

      # Try and read the existing pid from the pid file and signal the
      # process. Returns true for a non blocking status.
      def kill

        opid  = OPTS.pidfile.to_i
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
      def redirect

        OPTS.out__path__
        OPTS.err__path__

        var= 3
        begin

          $stdin.reopen   File.join('','dev','null')
          $stdout.reopen  OPTS.out__path__
          $stderr.reopen  OPTS.err__path__
          $stdout.sync =  $stderr.sync = true

        rescue Errno::ENOENT => ex
          var -= 1
          retry if var > 0
          raise ex.class,ex
        end

      end

      def term_kill
        unless OPTS.pidfile.nil?

          begin

            STDOUT.puts("PidFile found, processing...")   if $DEBUG
            Process.kill('TERM', OPTS.pidfile.to_i)
            return true

          rescue Exception => ex

            STDOUT.puts "Exception happened on terminating process: #{ex.class}, #{ex}" if $DEBUG
            return false

          end

        end
      end

      def terminate

        # kill methods
        app_killed= false
        [:kill,:term_kill,:kill_by_name].each do |method_name|
          app_killed= self.__send__ method_name
          break if app_killed
        end
        OPTS.pidfile= nil

        return app_killed

      end

      def kill_by_name

        # name switch
        target_name ||= $0
        $0 = "ruby_tmp_process"


        app_state= false

        start_time= Time.now
        while `ps aux | grep #{target_name}`.split(' ')[1] != ""  || (Time.now - start_time) < 6

          begin

            Process.kill "TERM",`ps aux | grep #{target_name}`.split(' ')[1].to_i

            app_state= true
          rescue Errno::ESRCH
            $stdout.puts "The process #{target_name} did not exist: Errno::ESRCH"                 if $DEBUG
            break
          rescue Errno::EPERM
            $stderr.puts "Lack of privileges to manage the process #{target_name}: Errno::EPERM"  if $DEBUG
            break
          rescue ::Exception => e
            $stderr.puts "While signaling the PID, unexpected #{e.class}: #{e}"                   if $DEBUG
            break
          end

        end


        # name switch back
        begin
          $0 = target_name
        end

        return app_state
      end

      def stop

        self.terminate
        ::Process.exit!

      end

      def init

        if DARGV.terminate?
          stop
        end

        if DARGV.daemonize?
          start( ::Kernel.fork )
        end

      end

      alias :new :init

    end
  end

  class << self
    def init
      Daemon.init
    end
    # alias :new :init
  end

end
