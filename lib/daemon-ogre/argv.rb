module DaemonOgre

  module DARGV
    class << self

      def daemonize?

        ::ARGV.flag_syms.each do |element|
          if [:d,:daemon,:daemonize].include?(element)
            return true
          end
        end
        return false

      end
      alias :daemon? :daemonize?

    end
  end

end