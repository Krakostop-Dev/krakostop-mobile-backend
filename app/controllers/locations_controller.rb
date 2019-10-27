class LocationsController < ProtectedController
  def create
    location = Location.create!(loc_params)
    render(json: location, status: :created)
  end

  def latest
    locations = Location.includes(:user).merge(Location.latest)
    render(json: locations, include: :user, status: :ok)
  end

  private

  def loc_params
    params.permit(:lat, :lng).merge(user: current_user)
  end
end
