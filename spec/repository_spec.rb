require 'spec_helper'
require 'rail_grinder/repository'

describe RailGrinder::Repository do
  describe 'inferred_name' do
    it 'finds a name in a gitlab repo url' do
      expect(RailGrinder.
             inferred_name('git@gitlab.com:lycoperdon/rails_app_4-2-0.git')).
             to eq('rails_app_4-2-0')
    end

    it 'finds a name in a repo url without a .git suffix' do
      expect(RailGrinder.inferred_name('https://example.com/some/repo/secret-sauce')).
             to eq('secret-sauce')
    end
  end
end
