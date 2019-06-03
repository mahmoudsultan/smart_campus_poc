module Custom
    class RegistrationsController < DeviseTokenAuth::RegistrationsController
        def resource_with_avatar
            avatars = @resource.avatars.map &-> (a){
                extension = a.image.path.split('.')[-1]
                base64_image = "data:image/#{extension};base64,#{Base64.encode64(a.image.read)}"
                {image: base64_image , is_main: a.is_main }
            }
            response = resource_data.clone
            response[:avatars] = avatars
            response
        end

        def render_update_success
            render json: {
              status: 'success',
              data:   resource_with_avatar
            }
        end

        def render_create_success
            render json: {
              status: 'success',
              data:   resource_with_avatar
            }
        end

        def update 
            super do |resource| 

                existing_avatars_b64 = resource.avatars.map &-> (a) { {image: Base64.encode64(a.image.read), id: a.id} }
                @avatars.each do |avatar| 
                    not_found = true
                    # check if we have this image alread, equality checks probably aren't
                    # the best for images tho, yet this is a quick solution.
                    existing_avatars_b64.each do |existing_avatar_b64|
                        arriving_b64 = avatar[:image].split(',')[1..-1].join
                        if ( (avatar[:id] && avatar[:id] == existing_avatar_b64.id) || (existing_avatar_b64[:image] == arriving_b64) )
                            not_found = false
                        end
                    end

                    resource.avatars.create!(image: avatar[:image]) if not_found
                end
            end
        end

        def account_update_params
            filtered_params = params.permit(*params_for_resource(:account_update))
            @avatars = filtered_params[:avatars] || []
            filtered_params.except(:avatars)
            
        end

        def create 
            super do |resource| 
                @avatars.each do |avatar| 
                    resource.avatars.create!(image: avatar[:image])
                end
            
            end
        end

        def build_resource
            # save avatars to an instance variable to save it if the user was saved
            @avatars = sign_up_params['avatars']
            params_sans_avatar = sign_up_params.except('avatars')
            
            @resource            = resource_class.new(params_sans_avatar)
            @resource.provider   = provider

            # honor devise configuration for case_insensitive_keys
            if resource_class.case_insensitive_keys.include?(:email)
                @resource.email = params_sans_avatar[:email].try(:downcase)
            else
                @resource.email = params_sans_avatar[:email]
            end
        end

    end
    
end
