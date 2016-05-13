class VCRAssistant::Cassette
  def self.call(example, label = :default, options = {}, &block)
    new(example, label, options, &block).call
  end

  def initialize(example, label, options = {}, &block)
    @example, @label, @options, @block = example, label, options, block
    @label, @options = :default, label if label.is_a?(Hash)
  end

  def call
    VCR.use_cassette(file_name, options) do |vcr_cassette|
      assistant = VCRAssistant.assistant.call label, vcr_cassette

      assistant.setup    if assistant.respond_to?(:setup)
      block.call assistant
      assistant.teardown if assistant.respond_to?(:teardown)
    end
  end

  private

  attr_reader :example, :label, :options, :block

  def file_name
    VCRAssistant.namer.call example
  end
end
