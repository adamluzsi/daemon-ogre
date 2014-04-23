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

      @@daemon_keys= [:daemonize,:daemon,:d]
      def daemonize?
        check_args_for( *@@daemon_keys )
      end
      alias :daemon? :daemonize?

      @@terminate_keys= [:terminate,:kill,:k]
      def terminate?
        check_args_for( *@@terminate_keys )
      end

      ::ARGVEXT.add_help_msg(
          "Start with one of the following tags the app, and it will be daemonized",
          *@@daemon_keys
      )

      ::ARGVEXT.add_help_msg(
          "Start with one of the following tags the app, and it will be terminate the running app instance",
          *@@terminate_keys
      )


    end
  end

end

