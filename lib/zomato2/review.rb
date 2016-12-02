module Zomato2
  class Review < EntityBase

    attr_reader :id, :rating, :review_text, :rating_color, :review_time_friendly,
                :rating_text, :timestamp, :likes, :comments_count, :user

    def initialize(zom_conn, attributes)
      super(zom_conn)

      self.instance_variables.each do |att|
        if att === :@zom_conn
          next
        elsif att === :@user
          @user = User.new zom_conn, attributes['user']
        else
          self.instance_variable_set attributes[att]
        end
      end
    end

    def to_s; super; end

  end
end
