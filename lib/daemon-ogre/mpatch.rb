#monkey patch
begin
  def process_running?(input)
    DaemonOgre.process_running?(input)
  end
  def require_directory(directory,*args)
    DaemonOgre.load_directory(directory,{:monkey_patch => 1},*args)
  end
  def require_ymls(directory)
    DaemonOgre.load_ymls(
        directory,
        {:monkey_patch => 1}
    )
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