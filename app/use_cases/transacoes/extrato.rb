module Transacoes
  class Extrato
    def initialize(cliente_id)
      @cliente_id = cliente_id
    end

    def call
      extrato
    end

    private

    def cliente
      Cliente.find_by_id(@cliente_id)
    end

    def transacoes
      Transacao.where(cliente_id: @cliente_id)
    end

    def extrato
      {
        saldo: {
          total: cliente.saldo,
          data_extrato: Time.zone.now,
          limite: cliente.limite
        },
        ultimas_transacoes: transacoes.map do |transacao|
          {
            valor: transacao.valor,
            tipo: transacao.tipo,
            data: transacao.created_at
          }
        end
      }
    end
  end
end
