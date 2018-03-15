require_dependency ActiveadminSettingsCached::Engine.config.root.join('lib', 'activeadmin_settings_cached', 'model.rb').to_s

module ActiveadminSettingsCached
  class Model
    def settings
      data = has_key? ? load_settings_by_key : keep_yml_order
      return unless data

      # override the sorting in order to display items as they are listed in
      # the yml file rather than alphabetically
      ::ActiveSupport::OrderedHash[data.to_a]
    end

    private

    def keep_yml_order
      yml_order = load_settings_by_key
      keys_with_data = load_settings
      keys_with_data.each do |key, value|
        yml_order[key] = value
      end
      yml_order
    end
  end
end
