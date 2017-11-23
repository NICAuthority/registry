require 'test_helper'

class ShowRegistrarTest < ActionDispatch::IntegrationTest
  include ActionView::Helpers::NumberHelper

  def setup
    login_as users(:admin)
    @registrar = registrars(:complete)
    visit admin_registrar_path(@registrar)
  end

  def test_accounting_customer_code
    assert_text 'ACCOUNT001'
  end
end
