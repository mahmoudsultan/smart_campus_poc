module Custom
    class SessionsController < DeviseTokenAuth::SessionsController
        def render_create_success
            data = resource_data(resource_json: @resource.token_validation_response)
            puts data
            
            render json: {
              data: resource_data(resource_json: @resource.token_validation_response)
            }
          end    
    end


end