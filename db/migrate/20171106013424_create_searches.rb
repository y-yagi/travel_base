class CreateSearches < ActiveRecord::Migration[5.0]
  def change
    create_view :searches, materialized: true
  end
end
