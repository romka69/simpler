require_relative 'lib/middleware/app_logger'
require_relative 'config/environment'

use AppLogger
run Simpler.application
