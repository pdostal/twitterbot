timestamp = require('./timestamp').timestamp
dm_send = require('./dm_send').dm_send

exports.ifError = (errors) ->
  for error, index in errors
    console.log timestamp() + "Error#{index}(#{error.code}): #{error.message}"
    dm_send '1652780346', "Error#{index}(#{error.code}): #{error.message}"
