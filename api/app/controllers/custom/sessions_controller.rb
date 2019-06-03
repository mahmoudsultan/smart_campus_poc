module Custom
    class SessionsController < DeviseTokenAuth::SessionsController
        def resource_with_avatar
            avatars = @resource.avatars.map &-> (a){
                extension = a.image.path.split('.')[-1]
                base64_image = "data:image/#{extension};base64,#{Base64.encode64(a.image.read)}"
                {image: base64_image , is_main: a.is_main }
            }
            response = resource_data(resource_json: @resource.token_validation_response).clone
            response[:avatars] = avatars
            response
        end

        def render_create_success     
            render json: {
              data: resource_with_avatar
            }
        end    
    end


end