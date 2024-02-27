class UpdateFieldNameToDefaultValue < ActiveRecord::Migration[7.1]
  def up
    execute <<-SQL.squish
      UPDATE clientes SET saldo = 0 WHERE saldo IS NULL;
    SQL
  end

  def down
    execute <<-SQL.squish
      UPDATE clientes SET saldo = NULL WHERE saldo = 0;
    SQL
  end
end
