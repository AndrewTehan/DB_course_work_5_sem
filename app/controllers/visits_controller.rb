# frozen_string_literal: true

class VisitsController < ApplicationController
  def index
    @client = current_user.id
    @visits = current_user.visits
  end

  def admin_index
    @all_visits = connection_execute("select * from AllVisits()")
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
    @masters = connection_execute("select * from AllMasters()")
    @services = connection_execute("select * from AllServices()")
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
    @visit = Visit.find_by_sql("select * from VisitsById(#{params[:id]})").first
    redirect_to client_visits_path(current_user), notice: 'Redaction is possible only when state is sent' if @visit["visit_state"] != 'sent'
    @allMasters = connection_execute("select * from AllMasters()")
    @allServices = connection_execute("select * from AllServices()")
  end

  def update
    connection_execute("call UpdateVisit('#{visit_params["date"]}', '#{visit_params["addition"]}', #{params[:id]})")

    redirect_to client_visits_path(current_user.id)
  end

  def destroy
    connection_exec urrent_user.is_a?(Admin)
      redirect_to admin_index_path
    else
      redirect_to client_visits_path(params[:id])
    end
  end

  private
  def visit_params
    params.require(:visit).permit(:date, :addition, :master_id, service_visit_attributes: :service_id)
  end
end
