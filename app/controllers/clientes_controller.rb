class ClientesController < ApplicationController
  def index
    render json: ClienteSerializer.new(clientes).serializable_hash, status: :ok
  end

  def show
    render json: ClienteSerializer.new(set_client).serializable_hash, status: :ok
  end

  private

  def clientes
    Cliente.all
  end

  def set_client
    Cliente.find(params[:id])
  end
end
