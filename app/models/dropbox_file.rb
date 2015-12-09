class DropboxFile < ActiveRecord::Base
  belongs_to :travel, touch: true
  include Api::DropboxFile
end
