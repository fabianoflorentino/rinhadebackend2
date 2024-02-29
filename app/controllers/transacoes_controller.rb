class TransacoesController < ApplicationController
  def index
    render json: transacoes, status: :ok
  end

  def create
    Transacoes::Create.new(params[:cliente_id], transacao_params).call
    render json: { limite: cliente.limite, saldo: cliente.reload.saldo }, status: :ok
  end

  private

  def cliente
    Cliente.find_by_id(params[:cliente_id])
  end

  def transacao_params
    params.permit(:valor, :tipo, :descricao)
  end

  def transacoes
    transacoes = Transacao.includes(:cliente).where(cliente_id: params[:cliente_id])
    transacoes.order(created_at: :desc).limit(10)
  end
end
