require './app'

use Rack::Static, :urls => ['/images/', '/generated/'], :root => 'public'

run Gifitup
