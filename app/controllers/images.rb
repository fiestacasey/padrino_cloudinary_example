PadrinoCloudinary::App.controllers :images do

  post :create do
    newfiles = []
    params[:files].each{|file|
      next if file.class != Hash
      newfiles.push Image.create({:local_file => file[:tempfile], :filename => file[:filename], :format => file[:type]})
    }

    h = newfiles.map{|x| 
      {
        :id => x.id, 
        :thumb => x.image_url("60x95", :crop => :thumb),
        :full_path => x.image_url
      }
    }
    
    content_type :json
    h.to_json
  end

  delete :destroy, :with => :id do
    image = Image[params[:id]]
    if image.destroy
      content_type :json
      "success".to_json
    else
      halt 404
    end
  end
end