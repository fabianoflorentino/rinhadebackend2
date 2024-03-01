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

      dados_transacao_validos?

      ActiveRecord::Base.transaction do
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
      Transacao.create!(cliente_id: @cliente_id, valor: @valor, tipo: @tipo, descricao: @descricao)
      Rails.logger.info "Transação criada com sucesso"
    end

    def dados_transacao_validos?
      tipo_valido?
      valor_valido?
      dados_validos?
      descricao_valida?(@descricao)
    end

    def tipo_valido?
      raise ActiveRecord::RecordInvalid unless %w[c d].include?(@tipo)
    end

    def valor_valido?
      raise ActiveRecord::RecordInvalid unless @valor.is_a?(Integer) && @valor.positive?
    end

    def descricao_valida?(descricao)
      raise ActiveRecord::RecordInvalid if descricao.blank? || descricao.length > 10 || descricao.match?(/[^\w\s]/)
    end

    def dados_validos?
      @cliente_id && @valor && @tipo && @descricao
    end

  end
end
