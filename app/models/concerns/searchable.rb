module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    def self.search_by(query, user, fields: self.search_fields, page: 1)
      params = {
        query: {
          simple_query_string: {
            query: query,
            fields: fields
          }
        },
        filter: {
          term: { user_id: user.try(:id) }
        }
      }
      search(params).page(page).records
    end
  end
end
