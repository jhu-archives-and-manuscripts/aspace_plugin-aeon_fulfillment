class AeonArchivalObjectMapper < AeonRecordMapper

    register_for_record_type(Resource)

    def initialize(resource)
        super(resource)
    end

    # Override for AeonRecordMapper json_fields method. 
    def json_fields
        mappings = super

        json = self.record.json
        if !json
            return mappings
        end 

        mappings['collection_id'] = "#{json['id_0']} #{json['id_1']} #{json['id_2']} #{json['id_3']}".rstrip
        mappings['collection_title'] = mappings['display_string'] = json['title']

        return mappings
    end


    # If #show_action? returns false, then the button is shown disabled
    def show_action?
        begin
            puts "Aeon Fulfillment Plugin -- Checking for plugin settings for the repository"

            if !self.repo_settings
                puts "Aeon Fulfillment Plugin -- Could not find plugin settings for the repository: \"#{self.repo_code}\"."
            else
                puts "Aeon Fulfillment Plugin -- Checking for top containers"

                has_top_container = has_top_container?(self.record.json['instances'])

                only_top_containers = self.repo_settings[:resource_requests_permitted_for_containers_only] || false

                puts "Aeon Fulfillment Plugin -- Resource Containers found?    #{has_top_container}"
                puts "Aeon Fulfillment Plugin -- Resource only_top_containers? #{only_top_containers}"

                return (has_top_container || !only_top_containers)
            end

        rescue Exception => e
            puts "Aeon Fulfillment Plugin -- Failed to create Aeon Request action."
            puts e.message
            puts e.backtrace.inspect

        end

        false
    end

end
