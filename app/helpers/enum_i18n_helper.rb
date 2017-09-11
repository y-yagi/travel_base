module EnumI18nHelper
  def enum_options_for_select(class_name, enum)
    class_name.send(enum.to_s.pluralize).transform_keys { |key| enum_i18n(class_name, enum, key) }
  end

  def enum_i18n(class_name, enum, key)
    I18n.t("activerecord.attributes.#{class_name.model_name.i18n_key}.#{enum.to_s.pluralize}.#{key}")
  end
end
