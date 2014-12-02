require 'test_helper'

class TravelPhotosControllerTest < ActionController::TestCase
  setup do
    @travel_photo = travel_photos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:travel_photos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create travel_photo" do
    assert_difference('TravelPhoto.count') do
      post :create, travel_photo: { photo_service_album_id: @travel_photo.photo_service_album_id, photo_service_user_info_id: @travel_photo.photo_service_user_info_id, travel_id: @travel_photo.travel_id }
    end

    assert_redirected_to travel_photo_path(assigns(:travel_photo))
  end

  test "should show travel_photo" do
    get :show, id: @travel_photo
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @travel_photo
    assert_response :success
  end

  test "should update travel_photo" do
    patch :update, id: @travel_photo, travel_photo: { photo_service_album_id: @travel_photo.photo_service_album_id, photo_service_user_info_id: @travel_photo.photo_service_user_info_id, travel_id: @travel_photo.travel_id }
    assert_redirected_to travel_photo_path(assigns(:travel_photo))
  end

  test "should destroy travel_photo" do
    assert_difference('TravelPhoto.count', -1) do
      delete :destroy, id: @travel_photo
    end

    assert_redirected_to travel_photos_path
  end
end
