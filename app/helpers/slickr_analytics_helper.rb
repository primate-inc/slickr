# frozen_string_literal: true

# Analytics helper
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
    <<~HTML.html_safe
      <!-- Google Tag Manager -->
      <script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
      new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
      j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
      'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
      })(window,document,'script','dataLayer','#{identifier}');</script>
      <!-- End Google Tag Manager -->
    HTML
  end

  def google_tag_manager_noscript(identifier)
    identifier = sanitize_id(identifier)
    <<~HTML.html_safe
      <!-- Google Tag Manager (noscript) -->
      <noscript><iframe src="https://www.googletagmanager.com/ns.html?id=#{identifier}"
      height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
      <!-- End Google Tag Manager (noscript) -->
    HTML
  end

  def sanitize_id(id)
    sanitize(id, tags: [])
  end
end
