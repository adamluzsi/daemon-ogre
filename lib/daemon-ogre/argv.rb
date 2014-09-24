module DaemonOgre

  module DARGV
    class << self

      def check_args_for( *args )
        args = args.map(&:to_s)
        return ARGV.options.any?{|opt| args.include?(opt) }
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

      ARGV.add_help(
          [
              'Start with one of the following tags the app,',
              'and it will be daemonized'
          ].join(' '),
          *@@daemon_keys.map(&:to_s)

      )

      ARGV.add_help(
          [
              'Start with one of the following tags the app,',
              'and it will be terminate the running app instance'
          ].join(' '),
          *@@terminate_keys.map(&:to_s)
      )

    end
  end

end

