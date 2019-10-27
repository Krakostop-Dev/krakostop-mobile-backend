class ProfilesController < ProtectedController
  def show
    render(json: current_user)
  end

  def update
    current_user.update!(profile_params)
    render(json: current_user, status: :ok)
  end

  private

  def profile_params
    params.permit(:first_name, :last_name).merge(verified_login: true)
  end
end
