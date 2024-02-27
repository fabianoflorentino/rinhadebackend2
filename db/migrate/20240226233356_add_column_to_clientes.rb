class AddColumnToClientes < ActiveRecord::Migration[7.1]
  def change
    add_column :clientes, :saldo, :integer, default: 0
  end
end
