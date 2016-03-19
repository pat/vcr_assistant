class VCRAssistant::Cassette
  def self.call(example, label = :default, &block)
    new(example, label, &block).call
  end

  def initialize(example, label, &block)
    @example, @label, @block = example, label, block
  end

  def call
    VCR.use_cassette(file_name) do |vcr_cassette|
      assistant = VCRAssistant.assistant.call label, vcr_cassette

      assistant.setup    if assistant.respond_to?(:setup)
      block.call assistant
      assistant.teardown if assistant.respond_to?(:teardown)
    end
  end

  private

  attr_reader :example, :label, :block

  def file_name
    VCRAssistant.namer.call example
  end
end
