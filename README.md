# Boilerplate Ruby Sinatra - SQLite3

Basado en boilerplate wixel de Sinatra.

### Antes de usar

  $ bundler install

### Rutas

  +

### Migraciones

Ejecutar migración

    $ sequel -m path/to/migrations postgres://host/database
    $ sequel -m path/to/migrations sqlite://db/ubicaciones.db
    $ sequel -m path/to/migrations mysql://root:123@localhost/ubicaciones

Ejecutar el 'down' de las migraciones de la última a la primera:

    $ sequel -m db/migrations -M 0 mysql://root:123@localhost/ubicaciones
    $ sequel -m db/migrations -M 0 sqlite://db/ubicaciones.db

Ejecutar el 'up' de las migraciones hasta un versión especifica:

    $ sequel -m db/migrations -M #version mysql://root:123@localhost/ubicaciones
    $ sequel -m db/migrations -M #version sqlite://db/ubicaciones.db

Tipos de Datos de Columnas

+ :string=>String
+ :integer=>Integer
+ :date=>Date
+ :datetime=>[Time, DateTime].freeze,
+ :time=>Sequel::SQLTime,
+ :boolean=>[TrueClass, FalseClass].freeze,
+ :float=>Float
+ :decimal=>BigDecimal
+ :blob=>Sequel::SQL::Blob

# Fuentes:

+ https://github.com/Wixel/Frank-Sinatra
+ https://github.com/jeremyevans/sequel
+ http://sequel.jeremyevans.net/rdoc/files/doc/dataset_filtering_rdoc.html
+ http://sequel.jeremyevans.net/rdoc/files/doc/cheat_sheet_rdoc.html
+ https://stackoverflow.com/questions/6916626/sinatra-helper-in-external-file
+ https://stackoverflow.com/questions/35787395/how-to-access-incoming-headers-in-sinatra
