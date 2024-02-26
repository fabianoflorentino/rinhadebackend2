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
      transacao = Transacao.new(cliente_id: @cliente.id, valor: @valor, tipo: @tipo, descricao: @descricao)
      transacao.save!
      handle_transacao(transacao)
    end

    def handle_saldo
      saldo_inicial = @cliente.limite + params[:valor].to_d * (params[:tipo] == 'c' ? -1 : 1)
      saldo_atual = @cliente.reload.limite
      operacao = saldo_inicial - saldo_atual
      operacao.save!
    end

    private

    def set_cliente
      @cliente = Cliente.find(@cliente_id)
    end

    def handle_credito
      @cliente.update(limite: @cliente.limite + @valor)
      @cliente.save!
      { status: :ok, message: 'Transação realizada com sucesso' }
    end

    def handle_debito
      @cliente.update(limite: @cliente.limite - @valor)
      @cliente.save!
      { status: :ok, message: 'Transação realizada com sucesso' }
    end

    def handle_transacao(transacao)
      if transacao.valid?
        if @tipo == 'c'
          handle_credito
        elsif @tipo == 'd'
          handle_debito
        else
          { error: 'Tipo de transação inválido.' }
        end
      else
        { error: transacao.errors.full_messages }
      end
    end
  end
end
