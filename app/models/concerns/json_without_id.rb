module JsonWithoutId
  extend ActiveSupport::Concern

  included do
    def as_json(options = {})
      super(options).except('id')
    end
  end
end