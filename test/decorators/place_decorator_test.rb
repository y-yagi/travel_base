# coding: utf-8
require 'test_helper'

class PlaceDecoratorTest < ActiveSupport::TestCase
  def setup
    @place = Place.new.extend PlaceDecorator
  end

  # test "the truth" do
  #   assert true
  # end
end
