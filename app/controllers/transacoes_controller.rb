class TransacoesController < ApplicationController
  before_action :set_cliente

  def index
    render json: cliente_transacoes, status: :ok
  end

  def create
    Transacoes::Create.new(params[:cliente_id], transacao_params).call
    render json: { limite: @cliente.limite, saldo: @cliente.reload.saldo }, status: :ok
  end

  private

  def set_cliente
    @cliente = Cliente.find_by_id(params[:cliente_id])
  end

  def transacao_params
    params.permit(:valor, :tipo, :descricao)
  end

  def cliente_transacoes
    Transacao.where(cliente_id: params[:cliente_id])
  end
end
