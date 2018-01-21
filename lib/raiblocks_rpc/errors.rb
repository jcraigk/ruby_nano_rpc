# frozen_string_literal: true
module RaiblocksRpc
  class Error < StandardError; end

  class BadRequest < Error; end
  class InvalidRequest < Error; end
  class InvalidParameterType < Error; end
  class ForbiddenParameter < Error; end
  class MissingParameters < Error; end
end
