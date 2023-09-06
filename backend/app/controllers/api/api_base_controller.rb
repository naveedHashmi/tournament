class Api::ApiBaseController < ApplicationController
  include ApiErrorHandler

  skip_before_action :verify_authenticity_token
end
