class ClienteSerializer
  include JSONAPI::Serializer

  attributes :nome, :limite, :saldo
end
