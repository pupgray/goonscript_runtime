# frozen_string_literal: true

require 'dsl'
require 'agent'

RSpec.describe Goonscript::Script do
  before do
    agent = Goonscript::MockAgent.new
    allow(agent).to receive(:type)
  end

  it 'should define a basic text replacement' do
    script = subject.new do
      they type "horse" do
        replace "Horse"
      end
    end

    agent.obey script

    agent.react_to Goonscript::Event.new(type: :key_press, value: 'h')
    agent.react_to Goonscript::Event.new(type: :key_press, value: 'o')
    agent.react_to Goonscript::Event.new(type: :key_press, value: 'r')
    agent.react_to Goonscript::Event.new(type: :key_press, value: 's')
    agent.react_to Goonscript::Event.new(type: :key_press, value: 'e')

    expect(agent).to have_received(:type).with("Horse")
  end
end
