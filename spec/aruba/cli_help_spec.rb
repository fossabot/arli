# frozen_string_literal: true

require 'aruba_helper'

RSpec.describe 'command help', type: :aruba do
  let(:command) { "exe/arli #{args} -C " }
  let(:output) { last_command_started.stdout.chomp }

  before { run_command_and_stop command }

  context 'help' do
    let(:args) { '-h' }
    it 'should print help' do
      expect(output).to match(/Arli/)
    end
  end

  context 'search help' do
    let(:args) { 'search -h' }
    it 'should print search helps' do
      expect(output).to match /search-expression/
    end
  end
end
