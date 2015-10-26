module Api::DropboxFile
  extend ActiveSupport::Concern

  included do
    include Garage::Representer
    property :id
    property :name
    property :url
  end
end
