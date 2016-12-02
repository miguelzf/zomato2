module Zomato2
  class Menu < EntityBase

    attr_reader :daily_menu_id, :name, :start_date, :end_date, :dishes

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

