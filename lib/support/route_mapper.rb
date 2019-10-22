require 'action_dispatch/routing/mapper'
#require 'action_dispatch/routing/deprecated_mapper'
require 'rails'
# For use with 'Edge Rails'
ActionDispatch::Routing::Mapper.class_eval do

  # For mounting a page to a path
  def comatose_root( path, options={} )
    opts = {
      :index      => '',
      :layout     => 'comatose_content.html.erb',
      :use_cache  => 'true',
      :cache_path => nil,
      :named_route=> nil
    }.merge(options)

    # Ensure the controller is aware of the mount point...
    Comatose.add_mount_point(path, opts)
    # Add the route...
    opts[:controller] = 'comatose'
    opts[:action] ='show'
    opts[:as] = opts.delete(:named_route)
		opts[:cache] = "true"
    opts[:request_method] = "get"
    opts[:via] = :get
    if opts[:index] == '' # if it maps to the root site URI, name it comatose_root
      #named_route( 'comatose_root', "#{path}/*page", opts )
      opts[:as] = "comatose_root"
      #match( "#{path}/*page", opts, "compatose_rout" )
      match( "/(*page)", opts )
    else
      match( "#{path}/*page", opts )
    end
   end

  # For mounting the admin
  def comatose_admin( path='comatose_admin', options={} )
    opts = {
      :controller  => 'comatose_admin',
      :named_route => 'comatose_admin'
    }.merge(options)
    opts[:as] = opts.delete(:named_route)
    opts[:request_method] = :get
    opts[:via] = :get
    match("comatose_admin(/:action(/:id))", opts )
  end
end


