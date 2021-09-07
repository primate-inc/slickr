# frozen_string_literal: true

module SlickrAnalyticsHelper
  def google_analytics_script(identifier)
    identifier = sanitize_id(identifier)
    <<-HTML.html_safe
    <script>
      (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
      (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
      m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
      })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');
      ga('create', '#{identifier}', 'auto');
      ga('send', 'pageview');
    </script>
    HTML
  end

  def google_tag_manager_script(identifier)
    identifier = sanitize_id(identifier)
    <<-HTML.html_safe
    <script async src='https://www.googletagmanager.com/gtag/js?id=#{identifier}'></script>
    <script>window.dataLayer = window.dataLayer || [];function gtag(){dataLayer.push(arguments);}gtag('js', new Date());gtag('config', '#{identifier}');</script>
    HTML
  end

  def sanitize_id(id)
    sanitize(id, tags: [])
  end
end
