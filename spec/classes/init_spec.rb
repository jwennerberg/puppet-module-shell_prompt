require 'spec_helper'
describe 'shell_prompt' do

  context 'with default options' do
    it {
      should include_class('shell_prompt')
    }
  end
end
