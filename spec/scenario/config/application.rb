class Bsm::Model::TestScenario < Rails::Application
  config.root = File.expand_path('../../', __FILE__)
  config.active_support.deprecation = $stderr

  def build_middleware_stack
    nil
  end
end
