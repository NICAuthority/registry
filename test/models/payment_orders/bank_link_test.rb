require 'test_helper'

class BankLinkTest < ActiveSupport::TestCase
  # Note: Files stored in: test/fixtures/files/seb_seller_key.pem
  #                        test/fixtures/files/seb_bank_cert.pem
  # are autogenerated, they will not work against production or even staging.
  def setup
    super

    @invoice = invoices(:for_payments_test)
    invoice_item = invoice_items(:one)

    @invoice.invoice_items << invoice_item
    @invoice.invoice_items << invoice_item

    travel_to '2018-04-01 00:30 +0300'
    create_new_bank_link
    create_completed_bank_link
    create_cancelled_bank_link
  end

  def teardown
    super

    travel_back
  end

  def create_completed_bank_link
    params = {
      'VK_SERVICE': '1111',
      'VK_VERSION': '008',
      'VK_SND_ID': 'testvpos',
      'VK_REC_ID': 'seb',
      'VK_STAMP': 1,
      'VK_T_NO': '1',
      'VK_AMOUNT': '12.00',
      'VK_CURR': 'EUR',
      'VK_REC_ACC': '1234',
      'VK_REC_NAME': 'Eesti Internet',
      'VK_SND_ACC': '1234',
      'VK_SND_NAME': 'John Doe',
      'VK_REF': '',
      'VK_MSG': 'Order nr 1',
      'VK_T_DATETIME': '2018-04-01T00:30:00+0300',
      'VK_MAC': 'CZZvcptkxfuOxRR88JmT4N+Lw6Hs4xiQfhBWzVYldAcRTQbcB/lPf9MbJzBE4e1/HuslQgkdCFt5g1xW2lJwrVDBQTtP6DAHfvxU3kkw7dbk0IcwhI4whUl68/QCwlXEQTAVDv1AFnGVxXZ40vbm/aLKafBYgrirB5SUe8+g9FE=',
      'VK_ENCODING': 'UTF-8',
      'VK_LANG': 'ENG'
    }.with_indifferent_access

    @completed_bank_link = PaymentOrders::BankLink.new(
      'seb', @invoice, { response: params }
    )
  end

  def create_cancelled_bank_link
    params = {
      'VK_SERVICE': '1911',
      'VK_VERSION': '008',
      'VK_SND_ID': 'testvpos',
      'VK_REC_ID': 'seb',
      'VK_STAMP': 1,
      'VK_REF': '',
      'VK_MSG': 'Order nr 1',
      'VK_MAC': 'PElE2mYXXN50q2UBvTuYU1rN0BmOQcbafPummDnWfNdm9qbaGQkGyOn0XaaFGlrdEcldXaHBbZKUS0HegIgjdDfl2NOk+wkLNNH0Iu38KzZaxHoW9ga7vqiyKHC8dcxkHiO9HsOnz77Sy/KpWCq6cz48bi3fcMgo+MUzBMauWoQ=',
      'VK_ENCODING': 'UTF-8',
      'VK_LANG': 'ENG'
    }.with_indifferent_access

    @cancelled_bank_link = PaymentOrders::BankLink.new(
      'seb', @invoice, { response: params }
    )
  end

  def create_new_bank_link
    params = { return_url: 'return.url', response_url: 'response.url' }
    @new_bank_link = PaymentOrders::BankLink.new('seb', @invoice, params)
  end

  def test_response_is_not_valid_when_it_is_missing
    refute(false, @new_bank_link.valid_response_from_intermediary?)
  end

  def test_form_fields
    expected_response = {
      'VK_SERVICE': '1012',
      'VK_VERSION': '008',
      'VK_SND_ID': 'testvpos',
      'VK_STAMP': 1,
      'VK_AMOUNT': '12.00',
      'VK_CURR': 'EUR',
      'VK_REF': '',
      'VK_MSG': 'Order nr. 1',
      'VK_RETURN': 'return.url',
      'VK_CANCEL': 'return.url',
      'VK_DATETIME': '2018-04-01T00:30:00+0300',
      'VK_MAC': 'q70UNFV4ih1qYij2+CyrHaApc3OE66igy3ijuR1m9dl0Cg+lIrAUsP47JChAF7PRErwZ78vSuZwrg0Vabhlp3WoC934ik2FiE04BBxUUTndONvguaNR1wvl0FiwfXFljLncX7TOmRraywJljKC5vTnIRNT2+1HXvmv0v576PGao=',
      'VK_ENCODING': 'UTF-8',
      'VK_LANG': 'ENG'
    }.with_indifferent_access

    assert_equal(expected_response, @new_bank_link.form_fields)
  end

  def test_valid_success_response_from_intermediary?
    assert(@completed_bank_link.valid_response_from_intermediary?)
  end

  def test_valid_cancellation_response_from_intermediary?
    assert(@cancelled_bank_link.valid_response_from_intermediary?)
  end

  def test_settled_payment?
    assert(@completed_bank_link.settled_payment?)
    refute(@cancelled_bank_link.settled_payment?)
  end

  def test_complete_transaction_calls_methods_on_transaction
    mock_transaction = MiniTest::Mock.new
    mock_transaction.expect(:sum= , '12.00', ['12.00'])
    mock_transaction.expect(:bank_reference= , '1', ['1'])
    mock_transaction.expect(:buyer_bank_code= , 'testvpos', ['testvpos'])
    mock_transaction.expect(:buyer_iban= , '1234', ['1234'])
    mock_transaction.expect(:paid_at= , Date.parse('2018-04-01 00:30:00 +0300'), [Time.parse('2018-04-01T00:30:00+0300')])
    mock_transaction.expect(:buyer_name=, 'John Doe', ['John Doe'])
    mock_transaction.expect(:save!, true)
    mock_transaction.expect(:autobind_invoice, AccountActivity.new)

    BankTransaction.stub(:find_by, mock_transaction) do
      @completed_bank_link.complete_transaction
    end

    mock_transaction.verify
  end
end