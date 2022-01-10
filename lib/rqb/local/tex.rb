# frozen_string_literal: true

require_relative '../local'

# Tex project related methods.
module Rqb::Local::Tex
  class << self
    def project_name
      ENV.fetch('TEX_PROJECT_NAME')
    end

    alias output_name project_name
  end
end
