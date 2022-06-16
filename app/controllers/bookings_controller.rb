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
  #Se usa la funcion de crear reserva para llamar a la funcion de disponibilidad
  def create

    #si se llama a esta funcion con el parametro [:disponibility] 
    #llamara a la funcion de disponibilidad en lugar de crear la reserva
    if booking_params[:disponibility]

      #si se ha introducido solo una fecha en lugar de un rango de fechas
      #refrescara la pagina y mostrara un error
      unless booking_params[:dateRange].include? " to "
        respond_to do |format|
          format.html { redirect_to bookings_url, notice: "Debe elegir un rango de fechas." }
          format.json { render :index }
        end
      else

        disponibility

        #devolvera a la misma pagina con el array generado en la funcion de disponibilidad
        #y otro parametro con la fecha elegida para mostrarla en el input
        #   y para usarse como valor oculto cuando se reserve la habitación
        respond_to do |format|
          format.html { 
            redirect_to bookings_url( 
            dateRange: booking_params[:dateRange], 
            stylecounter: @styleCounter) 
          }
          format.json { render :index }
        end

      end

    #si se llama a esta funcion de forma normal 
    #se creara la resrva con los valores ocultos del cliente y la fecha,
    #   y el estilo que el haya elegido
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

#funcion para ver cuantas habitaciones hay disponibles de cada tipo
  def disponibility

    #la fecha se guarda como cadena de texto asi que tenemos que transformarla
    # en un objeto tipo fecha para poder interaccionar con ella
    @dateIn = DateTime.parse(booking_params[:dateRange].split(/ to /)[0])
    @dateOut = DateTime.parse(booking_params[:dateRange].split(/ to /)[1]) - 1.day

    @styleCounter = Hash.new

    #por cada estilo:
    Style.each do |style|

      #crea un aray con todas las habitaciones de este estilo
      #seran las posibles habitaciones que podra reservar a no ser que este ocupada
      rooms = Room.where( style_id: style._id ).pluck(:_id)

      #vamos a guardar una cantidad de habitaciones por cada dia dentro 
      #del rango de fechas
      dayCounter = Array.new

      (@dateIn..@dateOut).each do |day|

        counter = 0

        #por cada reserva existente
        Booking.where( style_id: style._id ).each do |book|

          #si no existe ninguna resrva relacionada con este estilo de habitacion
          #rompe el bucle y pasa al siguiente estilo
          if book[:dateRange].nil?
            break
          end

          bookIn = DateTime.parse(book[:dateRange].split(/ to /)[0].to_s)
          bookOut = DateTime.parse(book[:dateRange].split(/ to /)[1].to_s)

          if (bookIn...bookOut).include?(day)
          #suma uno al contador si hay una habitacion ocupada
          #y elimina la habitacion ocupada de las posibles habitaciones
            counter+= 1
            rooms.delete(book[:room_id])
          end

        end

        #resta la cantidad de habitaciones ocupadas a la cantidad total
        #para guardar el numer de habitaciones libres
        counter = Room.where(style_id: style._id).count - counter

        #todos los dias dentro del rango añade un numero diferente de habitaciones
        #despues se cogera solo el numero mas pequeño
        dayCounter.append(counter)

      end

      #devuelve un array con los nombres de los estiolos como index de los objetos
      #y por cada objecto devuelve la cantidad de habitaciones libres y la habitacion
      #que se asignaria en caso de que se reserve una habitación de ese estilo
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
