module Bsm::Model::EagerDescendants
  extend ActiveSupport::Concern

  module ClassMethods

    def descendants
      eager_constantize! 
      super
    end

    private

      def eager_constantize!
        return if @__eagerly_constantized__

        load_path = $LOAD_PATH.find do |path|
          File.exist? File.join(path, "#{name.underscore}.rb")
        end
        Dir[File.join(load_path, parent_name.underscore, "**", "*.rb")].each do |file|
          ActiveSupport::Dependencies.depend_on file
        end
        @__eagerly_constantized__ = true
      end

  end unless Rails.application.config.eager_load
end