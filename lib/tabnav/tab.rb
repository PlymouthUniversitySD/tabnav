module Tabnav
  class Tab

    def initialize(template, params, html_options = {}) # :nodoc:
      @html_options = html_options
      @params = params
      @template = template
      @name = ''
      @active = false
    end

    attr_accessor :name, :link_url, :link_options

    # Sets the name of this tab.  This will be used as the contents of the link or span
    def named(text)
      @name = text
    end

    # Sets the link destination.
    #
    # +link_options+ is an option hash of options that will be
    # passed through to the link_to call.
    def links_to(url, link_options = {})
      @link_url = url
      @link_options = link_options
    end

    # Adds a highlight condition to this tab.  +rule+ can be one of the following:
    #
    # * A Hash: The tab will be highlighted if all the values in the given hash match the
    #   params hash (strings and symbols are treated as equivelent).
    # * A Proc: The proc will be called, and the tab will be highlighted if it returns true.
    #
    # If multiple highlight conditions are given, the tab will be highlighted if any of them match.
    def highlights_on(rule)
      if rule.is_a?(Hash)
        @active |= rule.with_indifferent_access.all? {|k, v| @params[k] == v.to_s}
      elsif rule.is_a?(Proc)
        @active |= rule.call
      end
    end

    # Returns +true+ of this tab is highlighted.
    def active?
      @active
    end

    def render # :nodoc:
      @html_options[:class] = "#{@html_options[:class]} active".strip if self.active?
      partial = @html_options.delete(:tab_content_partial)
      @template.content_tag(:li, @html_options) do
        if partial
          @template.render :partial => partial, :locals => {:tab => self}
        elsif @link_url
          @template.link_to @name, @link_url, @link_options
        else
          @template.content_tag :span, @name
        end
      end
    end
  end
end