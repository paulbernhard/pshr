class ActionDispatch::Routing::Mapper

  def pshr_for(resources, **args)
    options = {}
    options[:controller] = args[:controller].blank? ? resources.to_s : args[:controller]
    options[:defaults] = {}
    options[:defaults][:resource] = args[:resource].blank? ? options[:controller].classify : args[:resource]
    options[:defaults][:format] = :json

    resources resources, controller: options[:controller],
      defaults: options[:defaults] do
        post "sort", on: :member
    end
  end
end
