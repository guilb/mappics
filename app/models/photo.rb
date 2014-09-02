class Photo < ActiveRecord::Base

attr_accessor :html
attr_writer :html
attr_reader :html


  has_attached_file :file,
  :styles => {
    :thumb60 => "60x60#"
  },
  :default_url => "/images/:style/user-missing.png"
  validates_attachment_content_type :file, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]


  after_file_post_process :load_exif

  #private
  def load_exif
    #puts "test test test test test AAA"
    #puts file.queued_for_write[:original].path
    #puts 
    #puts "filename"
    #puts file.queued_for_write[:original].inspect

    #puts file.inspect

    #puts file.queued_for_write[:original].file_name

    exif = EXIFR::JPEG.new(file.queued_for_write[:original].path)
    puts "SELF"
    puts exif.inspect
    puts self.inspect
    puts self.file_file_name
    #puts exif.inspect
    #puts exif.date_time
    puts exif.gps_latitude[0]
    puts exif.gps_latitude[1]
    puts exif.gps_latitude[2]
    #self.focal_length = exif.focal_length
    puts "CALCUUUUL"
    lat = exif.gps_latitude[0].to_f + (exif.gps_latitude[1].to_f / 60) + (exif.gps_latitude[2].to_f / 3600)
    puts lat
    long = exif.gps_longitude[0].to_f + (exif.gps_longitude[1].to_f / 60) + (exif.gps_longitude[2].to_f / 3600)
    puts long
    long = long * -1 if exif.gps_longitude_ref == "W"   # (W is -, E is +)
    lat = lat * -1 if exif.gps_latitude_ref == "S"      # (N is +, S is -)
    puts long
    puts lat
    puts longitude.to_f
    puts latitude.to_f
    self.longitude = long.to_f
    self.latitude = lat.to_f
    puts self.inspect

    puts "longitude"
    puts self.longitude
    puts "latitude"
    puts self.latitude 

    #return

  end
end
