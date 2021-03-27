class ConfigurationPageManager

  class << self
    attr_accessor :name, :configurations
  end

  def self.AssemblePage(configurations_hash)
    final_html = self.Title
    final_html += "<form action=\"/configuration\" method=\"post\">\n"
    configurations_hash.each do |rule, configurations|
      final_html += "<h2>#{rule.name}</h2>\n"
      configurations.each do |configuration|
        final_html += self.Input(configuration)
      end
    end
    final_html += "<input type=\"submit\" value=\"Submit\">\n"
    final_html += "</form>\n"
    return final_html
  end

  def self.ApplyConfigurations(configurations_hash, new_conf)
    configurations_hash.each do |rule, configurations|
      configurations.each do |configuration|
        case configuration.displayfield
        when DisplayField[:CheckBox]
          if new_conf.has_key?(configuration.id)
            configuration.value = true
          else
            configuration.value = false
          end
        when DisplayField[:SelectBox]
          configuration.value = new_conf[configuration.id].split(/\r?\n/).delete_if(&:empty?)
        else
          configuration.value = new_conf[configuration.id]
        end
      end
    end
  end

  def self.Title
    return "<h1>Configurations Page</h1>\n"
  end

  def self.Input(configuration)
    return_value = "<label for=\"#{configuration.class.name}\">#{configuration.name}:</label>\n"

    case configuration.displayfield
    when DisplayField[:CheckBox]
      return_value += "<input type=\"checkbox\" id=\"#{configuration.id}\" name=\"#{configuration.id}\""+if configuration.value then "checked" else "" end+"><br>\n"
    when DisplayField[:SelectBox]
      return_value += "<br><textarea id=\"#{configuration.id}\" name=\"#{configuration.id}\" rows=\"#{configuration.value.length()+2}\">\n"
      configuration.value.each do |option|
        return_value+="#{option}\n"
      end
      return_value += "</textarea>"
    end

    return_value += "<p style=\"color:gray\">#{configuration.description}</p>\n<br>\n"

    return return_value
  end

  private_class_method :Title
end