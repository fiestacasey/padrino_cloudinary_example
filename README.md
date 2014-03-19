
## Getting Started

1. run
        
        bundle
        rake db:migrate
        password
        padrino start

2. visit localhost:3000

### Generation Notes

    padrino g project padrino_cloudinary -d sequel -a postgres -b -c sass -e haml
    cd padrino_cloudinary/
    padrino g controller Base get:index
    padrino g model Image key:string format:string
    padrino-gen plugin bootstrap


_set database.rb to_
    
    Sequel::Model.db = Sequel.sqlite 'db/development.sqlite3', :loggers => [logger]

_add to Gemfile_
    
    gem 'sqlite3'

_continue_

    bundle
    rake db:migrate
    padrino start