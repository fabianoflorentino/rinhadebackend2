class AddCamposToTransacoes < ActiveRecord::Migration[7.1]
  def change
    add_column :transacoes, :valor, :integer
    add_column :transacoes, :tipo, :string
    add_column :transacoes, :descricao, :text
  end
end
