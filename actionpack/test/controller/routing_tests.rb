# Code Generated by ZenTest v. 2.3.0
# Couldn't find class for name Routing
#                 classname: asrt / meth =  ratio%
# ActionController::Routing::RouteSet:    0 /   16 =   0.00%
# ActionController::Routing::RailsRoute:    0 /    4 =   0.00%
# ActionController::Routing::Route:    0 /    8 =   0.00%

require File.dirname(__FILE__) + '/../abstract_unit'
require 'test/unit'
require 'cgi'

class FakeController
  attr_reader :controller_path
  attr_reader :name
  def initialize(name, controller_path)
    @name = name
    @controller_path = controller_path
  end
  def kind_of?(x)
    x === Class || x == FakeController
  end
end

module Controllers
  module Admin
    UserController = FakeController.new 'Admin::UserController', 'admin/user'
    AccessController = FakeController.new 'Admin::AccessController', 'admin/access'
  end
  module Editing
    PageController = FakeController.new 'Editing::PageController', 'editing/page'
    ImageController = FakeController.new 'Editing::ImageController', 'editing/image'
  end
  module User
    NewsController = FakeController.new 'User::NewsController', 'user/news'
    PaymentController = FakeController.new 'User::PaymentController', 'user/payment'
  end
  ContentController = FakeController.new 'ContentController', 'content'
  ResourceController = FakeController.new 'ResourceController', 'resource'
end

# Extend the modules with the required methods...
[Controllers, Controllers::Admin, Controllers::Editing, Controllers::User].each do |mod|
  mod.instance_eval('alias :const_available? :const_defined?')
  mod.constants.each {|k| Object.const_set(k, mod.const_get(k))} # export the modules & controller classes.
end
  

class RouteTests < Test::Unit::TestCase
  def route(*args)
    return @route if @route && (args.empty? || @args == args)
    @args = args
    @route = ActionController::Routing::Route.new(*args)
    return @route
  end

  def setup
    self.route '/:controller/:action/:id'
    @defaults = {:controller => 'content', :action => 'show', :id => '314'}
  end
  
  # Don't put a leading / on the url.
  # Make sure the controller is one from the above fake Controllers module.
  def verify_recognize(url, expected_options, reason='')
    url = url.split('/') if url.kind_of? String
    reason = ": #{reason}" unless reason.empty?
    controller_class, options = @route.recognize(url)
    assert_not_equal nil, controller_class, "#{@route.inspect} didn't recognize #{url}#{reason}\n   #{options}"
    assert_equal expected_options, options, "#{@route.inspect} produced wrong options for #{url}#{reason}"
  end
  
  # The expected url should not have a leading /
  # You can use @defaults if you want a set of plausible defaults
  def verify_generate(expected_url, expected_extras, options, defaults, reason='')
    reason = "#{reason}: " unless reason.empty?
    components, extras = @route.generate(options, defaults)
    assert_not_equal nil, components, "#{reason}#{@route.inspect} didn't generate for \n   options = #{options.inspect}\n   defaults = #{defaults.inspect}\n   #{extras}"
    assert_equal expected_extras, extras, "#{reason} #{@route.inspect}.generate: incorrect extra's"
    assert_equal expected_url, components.join('/'), "#{reason} #{@route.inspect}.generate: incorrect url"
  end
  
  def test_recognize_default_unnested_with_action_and_id
    verify_recognize('content/action/id', {:controller => 'content', :action => 'action', :id => 'id'})
    verify_recognize('content/show/10', {:controller => 'content', :action => 'show', :id => '10'})
  end
  def test_generate_default_unnested_with_action_and_id_no_extras
    verify_generate('content/action/id', {}, {:controller => 'content', :action => 'action', :id => 'id'}, @defaults)
    verify_generate('content/show/10', {}, {:controller => 'content', :action => 'show', :id => '10'}, @defaults)
  end
  def test_generate_default_unnested_with_action_and_id
    verify_generate('content/action/id', {:a => 'a'}, {:controller => 'content', :action => 'action', :id => 'id', :a => 'a'}, @defaults)
    verify_generate('content/show/10', {:a => 'a'}, {:controller => 'content', :action => 'show', :id => '10', :a => 'a'}, @defaults)
  end
  
  # Note that we can't put tests here for proper relative controller handline
  # because that is handled by RouteSet.
  def test_recognize_default_nested_with_action_and_id
    verify_recognize('admin/user/action/id', {:controller => 'admin/user', :action => 'action', :id => 'id'})
    verify_recognize('admin/user/show/10', {:controller => 'admin/user', :action => 'show', :id => '10'})
  end
  def test_generate_default_nested_with_action_and_id_no_extras
    verify_generate('admin/user/action/id', {}, {:controller => 'admin/user', :action => 'action', :id => 'id'}, @defaults)
    verify_generate('admin/user/show/10', {}, {:controller => 'admin/user', :action => 'show', :id => '10'}, @defaults)
  end
  def test_generate_default_nested_with_action_and_id_relative_to_root
    verify_generate('admin/user/action/id', {:a => 'a'}, {:controller => 'admin/user', :action => 'action', :id => 'id', :a => 'a'}, @defaults)
    verify_generate('admin/user/show/10', {:a => 'a'}, {:controller => 'admin/user', :action => 'show', :id => '10', :a => 'a'}, @defaults)
  end
  
  def test_recognize_default_nested_with_action
    verify_recognize('admin/user/action', {:controller => 'admin/user', :action => 'action'})
    verify_recognize('admin/user/show', {:controller => 'admin/user', :action => 'show'})
  end
  def test_generate_default_nested_with_action_no_extras
    verify_generate('admin/user/action', {}, {:controller => 'admin/user', :action => 'action'}, @defaults)
    verify_generate('admin/user/show', {}, {:controller => 'admin/user', :action => 'show'}, @defaults)
  end
  def test_generate_default_nested_with_action
    verify_generate('admin/user/action', {:a => 'a'}, {:controller => 'admin/user', :action => 'action', :a => 'a'}, @defaults)
    verify_generate('admin/user/show', {:a => 'a'}, {:controller => 'admin/user', :action => 'show', :a => 'a'}, @defaults)
  end

  def test_recognize_default_nested_with_id_and_index
    verify_recognize('admin/user/index/hello', {:controller => 'admin/user', :id => 'hello', :action => 'index'})
    verify_recognize('admin/user/index/10', {:controller => 'admin/user', :id => "10", :action => 'index'})
  end
  def test_generate_default_nested_with_id_no_extras
    verify_generate('admin/user/index/hello', {}, {:controller => 'admin/user', :id => 'hello'}, @defaults)
    verify_generate('admin/user/index/10', {}, {:controller => 'admin/user', :id => 10}, @defaults)
  end
  def test_generate_default_nested_with_id
    verify_generate('admin/user/index/hello', {:a => 'a'}, {:controller => 'admin/user', :id => 'hello', :a => 'a'}, @defaults)
    verify_generate('admin/user/index/10', {:a => 'a'}, {:controller => 'admin/user', :id => 10, :a => 'a'}, @defaults)
  end
  
  def test_recognize_default_nested
    verify_recognize('admin/user', {:controller => 'admin/user', :action => 'index'})
    verify_recognize('admin/user', {:controller => 'admin/user', :action => 'index'})
  end
  def test_generate_default_nested_no_extras
    verify_generate('admin/user', {}, {:controller => 'admin/user'}, @defaults)
    verify_generate('admin/user', {}, {:controller => 'admin/user'}, @defaults)
  end
  def test_generate_default_nested
    verify_generate('admin/user', {:a => 'a'}, {:controller => 'admin/user', :a => 'a'}, @defaults)
    verify_generate('admin/user', {:a => 'a'}, {:controller => 'admin/user', :a => 'a'}, @defaults)
  end
  
  # Test generate with a default controller set.
  def test_generate_default_controller
    route '/:controller/:action/:id', :action => 'index', :id => nil, :controller => 'content'
    @defaults[:controller] = 'resource'
    
    verify_generate('', {}, {:controller => 'content'}, @defaults)
    verify_generate('', {}, {:controller => 'content', :action => 'index'}, @defaults)
    verify_generate('content/not-index', {}, {:controller => 'content', :action => 'not-index'}, @defaults)
    verify_generate('content/index/10', {}, {:controller => 'content', :id => 10}, @defaults)
    verify_generate('content/index/hi', {}, {:controller => 'content', :action => 'index', :id => 'hi'}, @defaults)
    verify_generate('', {:a => 'a'}, {:controller => 'content', :a => 'a'}, @defaults)
    verify_generate('', {:a => 'a'}, {:controller => 'content', :a => 'a'}, @defaults)
    
    # Call some other generator tests
    test_generate_default_unnested_with_action_and_id
    test_generate_default_nested_with_action_and_id_no_extras
    test_generate_default_nested_with_id
    test_generate_default_nested_with_id_no_extras
  end

  # Test generate with a default controller set.
  def test_generate_default_controller
    route '/:controller/:action/:id', :action => 'index', :id => nil, :controller => 'content'
    @defaults[:controller] = 'resource'
    verify_recognize('', {:controller => 'content', :action => 'index'})
    verify_recognize('content', {:controller => 'content', :action => 'index'})
    verify_recognize('content/index', {:controller => 'content', :action => 'index'})
    verify_recognize('content/index/10', {:controller => 'content', :action => 'index', :id => '10'})
  end
    # Make sure generation & recognition don't happen in some cases:
  def test_no_generate_on_no_options
    assert_equal nil, @route.generate({}, {})[0]
  end
  def test_requirements
    route 'some_static/route', :controller => 'content'
    assert_equal nil, @route.generate({}, {})[0]
    assert_equal nil, @route.generate({:controller => "dog"}, {})[0]
    assert_equal nil, @route.recognize([])[0]
    assert_equal nil, @route.recognize(%w{some_static route with more than expected})[0]
  end
  
  def test_basecamp
    route 'clients/', :controller => 'content'
    verify_generate('clients', {}, {:controller => 'content'}, {}) # Would like to have clients/
    verify_generate('clients', {}, {:controller => 'content'}, @defaults)
  end

  def test_regexp_requirements
    const_options = {:controller => 'content', :action => 'by_date'}
    route ':year/:month/:day', const_options.merge(:year => /\d{4}/, :month => /\d{1,2}/, :day => /\d{1,2}/)
    verify_recognize('2004/01/02', const_options.merge(:year => '2004', :month => '01', :day => '02'))
    verify_recognize('2004/1/2', const_options.merge(:year => '2004', :month => '1', :day => '2'))
    assert_equal nil, @route.recognize(%w{200 10 10})[0]
    assert_equal nil, @route.recognize(%w{content show 10})[0]
    
    verify_generate('2004/01/02', {}, const_options.merge(:year => '2004', :month => '01', :day => '02'), @defaults)
    verify_generate('2004/1/2', {}, const_options.merge(:year => '2004', :month => '1', :day => '2'), @defaults)
    assert_equal nil, @route.generate(const_options.merge(:year => '12004', :month => '01', :day => '02'), @defaults)[0]
  end
  
  def test_regexp_requirement_not_in_path
    assert_raises(ArgumentError) {route 'constant/path', :controller => 'content', :action => 'by_date', :something => /\d+/}
  end
  
  def test_special_hash_names
  	route ':year/:name', :requirements => {:year => /\d{4}/, :controller => 'content'}, :defaults => {:name => 'ulysses'}, :action => 'show_bio_year'
  	verify_generate('1984', {}, {:controller => 'content', :action => 'show_bio_year', :year => 1984}, @defaults)
  	verify_generate('1984', {}, {:controller => 'content', :action => 'show_bio_year', :year => '1984'}, @defaults)
  	verify_generate('1984/odessys', {}, {:controller => 'content', :action => 'show_bio_year', :year => 1984, :name => 'odessys'}, @defaults)
  	verify_generate('1984/odessys', {}, {:controller => 'content', :action => 'show_bio_year', :year => '1984', :name => 'odessys'}, @defaults)
  
    verify_recognize('1984/odessys', {:controller => 'content', :action => 'show_bio_year', :year => '1984', :name => 'odessys'})
    verify_recognize('1984', {:controller => 'content', :action => 'show_bio_year', :year => '1984', :name => 'ulysses'})
  end
  
  def test_defaults_and_restrictions_for_items_not_in_path
    assert_raises(ArgumentError) {route ':year/:name', :requirements => {:year => /\d{4}/}, :defaults => {:name => 'ulysses', :controller => 'content'}, :action => 'show_bio_year'}
    assert_raises(ArgumentError) {route ':year/:name', :requirements => {:year => /\d{4}/, :imagine => /./}, :defaults => {:name => 'ulysses'}, :controller => 'content', :action => 'show_bio_year'}
  end
  
  def test_optionals_with_regexp
    route ':year/:month/:day', :requirements => {:year => /\d{4}/, :month => /\d{1,2}/, :day => /\d{1,2}/},
                               :defaults => {:month => nil, :day => nil},
                               :controller => 'content', :action => 'post_by_day'
    verify_recognize('2005/06/12', {:controller => 'content', :action => 'post_by_day', :year => '2005', :month => '06', :day => '12'})
    verify_recognize('2005/06', {:controller => 'content', :action => 'post_by_day', :year => '2005', :month => '06'})
    verify_recognize('2005', {:controller => 'content', :action => 'post_by_day', :year => '2005'})
    
    verify_generate('2005/06/12', {}, {:controller => 'content', :action => 'post_by_day', :year => '2005', :month => '06', :day => '12'}, @defaults)
    verify_generate('2005/06', {}, {:controller => 'content', :action => 'post_by_day', :year => '2005', :month => '06'}, @defaults)
    verify_generate('2005', {}, {:controller => 'content', :action => 'post_by_day', :year => '2005'}, @defaults)
  end
  

  def test_basecamp2
    route 'clients/:client_name/:project_name/', :controller => 'content', :action => 'start_page_redirect'
    verify_recognize('clients/projects/2', {:controller => 'content', :client_name => 'projects', :project_name => '2', :action => 'start_page_redirect'})
  end
  
  def test_xal_style_dates
    route 'articles/:category/:year/:month/:day', :controller => 'content', :action => 'list_articles', :category => 'all', :year => nil, :month => nil, :day =>nil
    verify_recognize('articles', {:controller => 'content', :action => 'list_articles', :category => 'all'})
    verify_recognize('articles/porn', {:controller => 'content', :action => 'list_articles', :category => 'porn'})
    verify_recognize('articles/news/2005/08', {:controller => 'content', :action => 'list_articles', :category => 'news', :year => '2005', :month => '08'})
    verify_recognize('articles/news/2005/08/04', {:controller => 'content', :action => 'list_articles', :category => 'news', :year => '2005', :month => '08', :day => '04'})
    assert_equal nil, @route.recognize(%w{articles too many components are here})[0]
    assert_equal nil, @route.recognize('')[0]
    
    verify_generate('articles', {}, {:controller => 'content', :action => 'list_articles'}, @defaults)
    verify_generate('articles', {}, {:controller => 'content', :action => 'list_articles', :category => 'all'}, @defaults)
    verify_generate('articles/news', {}, {:controller => 'content', :action => 'list_articles', :category => 'news'}, @defaults)
    verify_generate('articles/news/2005', {}, {:controller => 'content', :action => 'list_articles', :category => 'news', :year => '2005'}, @defaults)
    verify_generate('articles/news/2005/05', {}, {:controller => 'content', :action => 'list_articles', :category => 'news', :year => '2005', :month => '05'}, @defaults)
    verify_generate('articles/news/2005/05/16', {}, {:controller => 'content', :action => 'list_articles', :category => 'news', :year => '2005', :month => '05', :day => '16'}, @defaults)

    assert_equal nil, @route.generate({:controller => 'content', :action => 'list_articles', :day => '2'}, @defaults)[0]
    # The above case should fail because a nil value cannot be present in a path.
    # In other words, since :day is given, :month and :year must be given too.
  end
  
  
  def test_no_controller
    route 'some/:special/:route', :controller => 'a/missing/controller', :action => 'anything'
    assert_raises(ActionController::RoutingError, "Should raise due to nonexistant controller") {@route.recognize(%w{some matching path})}
  end
  def test_bad_controller_path
    assert_equal nil, @route.recognize(%w{no such controller fake_action id})[0]
  end
  def test_too_short_path
    assert_equal nil, @route.recognize([])[0]
    route 'some/static/route', :controller => 'content', :action => 'show'
    assert_equal nil, route.recognize([])[0]
  end
  def test_too_long_path
    assert_equal nil, @route.recognize(%w{content action id some extra components})[0]
  end
  def test_incorrect_static_component
    route 'some/static/route', :controller => 'content', :action => 'show'
    assert_equal nil, route.recognize(%w{an non_matching path})[0]
  end
  def test_no_controller_defined
    route 'some/:path/:without/a/controller'
    assert_equal nil, route.recognize(%w{some matching path a controller})[0]
  end
  
  def test_mismatching_requirements
    route 'some/path', :controller => 'content', :action => 'fish'
    assert_equal nil, route.generate({:controller => 'admin/user', :action => 'list'})[0]
    assert_equal nil, route.generate({:controller => 'content', :action => 'list'})[0]
    assert_equal nil, route.generate({:controller => 'admin/user', :action => 'fish'})[0]
  end
  
  def test_missing_value_for_generate
    assert_equal nil, route.generate({})[0] # :controller is missing
  end
  def test_nils_inside_generated_path
    route 'show/:year/:month/:day', :month => nil, :day => nil, :controller => 'content', :action => 'by_date'
    assert_equal nil, route.generate({:year => 2005, :day => 10})[0]
  end
  
  def test_expand_controller_path_non_nested_no_leftover
    controller, leftovers = @route.send :eat_path_to_controller, %w{content}
    assert_equal Controllers::ContentController, controller
    assert_equal [], leftovers
  end
  def test_expand_controller_path_non_nested_with_leftover
    controller, leftovers = @route.send :eat_path_to_controller, %w{content action id}
    assert_equal Controllers::ContentController, controller
    assert_equal %w{action id}, leftovers
  end
  def test_expand_controller_path_nested_no_leftover
    controller, leftovers = @route.send :eat_path_to_controller, %w{admin user}
    assert_equal Controllers::Admin::UserController, controller
    assert_equal [], leftovers
  end
  def test_expand_controller_path_nested_no_leftover
    controller, leftovers = @route.send :eat_path_to_controller, %w{admin user action id}
    assert_equal Controllers::Admin::UserController, controller
    assert_equal %w{action id}, leftovers
  end

  def test_path_collection
    route '*path_info', :controller => 'content', :action => 'fish'
    verify_recognize'path/with/slashes',
        :controller => 'content', :action => 'fish', :path_info => 'path/with/slashes'
    verify_generate('path/with/slashes', {},
	{:controller => 'content', :action => 'fish', :path_info => 'path/with/slashes'},
	{})
  end
  
  def test_special_characters
    route ':id', :controller => 'content', :action => 'fish'
    verify_recognize'id+with+spaces',
        :controller => 'content', :action => 'fish', :id => 'id with spaces'
    verify_generate('id+with+spaces', {},
        {:controller => 'content', :action => 'fish', :id => 'id with spaces'}, {})
    verify_recognize 'id%2Fwith%2Fslashes',
        :controller => 'content', :action => 'fish', :id => 'id/with/slashes'
    verify_generate('id%2Fwith%2Fslashes', {},
        {:controller => 'content', :action => 'fish', :id => 'id/with/slashes'}, {})
  end

  def test_generate_with_numeric_param
    o = Object.new
    def o.to_param() 10 end
    verify_generate('content/action/10', {}, {:controller => 'content', :action => 'action', :id => o}, @defaults)
    verify_generate('content/show/10', {}, {:controller => 'content', :action => 'show', :id => o}, @defaults)
  end
end

class RouteSetTests < Test::Unit::TestCase
  def setup
    @set = ActionController::Routing::RouteSet.new
    @rails_route = ActionController::Routing::Route.new '/:controller/:action/:id', :action => 'index', :id => nil
    @request = ActionController::TestRequest.new({}, {}, nil)
  end
  def test_emptyness
    assert_equal true, @set.empty?, "New RouteSets should respond to empty? with true."
    @set.each { flunk "New RouteSets should be empty." }
  end
  def test_add_illegal_route
    assert_raises(TypeError) {@set.add_route "I'm not actually a route."}
  end
  def test_add_normal_route
    @set.add_route @rails_route
    seen = false
    @set.each do |route|
      assert_equal @rails_route, route
      flunk("Each should have yielded only a single route!") if seen
      seen = true
    end
  end
  
  def test_expand_controller_path_non_relative
    defaults = {:controller => 'admin/user', :action => 'list'}
    options = {:controller => '/content'}
    @set.expand_controller_path!(options, defaults)
    assert_equal({:controller => 'content'}, options)
  end
  def test_expand_controller_path_relative_to_nested
    defaults = {:controller => 'admin/user', :action => 'list'}
    options = {:controller => 'access'}
    @set.expand_controller_path!(options, defaults)
    assert_equal({:controller => 'admin/access'}, options)
  end
  def test_expand_controller_path_relative_to_root
    defaults = {:controller => 'content', :action => 'list'}
    options = {:controller => 'resource'}
    @set.expand_controller_path!(options, defaults)
    assert_equal({:controller => 'resource'}, options)
  end
  def test_expand_controller_path_into_module
    defaults = {:controller => 'content', :action => 'list'}
    options = {:controller => 'admin/user'}
    @set.expand_controller_path!(options, defaults)
    assert_equal({:controller => 'admin/user'}, options)
  end
  def test_expand_controller_path_switch_module_with_absolute
    defaults = {:controller => 'user/news', :action => 'list'}
    options = {:controller => '/admin/user'}
    @set.expand_controller_path!(options, defaults)
    assert_equal({:controller => 'admin/user'}, options)
  end
  def test_expand_controller_no_default
    options = {:controller => 'content'}
    @set.expand_controller_path!(options, {})
    assert_equal({:controller => 'content'}, options)
  end
  
  # Don't put a leading / on the url.
  # Make sure the controller is one from the above fake Controllers module.
  def verify_recognize(expected_controller, expected_path_parameters=nil, path=nil)
    @set.add_route(@rails_route) if @set.empty?
    @request.path = path if path
    controller = @set.recognize!(@request)
    assert_equal expected_controller, controller
    assert_equal expected_path_parameters, @request.path_parameters if expected_path_parameters
  end
  
  # The expected url should not have a leading /
  # You can use @defaults if you want a set of plausible defaults
  def verify_generate(expected_url, options, expected_extras={})
    @set.add_route(@rails_route) if @set.empty?
    components, extras = @set.generate(options, @request)
    assert_equal expected_extras, extras, "#incorrect extra's"
    assert_equal expected_url, components.join('/'), "incorrect url"
  end
  def typical_request
    @request.path_parameters = {:controller => 'content', :action => 'show', :id => '10'}
  end
  def typical_nested_request
    @request.path_parameters = {:controller => 'admin/user', :action => 'grant', :id => '02seckar'}
  end
  
  def test_generate_typical_controller_action_path
    typical_request
    verify_generate('content/list', {:controller => 'content', :action => 'list'})
  end
  def test_generate_typical_controller_index_path_explicit_index
    typical_request
    verify_generate('content', {:controller => 'content', :action => 'index'})
  end
  def test_generate_typical_controller_index_path_explicit_index
    typical_request
    verify_generate('content', {:controller => 'content', :action => 'index'})
  end
  def test_generate_typical_controller_index_path_implicit_index
    typical_request
    @request.path_parameters[:controller] = 'resource'
    verify_generate('content', {:controller => 'content'})
  end
  
  def test_generate_no_perfect_route
    typical_request
    verify_generate('admin/user/show/43seckar', {:controller => 'admin/user', :action => 'show', :id => '43seckar', :likes_fishing => 'fuzzy(0.3)'}, {:likes_fishing => 'fuzzy(0.3)'})
  end
  
  def test_generate_no_match
    @set.add_route(@rails_route)
    @request.path_parameters = {}
    assert_raises(ActionController::RoutingError) {@set.generate({}, @request)}
  end
  
  def test_encoded_strings
    verify_recognize(Controllers::Admin::UserController, {:controller => 'admin/user', :action => 'info', :id => "Nicholas Seckar"}, path='/admin/user/info/Nicholas%20Seckar')
  end
  
  def test_action_dropped_when_controller_changes
    @request.path_parameters = {:controller => 'content', :action => 'list'}
    options = {:controller => 'resource'}
    @set.connect ':action/:controller'
    verify_generate('index/resource', options)
  end

  def test_action_dropped_when_controller_given
    @request.path_parameters = {:controller => 'content', :action => 'list'}
    options = {:controller => 'content'}
    @set.connect ':action/:controller'
    verify_generate('index/content', options)
  end
  
  def test_default_dropped_with_nil_option
    @request.path_parameters = {:controller => 'content', :action => 'action', :id => '10'}
    verify_generate 'content/action', {:id => nil}
  end

  def test_url_to_self
    @request.path_parameters = {:controller => 'admin/users', :action => 'index'}
    verify_generate 'admin/users', {}
  end

  def test_url_with_spaces_in_controller
    @request.path = 'not%20a%20valid/controller/name'
    @set.add_route(@rails_route) if @set.empty?
    assert_raises(ActionController::RoutingError) {@set.recognize!(@request)}
  end
  def test_url_with_dots_in_controller
    @request.path = 'not.valid/controller/name'
    @set.add_route(@rails_route) if @set.empty?
    assert_raises(ActionController::RoutingError) {@set.recognize!(@request)}
  end

  def test_generate_of_empty_url
    @set.connect '', :controller => 'content', :action => 'view', :id => "1"
    @set.add_route(@rails_route)
    verify_generate('content/view/2', {:controller => 'content', :action => 'view', :id => 2})
    verify_generate('', {:controller => 'content', :action => 'view', :id => 1})
  end
  def test_generate_of_empty_url_with_numeric_requirement
    @set.connect '', :controller => 'content', :action => 'view', :id => 1
    @set.add_route(@rails_route)
    verify_generate('content/view/2', {:controller => 'content', :action => 'view', :id => 2})
    verify_generate('', {:controller => 'content', :action => 'view', :id => 1})
  end
end

#require '../assertions/action_pack_assertions.rb'
class AssertionRoutingTests < Test::Unit::TestCase
  def test_assert_routing
    ActionController::Routing::Routes.reload rescue nil
    assert_routing('content', {:controller => 'content', :action => 'index'})
  end
end
