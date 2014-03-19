Sequel.migration do
  up do
    create_table :images do
      primary_key :id
      String :key
      String :format
    end
  end

  down do
    drop_table :images
  end
end
