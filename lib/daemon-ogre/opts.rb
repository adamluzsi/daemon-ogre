require 'tmp'
require 'configer'
module DaemonOgre

  module OPTS

    extend self

    def tmp_folder_path(obj= nil)
      @path ||= nil
      @path = obj unless obj.nil?
      @path || __temp__.tmpdir
    end


    def pid
      pid_number = nil
      __temp__.open('pid','r+'){|f| pid_number = f.read.chomp }
      return pid_number
    end

    def pidfile=(pid_number)
      __temp__.open('pid','w'){|f| f.write(pid_number.to_s) }
    end


    def out__path__
      __temp__.path_for('out')
    end

    def err__path__
      __temp__.path_for('err')
    end

    private

    def __temp__
      @__temp__ ||= __get_temp_dir
    end

    def __get_temp_dir
      require 'tmpdir'
      temp_folder = File.join(::Dir.tmpdir.to_s, "#{__project_name__}_daemon")
      Dir.mkdir(temp_folder) unless File.exist?(temp_folder)
      TMP.new(temp_folder)
    end

    def __project_name__
      ::Configer.pwd.split(File::Separator)[-1]
    end

  end
end