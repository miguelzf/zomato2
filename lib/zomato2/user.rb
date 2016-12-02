module Zomato2
  class User < EntityBase

    attr_reader :zomato_handle, :foodie_level, :foodie_level_num, :foodie_color,
                :name, :profile_url, :profile_deeplink, :profile_image

    def initialize(zom_conn, attributes)
      super(zom_conn)
      self.instance_variables.each do |att|
        if att === :@zom_conn
          next
        else
          self.instance_variable_set attributes[att]
        end
      end
    end

    def to_s; super; end

  end
end
