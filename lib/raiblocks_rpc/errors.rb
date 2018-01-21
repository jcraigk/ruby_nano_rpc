# frozen_string_literal: true
module RaiblocksRpc
  class BadRequest < StandardError; end
  class InvalidRequest < StandardError; end
  class InvalidParameterType < StandardError; end
  class ForbiddenParameter < StandardError; end
  class MissingParameters < StandardError; end
end
