require 'spec_helper'

describe VCRAssistant do
  let(:vcr_cassette) { double 'VCR Cassette' }
  let(:assistant)    { double 'Assistant' }

  before :each do
    allow(VCR).to receive(:use_cassette).and_yield(vcr_cassette)
  end

  after :each do
    VCRAssistant.assistant = VCRAssistant::Assistant
  end

  it 'calls the block with a context object' do |example|
    called = false

    assisted_cassette(example) do |assistant|
      called = true
      expect(assistant.label).to eq(:default)
      expect(assistant.vcr_cassette).to eq(vcr_cassette)
    end

    expect(called).to eq(true)
  end

  it 'automatically names the VCR cassette' do |example|
    expect(VCR).to receive(:use_cassette).with(
      'vcr_assistant/automatically_names_the_vcr_cassette', {}
    )

    assisted_cassette(example) { |assistant| }
  end

  it 'accepts options for the cassette' do |example|
    expect(VCR).to receive(:use_cassette).with(
      'vcr_assistant/accepts_options_for_the_cassette', :setting => true
    )

    assisted_cassette(example, :default, :setting => true) { |assistant| }
  end

  it 'accepts options without a label' do |example|
    expect(VCR).to receive(:use_cassette).with(
      'vcr_assistant/accepts_options_without_a_label', :setting => true
    )

    assisted_cassette(example, :setting => true) { |assistant| }
  end

  it 'can fire a setup block' do |example|
    VCRAssistant.assistant = lambda { |example, label| assistant }

    expect(assistant).to receive(:setup)

    assisted_cassette(example) { |assistant| }
  end

  it 'can fire a teardown block' do |example|
    VCRAssistant.assistant = lambda { |example, label| assistant }

    expect(assistant).to receive(:teardown)

    assisted_cassette(example) { |assistant| }
  end
end
