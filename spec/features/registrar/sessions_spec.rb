require 'rails_helper'

feature 'Sessions', type: :feature do
  before :all do
    create_settings
    Fabricate(:api_user)
  end

  scenario 'Api user should not get in when external service fails' do
    client = instance_double("Digidoc::Client")
    allow(client).to receive(:authenticate).and_return(
      OpenStruct.new(
        faultcode: 'Fault',
        detail: OpenStruct.new(
          message: 'Something is wrong'
        )
      )
    )

    allow(Digidoc::Client).to receive(:new) { client }

    visit registrar_login_path
    page.should have_css('a[href="/registrar/login/mid"]')

    page.find('a[href="/registrar/login/mid"]').click

    fill_in 'user_phone', with: '00007'
    click_button 'Log in'
    page.should have_text('Something is wrong')
  end

  scenario 'Api user should not get in when there is not such user' do
    client = instance_double("Digidoc::Client")
    allow(client).to receive(:authenticate).and_return(
      OpenStruct.new(
        user_id_code: '123'
      )
    )

    allow(Digidoc::Client).to receive(:new) { client }

    visit registrar_login_path
    page.should have_css('a[href="/registrar/login/mid"]')

    page.find('a[href="/registrar/login/mid"]').click

    fill_in 'user_phone', with: '00007'
    click_button 'Log in'
    page.should have_text('No such user')
  end

  scenario 'Api user should when there is a sim error', js: true do
    client = instance_double("Digidoc::Client", session_code: '123')

    allow(client).to receive('session_code=')

    allow(client).to receive(:authenticate).and_return(
      OpenStruct.new(
        user_id_code: '14212128025'
      )
    )

    allow(client).to receive('authentication_status').and_return(
      OpenStruct.new(status: 'SIM_ERROR')
    )

    allow(Digidoc::Client).to receive(:new) { client }

    visit registrar_login_path
    page.should have_css('a[href="/registrar/login/mid"]')

    page.find('a[href="/registrar/login/mid"]').click

    fill_in 'user_phone', with: '00007'
    click_button 'Log in'

    page.should have_text('Check your phone for confirmation code')
    page.should have_text('SIM application error')
  end

  scenario 'Api user should log in', js: true do
    client = instance_double("Digidoc::Client", session_code: '123')

    allow(client).to receive('session_code=')

    allow(client).to receive(:authenticate).and_return(
      OpenStruct.new(
        user_id_code: '14212128025'
      )
    )

    allow(client).to receive('authentication_status').and_return(
      OpenStruct.new(status: 'USER_AUTHENTICATED')
    )

    allow(Digidoc::Client).to receive(:new) { client }

    visit registrar_login_path
    page.should have_css('a[href="/registrar/login/mid"]')

    page.find('a[href="/registrar/login/mid"]').click

    fill_in 'user_phone', with: '00007'
    click_button 'Log in'

    page.should have_text('Check your phone for confirmation code')
    page.should have_text('Welcome!')
  end
end