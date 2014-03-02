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
          delayed_loads = Array.new

          if !arg[:delayed].nil?
            raise ArgumentError, "Delayed items must be in an "+\
            "Array! Example:\n:delayed => ['abc']" if arg[:delayed].class != Array
          end

          if !arg[:excluded].nil?
            raise ArgumentError, "Exclude items must be in an "+\
            "Array! Example:\n:exclude => ['abc']" if arg[:excluded].class != Array
          end

          arg[:type]= "rb"      if arg[:type].nil?
          arg[:monkey_patch]= 0 if arg[:monkey_patch].nil?

          #=============================================================================================================

          ### GET Pre path + validation
          begin
            #get method callers path

            pre_path = caller[arg[:monkey_patch].to_i].split('.rb:').first+('.rb')

            if !pre_path.include?('/') && !pre_path.include?('\\')
              pre_path = File.expand_path(pre_path)
            end

            separator_symbol= String.new
            pre_path.include?('/') ? separator_symbol = '/' : separator_symbol = '\\'

            pre_path= ((pre_path.split(separator_symbol))-([pre_path.split(separator_symbol).pop])).join(separator_symbol)

          end

          puts "prepath: "+pre_path.inspect if $DEBUG

          puts "LOADING_FILES_FROM_"+directory.to_s.split(separator_symbol).last.split('.').first.capitalize if $DEBUG

          puts "Elements found in #{directory}"                                                 if $DEBUG
          puts File.join("#{pre_path}","#{directory}","**","*.#{arg[:type]}")                   if $DEBUG
          puts Dir[File.join("#{pre_path}","#{directory}","**","*.#{arg[:type]}")].sort.inspect if $DEBUG

          Dir[File.join("#{pre_path}","#{directory}","**","*.#{arg[:type]}")].sort.each do |file|

            arg[:delayed]=  [nil] if arg[:delayed].nil?
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
          puts "DONE_LOAD_FILES_FROM_"+directory.to_s.split(separator_symbol).last.split('.').first.capitalize if $DEBUG

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

        def load_ymls(directory,*args)
          arg= Hash[*args]

          require 'yaml'
          #require "hashie"

          arg[:monkey_patch]= 0 if arg[:monkey_patch].nil?


          ### GET Pre path + validation
          begin
            #get method callers path
            pre_path = caller[arg[:monkey_patch].to_i].split('.rb:').first+('.rb')
            if !pre_path.include?('/') && !pre_path.include?('\\')
              pre_path = File.expand_path(pre_path)
            end
            separator_symbol= String.new
            pre_path.include?('/') ? separator_symbol = '/' : separator_symbol = '\\'
            pre_path= ((pre_path.split(separator_symbol))-([pre_path.split(separator_symbol).pop])).join(separator_symbol)
          end

          puts "Elements found in #{directory}"                                       if $DEBUG
          puts File.join("#{pre_path}","#{directory}","**","*.yml")                   if $DEBUG
          puts Dir[File.join("#{pre_path}","#{directory}","**","*.yml")].sort.inspect if $DEBUG

          yaml_files = Dir[File.join("#{pre_path}","#{directory}","**","*.yml")].sort

          puts "\nyaml file found: "+yaml_files.inspect                               if $DEBUG

          @result_hash = {}
          yaml_files.each_with_index do |full_path_file_name|


            file_name = full_path_file_name.split(separator_symbol).last.split(separator_symbol).first

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


  end
end
