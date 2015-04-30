require 'rails_helper'

feature 'Setting management', type: :feature do
  let(:user) { Fabricate(:admin_user, username: 'user1', identity_code: '37810013087') }

  scenario 'User changes a setting' do
    sign_in user
    visit admin_settings_path
    val_min = find_field('_settings_ns_min_count').value
    val_max = find_field('_settings_ns_max_count').value

    expect(val_min).to eq('2')
    expect(val_max).to eq('11')

    fill_in '_settings_ns_min_count', with: 0
    fill_in '_settings_ns_max_count', with: 10

    click_button 'Save'

    val_min = find_field('_settings_ns_min_count').value
    val_max = find_field('_settings_ns_max_count').value

    expect(val_min).to eq('0')
    expect(val_max).to eq('10')
  end
end
