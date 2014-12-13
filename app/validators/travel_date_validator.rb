class TravelDateValidator < ActiveModel::Validator
  def validate(record)
    return if record.start_date.nil? || record.end_date.nil?

    if record.start_date > record.end_date
      record.errors[:end_date] << ' 終了日は開始日より後の日付を指定して下さい'
    end
  end
end
