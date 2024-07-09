# frozen_string_literal: true

require 'dtr_core'
require 'json'

module DigicusWebBackend
  # This is a simple compiler class that takes a DTR code and transpiles it to JSON.
  class Compiler
    attr_reader :contract

    def initialize(dtr_code)
      start = Time.now
      @contract = DTRCore::Contract.from_dtr_raw(dtr_code)
      puts "[COMPILE]: { name: digicus_web_backend, type: backend, time: #{Time.now - start}, phase: 'Contract-from-dtr-raw' }"
    end

    def self.from_dtr(dtr_code)
      new(dtr_code).from_dtr
    end

    def from_dtr
      start = Time.now
      result = {
        contract_name:,
        contract_state:,
        contract_interface:,
        contract_user_defined_types:

      }

      puts "[COMPILE]: { name: digicus_web_backend, type: backend, time: #{Time.now - start}, phase: 'Contract-to-json' }"

      result.to_json
    end

    private

    def contract_name
      contract.name
    end

    def contract_state
      contract.state&.map do |s|
        {
          name: s.name,
          type: s.type,
          initial_value: s.initial_value
        }.to_json
      end
    end

    def contract_interface
      contract.interface&.map do |f|
        {
          name: f.name,
          instructions: f.instructions.map(&:to_json),
          inputs: f&.inputs,
          output: f&.output
        }.to_json
      end
    end

    def contract_user_defined_types
      contract.user_defined_types&.map do |t|
        {
          name: t.name,
          attributes: t.attributes
        }.to_json
      end
    end
  end
end
