class VCRAssistant::Assistant
  attr_reader :label, :vcr_cassette

  def self.call(label, vcr_cassette)
    new label, vcr_cassette
  end

  def initialize(label, vcr_cassette)
    @label, @vcr_cassette = label, vcr_cassette
  end
end
