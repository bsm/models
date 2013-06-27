class Bsm::Model::TestScenario < Rails::Application
  config.root = File.expand_path('../../', __FILE__)
  config.eager_load = false

  def build_middleware_stack
    nil
  end
end
