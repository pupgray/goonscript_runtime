# frozen_string_literal: true

module Goonscript
  class Intent < Struct.new(type:, meta:)
    TYPES = %i[type]
  end

  Handler = Struct.new(intent:, proc:)

  class Script
    def initialize(&body)
      @dsl = DSL.new
      @body = body
    end

    def call(agent)
      @dsl.as(agent, &@body)
    end
  end

  class DSL
    attr_accessor :agent

    def initialize
      @agent = nil
      @handlers = {}
    end

    def as(agent, &block)
      @agent = agent
      instance_eval &block
      @agent = nil
    end

    # -- methods for use in goonscripts --
    private

    Intent::TYPES.each do |intent_type|
      define_method intent_type { |*meta| Intent.new(type: intent_type, meta:) }
    end

    def they(intent, &block)
      @handlers << Handler.new(intent:, proc:)
    end

    def replace(value)
      value.length.times { @agent.press_key '<BS>' }
      value.each_char { |char| @agent.press_key char }
    end
  end
end
