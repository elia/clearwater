module Clearwater
  module Component
    def render
    end

    HTML_TAGS = %w(
      a
      abbr
      address
      area
      article
      aside
      audio
      b
      base
      bdi
      bdo
      blockquote
      body
      br
      button
      canvas
      caption
      cite
      code
      col
      colgroup
      command
      data
      datalist
      dd
      del
      details
      dfn
      dialog
      div
      dl
      dt
      em
      embed
      fieldset
      figcaption
      figure
      footer
      form
      h1
      h2
      h3
      h4
      h5
      h6
      head
      header
      hgroup
      hr
      html
      i
      iframe
      img
      input
      ins
      kbd
      keygen
      label
      legend
      li
      link
      map
      mark
      menu
      meta
      meter
      nav
      noscript
      object
      ol
      optgroup
      option
      output
      p
      param
      pre
      progress
      q
      rp
      rt
      ruby
      s
      samp
      script
      section
      select
      small
      source
      span
      strong
      style
      sub
      summary
      sup
      table
      tbody
      td
      textarea
      tfoot
      th
      thead
      time
      title
      tr
      track
      u
      ul
      var
      video
      wbr
    )

    HTML_TAGS.each do |tag_name|
      define_method tag_name do |attributes=nil, content=nil|
        tag(tag_name, attributes, content)
      end
    end

    def tag tag_name, attributes=nil, content=nil
      case attributes
      when Array, Component, Numeric, String
        content = attributes
        attributes = nil
      end

      Tag.new(tag_name, attributes, content)
    end

    def to_s
      html = render.to_s
      if html.respond_to? :html_safe
        html = html.html_safe
      end

      html
    end

    def outlet
    end

    def params
      router.params_for_path(router.current_path)
    end

    def param(key)
      params[key]
    end

    def call &block
    end

    class Tag
      def initialize tag_name, attributes=nil, content=nil
        @tag_name = tag_name
        @attributes = sanitize_attributes(attributes)
        @content = sanitize_content(content)
      end

      def to_html
        html = "<#{@tag_name}"
        if @attributes
          @attributes.each do |attr, value|
            html << " #{attr}=#{value.to_s.inspect}"
          end
        end
        if @content
          html << '>'
          html << html_content
          html << "</#{@tag_name}>"
        else
          html << '/>'
        end

        html
      end
      alias to_s to_html

      def html_content content=@content
        case content
        when Tag, Numeric, String, NilClass
          content.to_s
        when Array
          content.map { |c| html_content c }.join
        end
      end

      def sanitize_attributes attributes
        return attributes unless attributes.is_a? Hash

        # Allow specifying `class` instead of `class_name`.
        # Note: `class_name` is still allowed
        if attributes.key? :class_name or attributes.key? :className
          attributes[:class] ||= attributes.delete(:class_name) || attributes.delete(:className)
        end

        if Hash === attributes[:style]
          attributes[:style] = attributes[:style].map { |attr, value|
            attr = attr.to_s.tr('_', '-')
            "#{attr}:#{value}"
          }.join(';')
        end

        attributes.each do |key, handler|
          if key[0, 2] == 'on'
            attributes.delete key
          end
        end

        attributes
      end

      def sanitize_content content
        content
      end
    end
  end
end
