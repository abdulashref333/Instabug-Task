module JsonWithoutId
  extend ActiveSupport::Concern

  included do
    def as_json(options = {})
      super(options).except('id', 'application_id', 'chat_id')
    end
  end
end