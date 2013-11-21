require './app'

use Rack::Static, :urls => ['/generated/'], :root => 'public'

run Animacrazy
