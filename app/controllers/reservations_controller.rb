class ReservationsController < ApplicationController
  before_action :set_reservation, only: [:show, :edit, :update, :destroy]

  # GET /reservations
  # GET /reservations.json
  def index
    @reservations = current_user.admin? || current_user.superadmin? ? Reservation.all : Reservation.where('user_id = ?', current_user.id)
  end

  # GET /reservations/1
  # GET /reservations/1.json
  def show
  end

  # GET /reservations/new
  def new
    @user_id = current_user.id
    @car_id = params[:car_id]
    @reservation = Reservation.new
  end

  # GET /reservations/1/edit
  def edit
  end

  # POST /reservations
  # POST /reservations.json
  def create
    @reservation = Reservation.new(reservation_params)
    if @reservation.checkout_time > DateTime.now.advance({days:7})
      raise 'Reservations are allowed only till upcoming 7 days'
    end
    if @reservation.return_time < @reservation.checkout_time.advance({hours: 1}) or
        @reservation.return_time > @reservation.checkout_time.advance({hours:10})
      raise 'Reservation below 1 hour and more than 10 hours is not allowed'
    end
    if User.find(@reservation.user_id).has_reserved?
      raise 'Can not have more than one reservations'
    end
    @reservation.reserved = true
    respond_to do |format|
      if @reservation.save
        @car = Car.find(params[:reservation][:car_id])
        @car.status = 'reserved'
        @car.save
        @user = User.find(params[:reservation][:user_id])
        @user.has_reserved = true
        @user.save
        format.html { redirect_to @reservation, notice: 'Reservation was successfully created.' }
        format.json { render :show, status: :created, location: @reservation }
      else
        format.html { render :new }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reservations/1
  # PATCH/PUT /reservations/1.json
  def update
    respond_to do |format|
      if @reservation.update(reservation_params)
        format.html { redirect_to @reservation, notice: 'Reservation was successfully updated.' }
        format.json { render :show, status: :ok, location: @reservation }
      else
        format.html { render :edit }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reservations/1
  # DELETE /reservations/1.json
  def destroy
    @car = Car.find(@reservation.car_id)
    @car.status = 'available'
    @car.save
    @user = User.find(@reservation.user_id)
    @user.has_reserved = false
    @user.save
    @reservation.destroy
    respond_to do |format|
      format.html { redirect_to reservations_url, notice: 'Reservation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def checkout
    @reservation = Reservation.find(params[:reservation_id])
    @reservation.checked_out = true
    @reservation.save
    @car = Car.find(@reservation.car_id)
    @car.status = 'checked_out'
    @car.save
  end

  def return
    @reservation = Reservation.find(params[:reservation_id])
    @reservation.checked_out = false
    @reservation.save
    @car = Car.find(@reservation.car_id)
    @car.status = 'available'
    @car.save
    @user = User.find(@reservation.user_id)
    @user.has_reserved = false
    @user.save
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reservation
      @reservation = Reservation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reservation_params
      params.require(:reservation).permit(:id, :user_id, :car_id, :checkout_time, :return_time, :checked_out, :reserved)
    end
end
