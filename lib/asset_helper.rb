module AssetHelper
  def self.included(base)
    base.class_eval do
      attr_accessor :filename
      attr_accessor :local_file

      plugin :validation_helpers

      def validate
        validates_presence     :key if id.present?
        validates_presence     :filename if id.blank?
        validates_presence     :local_file if id.blank?
      end


      def before_save
        upload_to_cloudinary if self.local_file.present? and self.filename.present?
        super
      end

      def after_destroy
        remove_from_cloudinary
        super
      end

      require 'cloudinary/helper'
      def image_url(size_b = "", options={})

        width, height = size_b.split("x")
        width = width.gsub(/[^0-9]/, "") if width
        height = height.gsub(/[^0-9]/, "") if height

        if width or height
          Cloudinary::Utils.cloudinary_url self.key, {:size => "#{width}x#{height}", :crop => :fit, :format => translate_format(options)}.merge(options)
        else
          Cloudinary::Utils.cloudinary_url self.key, {:format => format}.merge(options)
        end 
      end

      private


        def translate_format(options={})
            f = (options[:format]||self.format||"jpg").downcase
            # make sure it is a supported cloudinary format
            ["jpg", "png", "gif", "bmp", "tiff", "ico", "pdf", "eps", "psd", "webp"].select{|x| f.include?(x)}.last || "jpg"
        end

        def remove_from_cloudinary
          puts "deleting #{self.key}"
          Cloudinary::Uploader.destroy(self.key)
        end

        def upload_to_cloudinary
          f = filename.chomp(File.extname(filename)).gsub(/[^a-zA-Z0-9]/, '_')
          key = "#{RACK_ENV}/#{self.class.name.downcase.pluralize}/#{f}-#{Time.now.to_i}"
          puts "uploading #{key}"
          uploaded_image = Cloudinary::Uploader.upload(self.local_file, :public_id => key)

          self.format = uploaded_image[:format]
          self.key = "v#{uploaded_image["version"]}/#{key}"

          puts "uploaded_image #{uploaded_image.inspect}"

          key
        end


    end
  end
end