class Transacao < ApplicationRecord
  belongs_to :cliente

  self.table_name = "transacoes"

  validates :cliente_id, presence: true
end
