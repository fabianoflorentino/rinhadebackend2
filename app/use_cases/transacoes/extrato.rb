module Transacoes
  class Extrato
    def initialize(cliente_id)
      @cliente_id = cliente_id
    end

    def call
      extrato
    end

    private

    def transacoes
      Transacao.includes(:cliente).where(cliente_id: @cliente_id).order(created_at: :desc)
    end

    def cliente
      Cliente.find_by_id(@cliente_id)
    end

    def extrato
      saldo ={
        total: cliente.saldo,
        data_extrato: Time.zone.now,
        limite: cliente.limite
      }

      ultimas_transacoes = transacoes.last(10).map do |transacao|
        {
          valor: transacao.valor,
          tipo: transacao.tipo,
          data: transacao.created_at
        }
      end

      { saldo: saldo, ultimas_transacoes: ultimas_transacoes}
    end
  end
end
