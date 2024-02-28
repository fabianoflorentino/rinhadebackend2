class Extrato < ApplicationRecord
  belongs_to :transacoes

  validates :cliente_id, presence: true
end
