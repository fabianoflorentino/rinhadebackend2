class ClientesController < ApplicationController
  def index
    render json: ClienteSerializer.new(clientes).serializable_hash, status: :ok
  end

  def show
    render json: ClienteSerializer.new(cliente).serializable_hash, status: :ok
  end

  private

  def clientes
    Cliente.all
  end

  def cliente
    Cliente.find_by_id(params[:id])
  end
end
