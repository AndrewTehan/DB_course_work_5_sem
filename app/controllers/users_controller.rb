# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    @users = connection_execute("select * from AllUsers()")
  end

  def destroy
    return redirect_to :users unless current_user

    if current_user.is_a?(Admin) || current_user
      reset_session if current_user
      connection_execute("call DeleteUser(#{current_user.id})")
      redirect_to :user
    end
  end

  def edit
    @user = current_user
    redirect_to users_path unless @user == current_user || current_user.is_a?(Admin)
  end

  def update
    connection_execute("call UpdateUser('#{user_params["first_name"]}', '#{user_params["last_name"]}',
                       '#{user_params["email"]}', '#{user_params["phone_number"]}', #{current_user.id})")
    redirect_to :root
  end

  def team
    @masters = connection_execute("select * from AllMasters()")
  end

  def services
    @services = connection_execute("select * from AllServices()")
  end

  def clients
    @clients = connection_execute("select * from AllClients()")
  end

  private

  def user_params
    @required_key = @user.is_a?(Admin) ? :admin : :client
    params.require(@required_key).permit(:first_name, :last_name, :email, :phone_number)
  end
end
