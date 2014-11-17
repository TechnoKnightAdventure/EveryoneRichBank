class Api::ApiBase < ApplicationController
  protected
  
  class NoAccess < Exception
  end

  def deny_access!
    raise NoAccess
  end
  
  def _render(json, success: true, status: 200)
    respond_to do |format|
      format.json do
        render status: status, json: {
          success: success
        }.merge(json)
      end
    end
  end

  def _unimplemented(controller, action)
    json = { error: "Error: #{self.class.name}##{action_name} is not implemented!" }
    _render json, status: 500, success: false 
  end

  def action_missing(m, *args, &block)
    _unimplemented
  end

  rescue_from Exception do |exception|
    json = {}
    json[:error] = exception.message
    _render json, success: false, status: 500
  end


  rescue_from RuntimeError do |exception|
    json = {}
    json[:error] = exception.message
    _render json, success: false, status: 500
  end


  rescue_from ArgumentError do |exception|
    json = {}
    json[:error] = exception.message
    _render json, success: false, status: 406
  end

  rescue_from ActionView::MissingTemplate do |exception|
    # use exception.path to extract the path information
    # This does not work for partial
    json = { error: "Error: #{self.class.name}##{action_name} is not rendering anything!" }
    _render json, status: 500, success: false 
  end

  rescue_from Api::ApiBase::NoAccess do |exception|
    json = { error: "Error: Access not granted." }
    _render json, status: 403, success: false 
  end
end

