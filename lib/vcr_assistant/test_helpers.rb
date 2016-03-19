module VCRAssistant::TestHelpers
  def assisted_cassette(example, &block)
    VCRAssistant::Cassette.call example, &block
  end
end
