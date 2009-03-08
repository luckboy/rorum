module RorumMisc
  protected
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def var_loader(*vars)
      vars.each do |var_name|
        model_name=var_name.to_s[0].chr.upcase+var_name.to_s[1..-1]
        self.class_eval %{
          def load_#{var_name}()
            @#{var_name} = #{model_name}.find(params[:#{var_name}_id])
          end
        }
      end
    end

    def bits_accessor(attr_name, bit_names)
      bit_names.each do |bit_name, bit|
        self.class_eval %{
          def #{attr_name}_#{bit_name}()
            self.#{attr_name}&(1 << #{bit}) != 0
          end

          def #{attr_name}_#{bit_name}=(b)
            b = ["true", "t", "1"].include? b.to_s.downcase unless b == true || b == false
            self.#{attr_name} = 0 if self.#{attr_name}.nil?
            self.#{attr_name} = (self.#{attr_name}&~(1 << #{bit}))|((b ? 1 : 0) << #{bit})
            b
          end
        }
      end
    end

    def rights_accessor(*attrs)
      attrs.each do |attr_name|
        bits_accessor attr_name, RIGHTS
      end
    end

    def rights_accessible(*attrs)
      attrs.each { |attr_name| RIGHTS.keys.map { |name| attr_accessible "#{attr_name}_#{name}" } }
    end
  end

  RIGHTS = { :create => 0, :update => 1, :delete => 2 }
  LANGUAGES = { "English" => "en", "Polski" => "pl" }

  protected
  def render_not_found()
    render :file => "public/404.html", :status => 404
  end

end
