module DaemonOgre

  module DARGV
    class << self

      def check_args_for( *args )
        args = args.map(&:to_s)
        return ::ARGV.any?{|argument| args.any?{|string_to_find| argument =~ Regexp.new(string_to_find.to_s)  }}
      end

      @@daemon_keys= [:daemonize,:daemon,:d]
      def daemonize?
        check_args_for( *@@daemon_keys )
      end
      alias :daemon? :daemonize?

      @@terminate_keys= [:terminate,:kill,:k]
      def terminate?
        check_args_for( *@@terminate_keys )
      end

    end
  end

end

