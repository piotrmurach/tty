# -*- encoding: utf-8 -*-

module TTY
  class Shell
    module ResponseDelegation
      extend TTY::Delegatable

      delegatable_method :dispatch, :read

      delegatable_method :dispatch, :read_string

      delegatable_method :dispatch, :read_char

      delegatable_method :dispatch, :read_text

      delegatable_method :dispatch, :read_symbol

      delegatable_method :dispatch, :read_choice

      delegatable_method :dispatch, :read_int

      delegatable_method :dispatch, :read_float

      delegatable_method :dispatch, :read_regex

      delegatable_method :dispatch, :read_range

      delegatable_method :dispatch, :read_date

      delegatable_method :dispatch, :read_datetime

      delegatable_method :dispatch, :read_bool

      delegatable_method :dispatch, :read_file

      delegatable_method :dispatch, :read_email

      delegatable_method :dispatch, :read_multiple

      delegatable_method :dispatch, :read_password

      delegatable_method :dispatch, :read_keypress

      # Create response instance when question readed is invoked
      #
      # @param [TTY::Shell::Response] response
      #
      # @api private
      def dispatch(response = Response.new(self, shell))
        @response ||= response
      end

    end # ResponseDelegation
  end # Shell
end # TTY
