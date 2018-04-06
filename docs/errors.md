# Error Pages

Dynamic 404 pages are setup through the gem and simply involves removing the
standard 404 page under ```app/public/404.html```. Slickr has a basic page
that will then be used but you can easily create your own by placing a file
at ```app/views/errors/404_error.html.erb``` (use can also use haml, slim, etc)
and that will override the standard Slickr 404 error page.

The same format can also be followed for 500 error pages although we recommend
you keep the 500.html static page already in your public directory and just
replace the styling to suit your site.
