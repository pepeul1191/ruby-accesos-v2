CONSTANTS = {
  :BASE_URL => 'http://localhost:3000/',
  :STATIC_URL => 'http://localhost:3000/',
  :CSRF => {
    :secret => 'mpt/sr6eS2AlCRHU7DVThMgFTN08pnfSDf/C94eZx7udfm0lvgaYWLYJttYPKzGKDTlXwVU/d2FOxbKkgNlsTw==',
    :key => 'csrf_val'
  },
  :login => {
    :usuario => 'admin',
    :contrasenia => 'sistema123',
  },
  :ambiente => 'desarrollo',
  :key => 'Fdp6CVxpri1ga8kH',
  :servicios => {
    :accesos => 'http://localhost:5000/',
    :agricultor => 'http://localhost:3012/',
    :ubicaciones => 'http://localhost:3011/',
    :archivos => 'http://192.168.1.43:3031/',
    :ftp => {
      :dominio => '192.168.1.43',
      :puerto => 22,
      :usuario => 'pepe',
      :contrasenia => 'kiki123',
      :ruta => '/home/pepe/Documentos/python/archivos/static/',
      :public => 'http://192.168.1.43:3031/'
    },
    :estaciones => 'http://localhost:3025/',
    :sensores => 'http://localhost:3035/',
  }
}
