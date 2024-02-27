module Transacoes
  class Create
    def initialize(cliente_id, transacao_params)
      @cliente_id = cliente_id
      @valor = transacao_params[:valor]
      @tipo = transacao_params[:tipo]
      @descricao = transacao_params[:descricao]
    end

    def call
      set_cliente
      handle_credito if @tipo == 'c'
      handle_debito if @tipo == 'd'
    end

    private

    def set_cliente
      @cliente = Cliente.find(@cliente_id)
    end

    def handle_credito
      saldo_atualizado = @cliente.saldo + @valor

      @cliente.update(saldo: saldo_atualizado) if saldo_atualizado <= @cliente.limite

      transacao
    end

    def handle_debito
      saldo_atualizado = @cliente.saldo - @valor

      @cliente.update(saldo: saldo_atualizado) if saldo_atualizado >= 0

      transacao
    end

    def transacao
      transacao = Transacao.new(cliente_id: @cliente_id, valor: @valor, tipo: @tipo, descricao: @descricao)
      transacao.save!
    end
  end
end
