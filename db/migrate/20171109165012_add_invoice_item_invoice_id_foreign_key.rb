class AddInvoiceItemInvoiceIdForeignKey < ActiveRecord::Migration
  def change
    add_foreign_key :invoice_items, :invoices, name: 'invoice_item_invoice_id_fk'
  end
end
