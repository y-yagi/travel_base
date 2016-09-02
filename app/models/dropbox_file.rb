class DropboxFile < ApplicationRecord
  belongs_to :travel, touch: true
  include Api::DropboxFile
end
