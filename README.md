## About:

"Scraper" class for [Digital Technology International](http://dtint.com/)'s [ContentPublisher](http://dtint.com/Solutions/ContentPublisher) CMS which is built on Intersystems Caché, the world's fastest high performance object database.

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
* __"counter"__ _Counts_ how many times scraping has been updated.
* __"scraping"__ _Contents_ of scraping.
* __"uri"__ _URI_ of scraping.

## custom_rg_Scraper methods:

* __"expired"__ Checks if scraping has _expired_.
* __"diff"__ _Time difference_ since last scraping to now in minutes.
* __"age"__ Time since very _first_ scraping.
* __"next"__ Time until _next_ scraping in minutes.
* __"elapsed"__ _Elapsed_ time, in minutes, since last update.

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

* v1.0.2: __2011/04/05__
	* Modified URI formatting for storage in table.
		* Needed to account for slash between server and location variables.
	* Cleaned up indentation of tabbed white space.
	* Slightly modified class documentation.
		* Added version number.
	* Added (more) error checking to return value from ClassMethod() scrape().
* v1.0.1: __2011/03/30__
	* Properties no longer truncate.
	* Properties that are logically required have been marked "Required".
	* Added property "counter": Counts the number of times scraping has been updated.
	* Added "age" method: Time since very first scraping.
	* Added "elapsed" method: Elapsed time, in minutes, since last update.
	* ClassMethod scrape() now depends on DTI's dtCommon.inc macros.
		* Making use of $$$ISOK(), $$$ISERR() and $$$dtThrow() macros.
		* Character stream now uses DT's global character stream class.
		* Native Cache streams are not cached on ECP servers while streams defined in dt.common.streams.* are.
		* Added/modified code, in a few spots, to check return "status".
		* Initialized vars at top of ClassMethod (I like to see what I am working with).
* v1.0.0: __2011/03/10__
	* Initial public release: Uploaded to GitHub.
