class Bsm::Model::Coders::AbstractColumn

  def self.rescue_errors
    []
  end

  # @attr_reader [Class] object_class
  attr_reader :object_class

  # @param [Class] obejct_class
  def initialize(object_class = Object)
    @object_class = object_class
  end

  def dump(obj)
    not_implemented
  end

  def load(string)
    return object_class.new if object_class != Object && string.nil?
    begin
      obj = _load(string) unless string.nil?

      unless obj.is_a?(object_class) || obj.nil?
        raise ActiveRecord::SerializationTypeMismatch,
          "Attribute was supposed to be a #{object_class}, but was a #{obj.class}"
      end
      obj ||= object_class.new if object_class != Object

      obj
    rescue *self.class.rescue_errors
      object_class == Object ? string : object_class.new
    end
  end

  protected

    def _load(string)
      not_implemented
    end

end
