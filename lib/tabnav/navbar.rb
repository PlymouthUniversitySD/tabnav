module Tabnav
  class Navbar
    def initialize(template, params, options = {}) # :nodoc:
      @template = template
      @params = params
      @html_options = options
      @tabs = []
    end

    attr_writer :tab_content_partial

    # Creates a Tab and adds it to the navbar.
    #
    # +options+ is an option hash of options which will be used to create the +li+ for the tab.
    #
    # yields the created Tab
    def add_tab(options = {})
      options[:tab_content_partial] = @tab_content_partial if @tab_content_partial
      t = Tab.new(@template, @params, options)
      yield t
      @tabs << t
    end

    def render # :nodoc:
      return '' if @tabs.empty?
      @template.content_tag :ul, @html_options do
        contents = ''
        @tabs.each do |tab|
          contents += tab.render
        end
        contents
      end
    end
  end
end
