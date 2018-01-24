# frozen_string_literal: true
module Raiblocks
  class Error < StandardError; end

  class NodeConnectionFailure < Error; end
  class BadRequest < Error; end
  class InvalidRequest < Error; end
  class InvalidParameterType < Error; end
  class ForbiddenParameter < Error; end
  class MissingParameters < Error; end
end
