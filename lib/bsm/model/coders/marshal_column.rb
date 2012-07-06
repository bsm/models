class Bsm::Model::Coders::MarshalColumn < Bsm::Model::Coders::AbstractColumn

  def self.rescue_errors
    [ ArgumentError, TypeError ]
  end

  def dump(obj)
    Base64.encode64 Marshal.dump(obj)
  end

  protected

    def _load(string)
      Marshal.load(Base64.decode64(string))
    end

end
