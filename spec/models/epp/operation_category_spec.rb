require 'rails_helper'

RSpec.describe EPP::OperationCategory, db: false do
  describe '::all' do
    specify { expect(described_class.all).to eq(%w[create renew transfer update delete]) }
  end
end
