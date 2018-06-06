# frozen_string_literal: true
module NanoRpc
  class Error < StandardError; end

  class BadRequest < Error; end
  class ForbiddenParameter < Error; end
  class InvalidNanoAmount < Error; end
  class InvalidRawAmount < Error; end
  class InvalidRequest < Error; end
  class MissingParameters < Error; end
  class NodeConnectionFailure < Error; end
  class NodeOpenTimeout < Error; end
end
