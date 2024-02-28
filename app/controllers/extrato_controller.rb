class ExtratoController < ApplicationController
  def index
    extrato = Transacoes::Extrato.new(params[:cliente_id]).call
    render json: extrato, status: :ok
  end
end
