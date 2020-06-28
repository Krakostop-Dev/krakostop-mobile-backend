class LocationsController < ProtectedController
  FINISH_THRESHOLD = 2
  def create
    if current_user.finished?
      render(json: {}, status: :ok)
      return
    end

    location = Location.new(loc_params)
    distance = distance_to_finish_line(location)

    if distance <= FINISH_THRESHOLD
      location.update!(distance_left: 0)
      current_user.pair.update!(finished: true)
    else
      location.update!(distance_left: distance.to_i)
    end

    render(json: location, status: :created)
  end

  def latest
    locations = Location.joins(:pair)
                        .includes(pair: { users: { avatar_attachment: :blob } })
                        .order('distance_left ASC, created_at ASC')
                        .merge(Location.latest)

    json = locations.as_json(include: { pair: { include: :users } })
                    .each_with_index do |el,i| 
                      el["pair"]["ranking"] = i+1
                    end

    render(json: json, status: :ok)
  end

  private

  def loc_params
    params.permit(:lat, :lng)
          .merge(pair: current_user.pair,
                 sender: current_user)
  end


  def distance_to_finish_line(location)
    lat, lng = ENV['FINISH_COORDINATES'].split(',').map(&:strip)
    finish_line = Geokit::LatLng.new(lat, lng)
    location.distance_to(finish_line, units: :kms)
  end
end
