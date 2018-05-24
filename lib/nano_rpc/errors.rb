# frozen_string_literal: true
module NanoRpc
  class Error < StandardError; end

  class NodeConnectionFailure < Error; end
  class BadRequest < Error; end
  class InvalidRequest < Error; end
  class ForbiddenParameter < Error; end
  class MissingParameters < Error; end
  class NodeOpenTimeout < Error; end
end
