json.html(render partial: @resource_partial, locals: { upload: @upload }, formats: [:html])
json.flash(flash.each { |k,v| json.set!(k, v) })
