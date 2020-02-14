class LocationsController < ProtectedController
  FINISH_THRESHOLD = 2
  def create
    if current_user.finished?
      render(json: {}, status: :ok)
      return
    end

    location = Location.create!(loc_params)
    current_user.pair.update!(finished: true) if finished_race?
    render(json: location, status: :created)
  end

  def latest
    locations = Location.joins(:pair)
                        .includes(pair: :users)
                        .order('pairs.finished DESC, created_at ASC')
                        .merge(Location.latest)
    render(json: locations, include: { pair: { include: :users } }, status: :ok)
  end

  private

  def loc_params
    params.permit(:lat, :lng).merge(pair: current_user.pair)
  end

  def finished_race?(location)
    lat, lng = ENV['FINISH_COORDINATES'].split(',').map(&:strip)
    finish_line = Geokit::LatLng.new(lat, lng)
    location.distance_to(finish_line, units: :kms) <= FINISH_THRESHOLD
  end
end
