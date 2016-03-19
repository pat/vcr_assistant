require 'vcr'

module VCRAssistant
  def self.assistant
    @assistant ||= VCRAssistant::Assistant
  end

  def self.assistant=(assistant)
    @assistant = assistant
  end

  def self.namer
    @namer ||= VCRAssistant::FileName
  end

  def self.namer=(namer)
    @namer = namer
  end
end

require 'vcr_assistant/assistant'
require 'vcr_assistant/cassette'
require 'vcr_assistant/file_name'
require 'vcr_assistant/test_helpers'
