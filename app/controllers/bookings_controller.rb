class BookingsController < ApplicationController
  before_action :logged_in_user, except: [:index, :disponibility]
  before_action :set_booking, only: %i[ show edit update destroy ]

  # GET /bookings or /bookings.json
  def index
    @bookings = Booking.all
    @booking = Booking.new
  end

  # GET /bookings/1 or /bookings/1.json
  def show
  end

  # GET /bookings/new
  def new
    @booking = Booking.new
  end

  # GET /bookings/1/edit
  def edit
  end

  # POST /bookings or /bookings.json
  def create

    if booking_params[:disponibility]

      unless booking_params[:dateRange].include? " to "
        respond_to do |format|
          format.html { redirect_to bookings_url, notice: "Debe elegir un rango de fechas." }
          format.json { render :index }
        end
      else

        disponibility

        respond_to do |format|
          format.html { 
            redirect_to bookings_url( 
            dateRange: booking_params[:dateRange], 
            stylecounter: @styleCounter) 
          }
          format.json { render :index }
        end

      end

    else

      @booking = Booking.new(booking_params)

      respond_to do |format|
        if @booking.save
          if @current_user.roles_id == Role.find_by(role: "client")._id
            format.html { redirect_to rooms_url, notice: "La reserva ha sido creada correctamente." }
          else
            format.html { redirect_to bookings_url, notice: "La reserva ha sido creada correctamente." }
          end
          format.json { render :index }
        else
          format.html { render :index, status: :unprocessable_entity }
          format.json { render json: @booking.errors, status: :unprocessable_entity }
        end
      end

    end

  end

  def disponibility

    @dateIn = DateTime.parse(booking_params[:dateRange].split(/ to /)[0])
    @dateOut = DateTime.parse(booking_params[:dateRange].split(/ to /)[1]) - 1.day

    @styleCounter = Hash.new

    Style.each do |style|

      rooms = Room.where( style_id: style._id ).pluck(:_id)

      dayCounter = Array.new

      (@dateIn..@dateOut).each do |day|

        counter = 0

        Booking.where( style_id: style._id ).each do |book|

          if book[:dateRange].nil?
            break
          end

          bookIn = DateTime.parse(book[:dateRange].split(/ to /)[0].to_s)
          bookOut = DateTime.parse(book[:dateRange].split(/ to /)[1].to_s)

          if (bookIn...bookOut).include?(day)
          #if day.between?(bookIn, bookOut)
            counter+= 1
            rooms.delete(book[:room_id])


          end

        end

        counter = Room.where(style_id: style._id).count - counter
        dayCounter.append(counter)

      end

      @styleCounter[style.desc] = [dayCounter.min, rooms[0] ]

    end

  end


  # PATCH/PUT /bookings/1 or /bookings/1.json
  def update
    respond_to do |format|
      if @booking.update(booking_params)
        format.html { redirect_to bookings_url, notice: "La reserva ha sido actualizada correctamente." }
        format.json { render :index }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bookings/1 or /bookings/1.json
  def destroy
    @booking.destroy

    respond_to do |format|

      if @current_user.roles_id == Role.find_by(role: "client")._id
        format.html { redirect_to rooms_url, notice: "La reserva se ha destruido correctamente." }
      else
        format.html { redirect_to bookings_url, notice: "La reserva se ha destruido correctamente." }
      end
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_booking
      @booking = Booking.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def booking_params
      params.require(:booking).permit(:user_id, :style_id, :dateRange, :room_id, :disponibility)
    end


end
