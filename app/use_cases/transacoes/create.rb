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
        raise ActiveRecord::RecordInvalid unless %w[c d].include?(@tipo)

        credito? if @tipo == 'c'
        debito? if @tipo == 'd'

        transacao
      end
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error "Erro ao criar transação:#{e.record.errors.full_messages.join(', ')}"
    end

    private

    def set_cliente
      @cliente ||= Cliente.find(@cliente_id)
    end

    def credito?
      saldo_atualizado = @cliente.saldo + @valor
      raise ActiveRecord::RecordInvalid unless saldo_atualizado <= @cliente.limite

      @cliente.update!(saldo: saldo_atualizado)
    end

    def debito?
      saldo_atualizado = @cliente.saldo - @valor
      raise ActiveRecord::RecordInvalid unless saldo_atualizado >= @cliente.limite * -1

      @cliente.update!(saldo: saldo_atualizado)
    end

    def transacao
      raise ActiveRecord::RecordInvalid unless @cliente

      Transacao.create!(cliente_id: @cliente_id, valor: @valor, tipo: @tipo, descricao: @descricao)
      Rails.logger.info "Transação criada com sucesso"
    end
  end
end
