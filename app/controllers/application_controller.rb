class ApplicationController < ActionController::Base
  def hello
    render html: "Sample App"
  end
end
