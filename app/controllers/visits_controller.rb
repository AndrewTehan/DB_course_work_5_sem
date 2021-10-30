# frozen_string_literal: true

class VisitsController < ApplicationController
  def index
    @client = current_user
    @visits = current_user.visits
  end

  def admin_index
    @all_visits = ActiveRecord::Base.connection.execute("select * from Visits")
  end

  def change_status
    @visit = Visit.find(params[:visit_id])
    case @visit.state
    when 'sent'
      @visit.accepted!
    when 'confirmed'
      @visit.finished!
    end
    redirect_to admin_index_path
  end

  def new
    @client = current_user
    @masters = ActiveRecord::Base.connection.execute("select * from Users where type = 'Master'")
    @services = ActiveRecord::Base.connection.execute("select * from Services")
  end

  def create
    @visit = current_user.visits.build(visit_params)
    if @visit.valid?
      @visit.save
      redirect_to client_visits_path(current_user)
    else
      redirect_to new_client_visit_path(current_user), flash: { errors: @visit.errors.full_messages }
    end
  end

  def edit
    @client = current_user
    @visit = Visit.find_by(id: params[:id])
    redirect_to client_visits_path(current_user), notice: 'Redaction is possible only when state is sent' if @visit.state != 'sent'
  end

  def update
    @client = Client.find_by(id: params[:client_id])
    @visit = Visit.find_by(id: params[:id])
    @visit.update(visit_params)

    redirect_to client_visits_path(@client)
  end

  def destroy
    @visit = Visit.find(params[:id])
    @visit.destroy
    if current_user.is_a?(Admin)
      redirect_to admin_index_path
    else
      redirect_to client_visits_path(current_user)
    end
  end

  private

  def visit_params
    params.require(:visit).permit(:date, :addition, :master_id, service_visit_attributes: :service_id)
  end
end
