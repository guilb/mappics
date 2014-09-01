class PhotosController < ApplicationController
  before_action :set_photo, only: [:show, :edit, :update, :destroy]
  # GET /photos
  # GET /photos.json
  def index
    @photos = Photo.all
  end
  
  def index_json
    @photos = Photo.find_by_sql "SELECT * FROM photos WHERE latitude != '' AND longitude != ''"
    @markers = Photo.find_by_sql "SELECT * FROM photos WHERE latitude != '' AND longitude != ''"
    @points =  Photo.find_by_sql "SELECT count(*) AS weight, latitude, longitude, GROUP_CONCAT(file_file_name SEPARATOR ',') as files, GROUP_CONCAT(id SEPARATOR ',') as ids FROM photos WHERE latitude !='' AND longitude != '' GROUP BY latitude, longitude"
    render :json => @points
  end

  # GET /photos/1
  # GET /photos/1.json
  def show
  end

  # GET /photos/new
  def new
    @photo = Photo.new
  end

  # GET /photos/1/edit
  def edit
  end

  # POST /photos
  # POST /photos.json
  def create
    #puts "avant"
    #puts params[:photo][:file].inspect
    #puts "apres"
    #puts EXIFR::JPEG.new(params[:photo][:file].queued_for_write[:original]).width
    puts photo_params.inspect
    @photo = Photo.new(photo_params)
    #puts "largeur"
    #puts EXIFR::JPEG.new(params[:photo][:file].queued_for_write[:original]).width

#puts "date"
#puts @photo.file.date
    respond_to do |format|
      if @photo.save
        format.html { redirect_to @photo, notice: 'Photo was successfully created.' }
        format.json { render action: 'show', status: :created, location: @photo }
      else
        format.html { render action: 'new' }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /photos/1
  # PATCH/PUT /photos/1.json
  def update
    respond_to do |format|
      if @photo.update(photo_params)
        format.html { redirect_to @photo, notice: 'Photo was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /photos/1
  # DELETE /photos/1.json
  def destroy
    @photo.destroy
    respond_to do |format|
      format.html { redirect_to photos_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_photo
      @photo = Photo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def photo_params
      params.require(:photo).permit(:file, :latitude, :longitude)
    end
end
