module Cms
  module Attachable
    extend ActiveSupport::Concern

    class_methods do
      def attachment(name, options={})
        assoc_opts = { as: :attachable, class_name: 'Attachment', autosave: true, dependent: :destroy }
        assoc_proc = -> { where name: name }

        if options[:multiple]
          has_many :"#{name}_attachments", assoc_proc, assoc_opts
          has_many :"#{name}", through: :"#{name}_attachments", source: :medium
        else
          has_one :"#{name}_attachment", assoc_proc, assoc_opts
          has_one :"#{name}", through: :"#{name}_attachment", source: :medium

          define_method :"#{name}_id" do
            send(:"#{name}").try :id
          end

          define_method :"#{name}_id=" do |value|
            send :"#{name}=", Medium.find_by_id(value)
          end
        end
      end
    end
  end
end
