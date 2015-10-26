class DropboxFile < ActiveRecord::Base
  belongs_to :travel
  include Api::DropboxFile
end
