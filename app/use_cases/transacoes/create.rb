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
      handle_credito if @tipo == 'c'
      handle_debito if @tipo == 'd'
    end

    private

    def set_cliente
      @cliente = Cliente.find_by_id(@cliente_id)
    end

    def handle_credito
      begin
        saldo_atualizado = @cliente.saldo + @valor

        if saldo_atualizado <= @cliente.limite
          @cliente.update(saldo: saldo_atualizado)
          @cliente.reload.saldo
          @cliente.save!

          transacao
        else
          raise ActiveRecord::RecordInvalid
        end
      rescue ActiveRecord::ConnectionTimeoutError, ActiveRecord::StatementTimeout => e
        Rails.logger.error e.message
      end
    end

    def handle_debito
      begin
        saldo_atualizado = @cliente.saldo - @valor

        if saldo_atualizado >= @cliente.limite * -1
          @cliente.update(saldo: saldo_atualizado)
          @cliente.reload.saldo
          @cliente.save!

          transacao
        else
          raise ActiveRecord::RecordInvalid
        end
      rescue ActiveRecord::ConnectionTimeoutError, ActiveRecord::StatementTimeout => e
        Rails.logger.error e.message
      end
    end

    def transacao
      transacao = Transacao.new(cliente_id: @cliente_id, valor: @valor, tipo: @tipo, descricao: @descricao)
      transacao.save!
    end
  end
end
