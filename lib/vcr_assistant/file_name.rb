class VCRAssistant::FileName
  def self.call(example)
    new(example).call
  end

  def initialize(example)
    @example = example
  end

  def call
    "#{folder}/#{file}"
  end

  private

  attr_reader :example

  def file
    example.metadata[:full_description].downcase.gsub(/\s+/, '_').gsub(/[\W]+/, '')
  end

  def folder
    File.basename example.metadata[:file_path], '_spec.rb'
  end
end
