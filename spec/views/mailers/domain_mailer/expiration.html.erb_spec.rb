require 'rails_helper'

RSpec.describe 'mailers/domain_mailer/expiration.html.erb' do
  let(:domain) { instance_spy(DomainPresenter) }
  let(:lang_count) { 3 }

  before :example do
    assign(:domain, domain)
    assign(:registrar, nil)
    stub_template 'mailers/domain_mailer/registrar/_registrar.et.html' => 'test registrar estonian'
    stub_template 'mailers/domain_mailer/registrar/_registrar.en.html' => 'test registrar english'
    stub_template 'mailers/domain_mailer/registrar/_registrar.ru.html' => 'test registrar russian'
  end

  it 'has registrar info in estonian' do
    render
    expect(rendered).to have_text('test registrar estonian')
  end

  it 'has registrar info in english' do
    render
    expect(rendered).to have_text('test registrar english')
  end

  it 'has registrar info in russian' do
    render
    expect(rendered).to have_text('test registrar russian')
  end

  it 'has domain name' do
    mention_count = 4 * lang_count
    expect(domain).to receive(:name).exactly(mention_count).times.and_return('test domain name')
    render
    expect(rendered).to have_text('test domain name', count: mention_count)
  end

  domain_attributes = %i(
    on_hold_date
    delete_date
    registrant_name
    admin_contact_names
    tech_contact_names
    nameserver_names
  )

  domain_attributes.each do |attr_name|
    it "has domain #{attr_name}" do
      expect(domain).to receive(attr_name).exactly(lang_count).times.and_return("test domain #{attr_name}")
      render
      expect(rendered).to have_text("test domain #{attr_name}", count: lang_count)
    end
  end
end
