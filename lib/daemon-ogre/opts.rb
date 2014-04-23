module DaemonOgre

  module OPTS
    class << self

      def tmp_folder_path obj= nil
        @@path= obj unless obj.nil?
        @@path || "#{::TMP.folder_path.to_s}_daemon"
      end

      def method_missing method_name, *args
        @@tmp_dsl ||= ::TMP.new( self.tmp_folder_path )

        if method_name.to_s.reverse[0] == "="
          @@tmp_dsl.__send__ method_name,args[0]
        else
          @@tmp_dsl.__send__ method_name
        end

      end

    end
  end

end