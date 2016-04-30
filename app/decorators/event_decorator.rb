module EventDecorator
  def period
    return '' if start_date.blank? && end_date.blank?
    period = ''
    period += I18n.l(start_date, format: :long) if start_date.present?
    period += " 〜 "
    period += I18n.l(end_date, format: :long) if end_date.present?
    period
  end
end
