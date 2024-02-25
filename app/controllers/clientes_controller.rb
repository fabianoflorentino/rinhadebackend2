class ClientesController < ApplicationController
  def index
    render json: ClienteSerializer.new(clientes).serializable_hash, status: :ok
  end

  def show
    render json: ClienteSerializer.new(set_client).serializable_hash, status: :ok
  end

  private

  def clientes
    @clientes ||= Cliente.all
  end

  def set_client
    @cliente = Cliente.find(params[:id])
  end
end
