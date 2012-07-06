class Bsm::Model::Coders::JsonColumn < Bsm::Model::Coders::AbstractColumn

  def self.rescue_errors
    [ MultiJson::DecodeError ]
  end

  def dump(obj)
    ActiveSupport::JSON.encode(obj)
  end

  protected

    def _load(string)
      ActiveSupport::JSON.decode(string)
    end

end
