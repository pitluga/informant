$LOAD_PATH.unshift File.expand_path("../lib", File.dirname(__FILE__))
require 'informant'

use Rack::FiberPool
run Informant::Web
