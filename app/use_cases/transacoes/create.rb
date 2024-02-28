module Transacoes
  class Create
    def initialize(cliente_id, transacao_params)
      @cliente_id = cliente_id
      @valor = transacao_params[:valor].to_i
      @tipo = transacao_params[:tipo]
      @descricao = transacao_params[:descricao]
    end

    def call
      set_cliente
      ActiveRecord::Base.transaction do
        handle_credito if @tipo == 'c'
        handle_debito if @tipo == 'd'
        transacao
      end
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error "Erro ao criar transação: #{e.message}"
    end

    private

    def set_cliente
      @cliente = Cliente.find_by_id(@cliente_id)
    end

    def handle_credito
      saldo_atualizado = @cliente.saldo + @valor
      raise ActiveRecord::RecordInvalid unless saldo_atualizado <= @cliente.limite

      @cliente.update!(saldo: saldo_atualizado)
    end

    def handle_debito
      saldo_atualizado = @cliente.saldo - @valor
      raise ActiveRecord::RecordInvalid unless saldo_atualizado >= @cliente.limite * -1

      @cliente.update!(saldo: saldo_atualizado)
    end

    def transacao
      Transacao.create!(cliente_id: @cliente_id, valor: @valor, tipo: @tipo, descricao: @descricao)
    end
  end
end
