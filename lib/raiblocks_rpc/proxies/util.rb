# frozen_string_literal: true
class RaiblocksRpc::Util < RaiblocksRpc::Proxy
  def proxy_methods
    {
      mrai_from_raw: { required: %i[amount] },
      mrai_to_raw: { required: %i[amount] },
      krai_from_raw: { required: %i[amount] },
      krai_to_raw: { required: %i[amount] },
      rai_from_raw: { required: %i[amount] },
      rai_to_raw: { required: %i[amount] },
      key_create: nil,
      key_expand: { required: %i[key] },
      work_validate: { required: %i[work hash] }
    }
  end
end
