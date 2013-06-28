class Bsm::Model::TestScenario < Rails::Application
  config.root = File.expand_path('../../', __FILE__)
  config.eager_load = false if config.respond_to?(:eager_load=)

  def build_middleware_stack
    nil
  end
end
