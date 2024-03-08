require 'dotenv/load'

Cloudinary.config do |config|
    config.cloud_name = ENV['CLOUDINARY_CLOUD_NAME']
    config.api_key = ENV['CLOUDINARY_API_KEY']
    config.api_secret = ENV['CLOUDINARY_API_SECRET']
    config.secure = true # Use HTTPS for secure transmission
    config.cdn_subdomain = true # Use a subdomain for CDN
end