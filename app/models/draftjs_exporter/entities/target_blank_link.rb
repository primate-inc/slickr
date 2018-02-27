class DraftjsExporter::Entities::TargetBlankLink
  attr_reader :configuration

  def initialize(configuration = { className: nil })
    @configuration = configuration
  end

  def call(parent_element, data)
    args = { href: data.fetch(:data, {}).fetch(:url) }
    args[:class] = configuration.fetch(:className) if configuration[:className]
    args[:target] = '_blank'

    element = parent_element.document.create_element('a', args)
    parent_element.add_child(element)
    element
  end
end
