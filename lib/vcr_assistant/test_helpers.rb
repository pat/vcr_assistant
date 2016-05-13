module VCRAssistant::TestHelpers
  def assisted_cassette(example, label = :default, options = {}, &block)
    VCRAssistant::Cassette.call example, label, options, &block
  end
end
