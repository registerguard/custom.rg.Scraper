## About:

"Scraper" class for class for Intersystems Caché.

If you imporve upon this code and/or have feedback, __please__ contact me:

micky (.) hulse [at] registerguard (.) com.

## Basic usage:

    #(##class(custom.rg.Scraper).scrape("baz", "www.foo.com", "cms/some/path/foo.php", 10))#

See scraper.csp for more examples.

## custom_rg_Scraper properties:

* __"name"__ _Name_ of scraping "fragment".
* __"interval"__ _Interval_ of scraping in minutes.
* __"first"__ _First_ time scraped.
* __"scraped"__ _Date/time_ of last scraping.
* __"scraping"__ _Contents_ of scraping.
* __"uri"__ _URI_ of scraping.

## custom_rg_Scraper.scrape() parameters:

* __"name"__ _(Required)_ Scraping fragment identifier.
* __"server"__ _(Required)_ The IP address or machine name of the web server that you wish to connect to.
* __"location"__ Name of item to retrieve from the web server.
* __"interval"__ Time, in minutes, of scraping interval. __Default:__ 60 minutes.
* __"force"__ Force scraping fragment update? __Default:__ False (0).
* __"userAgent"__ The User-Agent request-header field contains information about the user agent originating the request.
* __"followRedirect"__ If true then automatically follow redirection requests from the web server. __Default:__ False (0).
* __"https"__ If not using a proxy server and this is true then it issues a request for an https page rather than the normal http page. __Default:__ False (0).
* __"authorization"__ Sets/get the 'Authorization:' header field in the Http request.
* __"contentEncoding"__ Sets/gets the 'Content-Encoding:' entity header field in the HTTP request.
* __"contentType"__ Sets/gets the 'Content-Type:' entity header field in the HTTP request. __Default:__ "text/html".
* __"contentCharset"__ If the ContentType starts with 'text/' then this is the charset to encode the contents with. __Default:__ UTF-8.
* __"port"__ The TCP/IP port number to connect to. __Default:__ 80.
* __"pragma"__ The Pragma general-header field is used to include implementation- specific directives that may apply to any recipient along the request/response chain.

-----

## Changelog:

* __2011/03/10__
	* Initial public release: Uploaded to GitHub.
