moment = require 'moment'

exports.timestamp = () ->
  moment().format 'MM. DD. YYYY hh:mm:ss '
