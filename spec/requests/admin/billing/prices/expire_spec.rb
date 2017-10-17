require 'rails_helper'

RSpec.describe 'admin price expire', settings: false do
  before do
    login_as create(:admin_user)
  end

  it 'expires price' do
    price = create(:effective_price)

    expect { patch expire_admin_price_path(price); price.reload }
        .to change { price.expired? }.from(false).to(true)
  end

  it 'redirects to :index' do
    price = create(:effective_price)

    patch expire_admin_price_path(price)

    expect(response).to redirect_to admin_prices_url
  end
end
