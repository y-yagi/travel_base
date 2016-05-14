module Recorder
  extend ActiveSupport::Concern

  included do
    after_destroy :record_deleted_datum

    def record_deleted_datum
      DeletedDatum.create!(table_name: self.class.table_name, datum_id: self.id, user_id: self.try(:user_id) || self.try(:owner_id))
    end
  end
end
