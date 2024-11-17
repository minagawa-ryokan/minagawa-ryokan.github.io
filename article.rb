# coding: utf-8
require "json"
require "redcarpet"

META = JSON.parse(File.read("#{ENV["MNGW_DIR"]}meta.json"))

class Render < Redcarpet::Render::HTML
  def header(content, level)
    if @not_first_header
      return "<h#{level}>#{content}</h#{level}>"
    end

    @not_first_header = true

    "<h#{level} class=\"header\">#{content}</h#{level}>"
  end

  def list(content, order)
    case order
    when :ordered
      "<ol class=\"notification\">#{content}</ol>"
    when :unordered
      "<ul class=\"gallery\">#{content}</ul>"
    end
  end

  def paragraph(content)
    if @not_first_header
      "<p>#{content}<p>"
    else
      "<nav class=\"tree\">#{content}</nav>"
    end
  end

  def link(href, title, text)
    if href.start_with?("/")
      "<a href=\"#{href}\" onclick=\"return jump(this);\">#{text}</a>"
    else
      "<a href=\"#{href}\" target=\"_blank\" rel=\"noreferrer noopener\">#{text}</a>"
    end
  end

  def image(src, title, alt)
    "<img src=\"#{src}\" alt=\"#{alt}\">"
  end
end

markdown = Redcarpet::Markdown.new(Render, autolink: true, tables: true)
html = markdown.render($<.read)
puts <<ARTICLE
<div class="target" id="#{META["id"]}"></div>
<article class="main">
#{html}
</article>
ARTICLE
