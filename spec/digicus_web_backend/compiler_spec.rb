# frozen_string_literal: true

require './spec/spec_helper'

RSpec.describe DigicusWebBackend::Compiler do
  describe '#from_dtr' do
    it 'returns JSON' do
      dtr_code = '[Contract]: Foo'
      compiler = described_class.new(dtr_code)
      expect(compiler.from_dtr).to eq(
        {
          contract_name: 'Foo',
          contract_state: nil,
          contract_interface: nil,
          contract_user_defined_types: nil
        }.to_json
      )
    end

    context 'when hello world contract' do
      let(:dtr_code) do
        <<~DTR
          [Contract]: HelloWorld

          [Interface]:
          -() [hello]
            * Inputs:
              {
                env: Env
                to: String
              }
              * Output: List<String>
              * Instructions:
                $
                  { id: 0, instruction: instantiate_object, input: (List, env, String, from_str, env, "Hello", to), assign: Thing_to_return, scope: 0 }
                  { id: 1, instruction: return, input: (Thing_to_return), scope: 0 }
                $
            :[Interface]
        DTR
      end

      let(:expected_json) do
        {
          contract_name: 'HelloWorld',
          contract_state: [],
          contract_interface: [
            {
              name: 'hello',
              inputs: [
                { name: 'env', type_name: 'Env' },
                { name: 'to', type_name: 'String' }
              ],
              output: 'List<String>',
              instructions: [
                { id: 0, instruction: 'instantiate_object',
                  inputs: %w[List env String from_str env "Hello" to], assign: 'Thing_to_return', scope: 0 }.to_json,
                { id: 1, instruction: 'return', inputs: ['Thing_to_return'], scope: 0 }.to_json
              ]
            }.to_json
          ],
          contract_user_defined_types: nil,
          contract_helpers: nil
        }.to_json
      end

      it 'returns JSON' do
        compiler = described_class.new(dtr_code)

        actual_json = compiler.from_dtr

        expect(actual_json['contract_name']).to eq(expected_json['contract_name'])
        expect(actual_json['contract_state']).to eq(expected_json['contract_state'])
        expect(actual_json['contract_interface']).to eq(expected_json['contract_interface'])
        expect(actual_json['contract_user_defined_types']).to eq(expected_json['contract_user_defined_types'])
      end
    end
  end
end
