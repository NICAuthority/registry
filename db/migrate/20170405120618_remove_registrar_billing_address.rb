class RemoveRegistrarBillingAddress < ActiveRecord::Migration
  def change
    remove_column :registrars, :billing_address, :string
  end
end
