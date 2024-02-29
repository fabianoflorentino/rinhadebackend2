class Transacao < ApplicationRecord
  self.table_name = 'transacoes'

  belongs_to :cliente

  validates :cliente_id, presence: true
end
