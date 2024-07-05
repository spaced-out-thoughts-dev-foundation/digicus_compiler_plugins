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
  end
end
