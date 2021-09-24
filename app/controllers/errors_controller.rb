# frozen_string_literal: true

# Render error pages
class ErrorsController < ApplicationController
  layout false

  def route_not_found
    render file: Rails.public_path.join("404.html"), status: :not_found
  end
end
