module HasUnitType
  extend ActiveSupport::Concern

  included do
    enum :unit_type, { grams: 0, units: 1, ml: 2 }
  end
end
