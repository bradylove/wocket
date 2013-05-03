module Wocket
  class StatusCode
    class << self
      def normal_closure
        hash_with_details(1000, "normal closure")
      end

      def going_away
        hash_with_details(1001, "going away")
      end

      def protocol_error
        hash_with_details(1002, "protocol error")
      end

      def invalid_data
        hash_with_details(1003, "invalid data")
      end

      def inconsistent_data
        hash_with_details(1007, "inconsistent data")
      end

      def policy_violation
        hash_with_details(1008, "policy violation")
      end

      def too_large
        hash_with_details(1009, "too large")
      end

      def extention_error
        hash_with_details(1010, "extention error")
      end

      def unexpected_condition
        hash_with_details(1011, "unexpected condition")
      end

    private

      def hash_with_details(code, description)
        { code: code,
          description: description }
      end
    end
  end
end
