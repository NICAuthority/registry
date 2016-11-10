require 'rails_helper'

RSpec.describe 'mailers/domain_mailer/pending_deleted.html.erb' do
  let(:domain) { instance_spy(DomainPresenter) }
  let(:lang_count) { 2 }

  before :example do
    assign(:domain, domain)
    assign(:registrar, nil)
    stub_template 'mailers/domain_mailer/registrar/_registrar.et.html' => 'test registrar estonian'
    stub_template 'mailers/domain_mailer/registrar/_registrar.en.html' => 'test registrar english'
    assign(:verification_url, 'test verification url')
  end

  it 'has registrar info in estonian' do
    render
    expect(rendered).to have_text('test registrar estonian')
  end

  it 'has registrar info in english' do
    render
    expect(rendered).to have_text('test registrar english')
  end

  it 'has domain name' do
    mention_count = 1 * lang_count
    expect(domain).to receive(:name).exactly(mention_count).times.and_return('test domain name')
    render
    expect(rendered).to have_text('test domain name', count: mention_count)
  end

  it 'has verification url' do
    mention_count = 1 * lang_count
    render
    expect(rendered).to have_text('test verification url', count: mention_count)
  end
end
