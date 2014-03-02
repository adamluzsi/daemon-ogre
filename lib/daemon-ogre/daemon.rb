#DaemonOgreBody
begin
  module DaemonOgre

    #DaemonEngine
    begin
      class Daemon
        # Checks to see if the current process is the child process and if not
        # will update the pid file with the child pid.
        def self.start pid, pidfile, outfile, errfile
          unless pid.nil?
            raise "Fork failed" if pid == -1
            write pid, pidfile #for kill we need a pidfile
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


  end
end
