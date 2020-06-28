class CalendarsController < ProtectedController
  def show
    render(json: Day.includes(:attractions).all, include: :attractions)
  end
end
  