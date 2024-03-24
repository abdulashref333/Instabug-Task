module JsonWithoutId
  extend ActiveSupport::Concern

  included do
    def as_json(options = {})
      return super(options).except('id', 'application_id', 'chat_id') if options[:prefixes]

      super(options)
    end
  end
end