# Encoding: utf-8
require 'spec_helper'

RSpec.describe Packer::Provisioner::Powershell do
  let(:provisioner) do
    Packer::Provisioner.get_provisioner('powershell')
  end

  let(:some_string) do
    'some string'
  end

  let(:some_array_of_strings) do
    %w[command1 command2]
  end

  let(:some_array_of_ints) do
    [1, 2, 3]
  end

  describe '#initialize' do
    it 'has a type of powershell' do
      expect(provisioner.data['type']).to eq('powershell')
    end
  end

  describe '#inline' do
    it 'accepts an array of commands' do
      provisioner.inline(some_array_of_strings)
      expect(provisioner.data['inline']).to eq(some_array_of_strings)
      provisioner.data.delete('inline')
    end

    it 'converts all commands to strings' do
      provisioner.inline(some_array_of_ints)
      expect(provisioner.data['inline']).to eq(some_array_of_ints.map(&:to_s))
      provisioner.data.delete('inline')
    end

    it 'raises an error if the commands argument cannot be made an Array' do
      expect { provisioner.inline(some_string) }.to raise_error
    end

    it 'raises an error if #script or #scripts method was already called' do
      provisioner.data['script'] = 1
      expect { provisioner.inline(some_array_of_strings) }.to raise_error
      provisioner.data.delete('script')
      provisioner.data['scripts'] = 1
      expect { provisioner.inline(some_array_of_strings) }.to raise_error
      provisioner.data.delete('scripts')
    end
  end

  describe '#script' do
    it 'accepts a string' do
      provisioner.script(some_string)
      expect(provisioner.data['script']).to eq(some_string)
      provisioner.data.delete('script')
    end

    it 'converts any argument passed to a string' do
      provisioner.script(some_array_of_ints)
      expect(provisioner.data['script']).to eq(some_array_of_ints.to_s)
      provisioner.data.delete('script')
    end

    it 'raises an error if #inline or #scripts method was already called' do
      provisioner.data['inline'] = 1
      expect { provisioner.script(some_string) }.to raise_error
      provisioner.data.delete('inline')
      provisioner.data['scripts'] = 1
      expect { provisioner.script(some_string) }.to raise_error
      provisioner.data.delete('scripts')
    end
  end

  describe '#scripts' do
    it 'accepts an array of commands' do
      provisioner.scripts(some_array_of_strings)
      expect(provisioner.data['scripts']).to eq(some_array_of_strings)
      provisioner.data.delete('scripts')
    end

    it 'converts all commands to strings' do
      provisioner.scripts(some_array_of_ints)
      expect(provisioner.data['scripts']).to eq(some_array_of_ints.map(&:to_s))
      provisioner.data.delete('scripts')
    end

    it 'raises an error if the commands argument cannot be made an Array' do
      expect { provisioner.scripts(some_string) }.to raise_error
    end

    it 'raises an error if #inline or #script method was already called' do
      provisioner.data['script'] = 1
      expect { provisioner.scripts(some_array_of_strings) }.to raise_error
      provisioner.data.delete('scripts')
      provisioner.data['inline'] = 1
      expect { provisioner.scripts(some_array_of_strings) }.to raise_error
      provisioner.data.delete('scripts')
    end
  end

  describe '#valid_exit_codes' do
    it 'accepts an array of exit codes' do
      provisioner.valid_exit_codes(some_array_of_ints)
      expect(provisioner.data['valid_exit_codes']).to eq(some_array_of_ints)
      provisioner.data.delete('valid_exit_codes')
    end
  end

  describe '#validate' do
    it 'raises an error if elevated_user is defined and elevated_password is not' do
      provisioner.inline [some_string]
      provisioner.elevated_user some_string
      expect { provisioner.validate }.to raise_error Packer::DataObject::DataValidationError
    end

    it 'completes with no elevated_user or elevated_password' do
      provisioner.inline [some_string]
      expect(provisioner.validate).to be true
    end
  end
end
