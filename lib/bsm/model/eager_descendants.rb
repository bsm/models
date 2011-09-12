module Bsm::Model::EagerDescendants
  extend ActiveSupport::Concern

  module ClassMethods

    def descendants
      eager_constantize!
      super
    end

    private

      def eager_constantize!
        return if @__eagerly_constantized
        load_path = Rails.root.join("app", "models")
        matcher   = /\A#{Regexp.escape(load_path.to_s)}\/(.*)\.rb\Z/
        Dir[load_path.join(self.parent_name.underscore, "**", "*.rb")].sort.each do |file|
          require file
        end
        @__eagerly_constantized = true
      end

  end
end