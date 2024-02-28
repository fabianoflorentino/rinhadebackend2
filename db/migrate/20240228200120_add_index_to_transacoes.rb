class AddIndexToTransacoes < ActiveRecord::Migration[7.1]
  def change
    add_index :transacoes, :valor
  end
end
