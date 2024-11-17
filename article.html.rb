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

render = Render.new
markdown = Redcarpet::Markdown.new(render, autolink: true, tables: true)

if ENV["MNGW_DIR"] == ENV["MNGW_ROOT"] then
  render.instance_eval { @not_first_header = true }
  html = markdown.render($<.read)

  puts <<ARTICLE
<article class="top">
  <div class="root">
    <h1 class="header"><a href="/" onclick="return jump(this);"><img src="/images/minagawa-ryokan-logo.png" alt="水無川旅館"></a></h1>

    <div class="entrance">
      <nav>
        <p class="navigation">
          <a href="/top" onclick="return jump(this);">CLICK HERE TO ENTER</a>
        </p>
      </nav>
    </div>

    <div class="summary">
    #{html}
    </div>

    <p class="copyright">
      © 2018 川向薫
    </p>
  </div>
</article>
ARTICLE
else
  html = markdown.render($<.read)

  puts <<ARTICLE
<div class="target" id="#{META["id"]}"></div>
<article class="main">
#{html}
</article>
ARTICLE
end
