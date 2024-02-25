class ClienteSerializer
  include JSONAPI::Serializer

  attributes :nome, :limite
end
