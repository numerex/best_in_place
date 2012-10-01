module BestInPlace
  module ControllerExtensions
    def respond_with_bip(obj, error_message = nil)
      obj.changed? ? respond_bip_error(obj, error_message) : respond_bip_ok(obj)
    end

  private
    def respond_bip_ok(obj)
      klass = obj.class.to_s
      updating_attr = params[klass.underscore].keys.first

      if renderer = BestInPlace::DisplayMethods.lookup(klass, updating_attr)
        render :json => renderer.render_json(obj)
      else
        head :ok
      end
    end

    def respond_bip_error(obj, error_message = nil)
      render :json => (error_message ? error_message : obj.errors.full_messages), :status => :unprocessable_entity
    end
  end
end