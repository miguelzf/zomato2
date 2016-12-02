module Zomato2
  class EntityBase

    def initialize(zomato_conn)
      @zom_conn = zomato_conn
    end

    def get(endpoint, params)
      @zom_conn.get(endpoint, params)
    end

    def to_s
      #self.inspect
      vals = self.instance_variables.map do |att|
         next nil if att === :@zom_conn
         attstr = att.to_s.sub('@','')
         attstr+": #{self.instance_variable_get(att)}"
      end

      classname = self.class.name.sub(/.*:/,'')
      fields = vals.compact.join ', '
      "#{classname}: { #{fields} }"
    end
  end

end
