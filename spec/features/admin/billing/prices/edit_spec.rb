require 'rails_helper'

RSpec.feature 'Editing price in admin area', settings: false do
  given!(:price) { create(:effective_price) }

  background do
    sign_in_to_admin_area
  end

  scenario 'updates price' do
    visit admin_prices_path
    open_form
    submit_form

    expect(page).to have_text(t('admin.billing.prices.update.updated'))
  end

  def open_form
    find('.edit-price-btn').click
  end

  def submit_form
    click_link_or_button t('admin.billing.prices.form.update_btn')
  end
end
