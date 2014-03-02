#DaemonOgreBody
begin
  module DaemonOgre

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

  end
end