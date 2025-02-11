# frozen_string_literal: true

# Manages routing and instantiating variable for Event Attendees endpoints
class EventAttendeesController < ApplicationController
  before_action :authenticate_user!, only: %i[create new update edit destroy index]
  before_action :create_event_attendee, only: :create
  before_action :set_event_attendee, only: %i[show edit update destroy]

  # GET /event_attendees or /event_attendees.json
  def index
    @event_attendees = EventAttendee.where(profile_id: current_user.profile.id)
  end

  # GET /event_attendees/1 or /event_attendees/1.json
  def show; end

  # GET /event_attendees/new
  def new
    @event_attendee = EventAttendee.new
    authorize @event_attendee
  end

  # GET /event_attendees/1/edit
  def edit; end

  # POST /event_attendees or /event_attendees.json
  def create
    respond_to do |format|
      if @event_attendee.save
        format.html { redirect_to @event_attendee, notice: "Event attendee was successfully created." }
        format.json { render :show, status: :created, location: @event_attendee }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event_attendee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /event_attendees/1 or /event_attendees/1.json
  def update
    respond_to do |format|
      if @event_attendee.update(event_attendee_params)
        format.html { redirect_to @event_attendee, notice: "Event attendee was successfully updated." }
        format.json { render :show, status: :ok, location: @event_attendee }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event_attendee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /event_attendees/1 or /event_attendees/1.json
  def destroy
    @event_attendee.destroy
    respond_to do |format|
      format.html { redirect_to event_attendees_url, notice: "Event attendee was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # callback to set event attendee for create
  def create_event_attendee
    @event_attendee = EventAttendee.new(event_attendee_params)
    authorize @event_attendee
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_event_attendee
    @event_attendee = EventAttendee.find(params[:id])
    authorize @event_attendee
  end

  # Only allow a list of trusted parameters through.
  def event_attendee_params
    params.require(:event_attendee).permit(:profile_id, :event_id)
  end
end
