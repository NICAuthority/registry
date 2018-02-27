require 'rails_helper'

RSpec.describe 'EPP contact:create' do
  let(:registrar) { create(:registrar) }
  let(:user) { create(:api_user_epp, registrar: registrar) }
  let(:session_id) { create(:epp_session, user: user).session_id }
  let(:request_xml_with_address) { '<?xml version="1.0" encoding="UTF-8" standalone="no"?>
    <epp xmlns="https://epp.tld.ee/schema/epp-ee-1.0.xsd">
      <command>
        <create>
          <contact:create xmlns:contact="https://epp.tld.ee/schema/contact-ee-1.1.xsd">
            <contact:postalInfo>
              <contact:name>test name</contact:name>
              <contact:addr>
                <contact:street>test street</contact:street>
                <contact:city>test city</contact:city>
                <contact:pc>12345</contact:pc>
                <contact:cc>US</contact:cc>
              </contact:addr>
            </contact:postalInfo>
            <contact:voice>+372.1234567</contact:voice>
            <contact:email>test@example.com</contact:email>
          </contact:create>
        </create>
        <extension>
          <eis:extdata xmlns:eis="https://epp.tld.ee/schema/eis-1.0.xsd">
            <eis:ident type="priv" cc="DE">1234567</eis:ident>
            <eis:legalDocument type="pdf">dGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCg
            </eis:legalDocument>
          </eis:extdata>
        </extension>
        <clTRID>ABC-12345</clTRID>
      </command>
    </epp>'
  }
  subject(:response_xml) { Nokogiri::XML(response.body) }
  subject(:response_code) { response_xml.xpath('//xmlns:result').first['code'] }
  subject(:response_description) { response_xml.css('result msg').text }
  subject(:address_saved) { Contact.last.attributes.slice(*Contact.address_attribute_names).compact.any? }

  before do
    login_as user
  end

  context 'when address processing is enabled' do
    before do
      allow(Contact).to receive(:address_processing?).and_return(true)
    end

    context 'with address' do
      it 'returns epp code of 1000' do
        post '/epp/command/create', { frame: request_xml_with_address }, 'HTTP_COOKIE' => "session=#{session_id}"
        expect(response_code).to eq('1000')
      end

      it 'returns epp description' do
        post '/epp/command/create', { frame: request_xml_with_address}, 'HTTP_COOKIE' => "session=#{session_id}"
        expect(response_description).to eq('Command completed successfully')
      end

      it 'saves address' do
        post '/epp/command/create', { frame: request_xml_with_address }, 'HTTP_COOKIE' => "session=#{session_id}"
        expect(address_saved).to be_truthy
      end
    end
  end

  context 'when address processing is disabled' do
    before do
      allow(Contact).to receive(:address_processing?).and_return(false)
    end

    context 'with address' do
      it 'returns epp code of 1100' do
        post '/epp/command/create', { frame: request_xml_with_address }, 'HTTP_COOKIE' => "session=#{session_id}"
        expect(response_code).to eq('1100')
      end

      it 'returns epp description' do
        post '/epp/command/create', { frame: request_xml_with_address }, 'HTTP_COOKIE' => "session=#{session_id}"
        expect(response_description).to eq('Command completed successfully; Postal address data discarded')
      end

      it 'does not save address' do
        post '/epp/command/create', { frame: request_xml_with_address }, 'HTTP_COOKIE' => "session=#{session_id}"
        expect(address_saved).to be_falsey
      end
    end

    context 'without address' do
      let(:request_xml_without_address) { '<?xml version="1.0" encoding="UTF-8" standalone="no"?>
        <epp xmlns="https://epp.tld.ee/schema/epp-ee-1.0.xsd">
          <command>
            <create>
              <contact:create xmlns:contact="https://epp.tld.ee/schema/contact-ee-1.1.xsd">
                <contact:postalInfo>
                  <contact:name>test name</contact:name>
                </contact:postalInfo>
                <contact:voice>+372.1234567</contact:voice>
                <contact:email>test@test.com</contact:email>
              </contact:create>
            </create>
            <extension>
              <eis:extdata xmlns:eis="https://epp.tld.ee/schema/eis-1.0.xsd">
                <eis:ident type="priv" cc="DE">123456</eis:ident>
                <eis:legalDocument type="pdf"> dGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCgdGVzdCBmYWlsCg
                </eis:legalDocument>
              </eis:extdata>
            </extension>
            <clTRID>ABC-12345</clTRID>
          </command>
        </epp>'
      }

      it 'returns epp code of 1000' do
        post '/epp/command/create', { frame: request_xml_without_address }, 'HTTP_COOKIE' => "session=#{session_id}"
        expect(response_code).to eq('1000')
      end

      it 'returns epp description' do
        post '/epp/command/create', { frame: request_xml_without_address }, 'HTTP_COOKIE' => "session=#{session_id}"
        expect(response_description).to eq('Command completed successfully')
      end
    end
  end
end
