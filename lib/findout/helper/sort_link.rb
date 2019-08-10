module Findout
  module Helper
    class SortLink
      def initialize(name, sort)
        @name = name
        @sort = normalize(sort)
      end

      def build(options, html_options)
        options = options.symbolize_keys
        html_options = html_options.symbolize_keys

        keys = @sort.map { |s| s.keys.first }
        opt_keys = options.to_a.map(&:first)

        if keys.present? && keys == opt_keys
          set_options!(options, html_options)
        end

        return wrap(options), html_options
      end

      private

      def normalize(sort)
        case sort
        when Array
          sort.flat_map { |s| normalize(s) }
        when Hash
          sort.map { |key, dir| { key => dir } }
        end
      end

      def set_options!(options, html_options)
        order = current_order(options)
        add_css_class!(options, html_options, order)
        reverse!(options) if order == :normal
      end

      def current_order(options)
        dirs = @sort.map { |s| s.values.first.to_sym }
        opt_dirs = options.to_a.map { |a| a.second.to_sym }

        dirs == opt_dirs ? :normal : :reverse
      end

      def current_dir(options, order)
        dir = options.first.second
        if order == :normal
          dir
        else
          reverse_dir(dir)
        end
      end

      def add_css_class!(options, html_options, order)
        dir = current_dir(options, order)
        html_options[:class] = "#{html_options[:class]} #{sort_class(dir)}"
        html_options[:class].strip!
      end

      def sort_class(dir)
        Config.sort_class[dir]
      end

      def reverse!(options)
        options.each do |key, val|
          options[key] = reverse_dir(val)
        end
      end

      def reverse_dir(dir)
        case dir
        when :asc
          :desc
        when :desc
          :asc
        end
      end

      def wrap(options)
        options.each_with_object([]) do |(k, v), array|
          array << { k => v }
        end
      end
    end
  end
end
