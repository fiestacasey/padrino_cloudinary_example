module CloudinaryInitializer
  def self.registered(app)
    bucket = ENV["CLOUDINARY-BUCKET"]
    api_key = ENV["CLOUDINARY-API-KEY"]
    api_secret = ENV["CLOUDINARY-API-SECRET"]

    Cloudinary.config do |config|
      config.cloud_name = bucket
      config.api_key = api_key
      config.api_secret = api_secret
      config.cdn_subdomain = true
    end
  end
end
