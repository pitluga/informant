module Informant
  module Helpers
    def label_class_for_status(status)
      case status
      when :success then "label-success"
      when :failed then "label-important"
      else "label-warning"
      end
    end
  end
end
