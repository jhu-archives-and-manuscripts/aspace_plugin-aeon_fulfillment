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

end
