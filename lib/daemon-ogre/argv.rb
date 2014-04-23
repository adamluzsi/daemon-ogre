module DaemonOgre

  module DARGV
    class << self

      def check_args_for *args

        ::ARGV.flag_syms.each do |element|
          if args.include?(element)
            return true
          end
        end
        return false

      end

      def daemonize?
        check_args_for( *[:d,:daemon,:daemonize])
      end
      alias :daemon? :daemonize?

      def terminate?
        check_args_for( *[:k,:kill,:terminate])
      end

    end
  end

end