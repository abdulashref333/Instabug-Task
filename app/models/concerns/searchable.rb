module Searchable
 extend ActiveSupport::Concern

 included do
    include Elasticsearch::Model

    settings do
      mappings dynamic: 'false' do
        indexes :body, analyzer: 'english'
        indexes :chat_id, type: 'keyword'
      end
    end
 end
end
