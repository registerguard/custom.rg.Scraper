# `custom.rg.Scraper`

## About:

"Scraper" class for [Digital Technology International](http://dtint.com/)'s [ContentPublisher](http://dtint.com/Solutions/ContentPublisher) CMS which is built on Intersystems Caché, the world's fastest high performance object database.

## Feedback:

If you improve upon this code and/or have feedback, __please__ contact me:

micky [at] registerguard (.) com.

... or [use this repo's issue tracker](https://github.com/registerguard/custom.rg.Scraper/issues).

## Thank-you's:
**Big ups** go out to [DTI](http://www.dtint.com/)'s Eric Gauthier and Joy Peterson! Thanks for the <a href="https://groups.google.com/d/topic/dti-lightning/hagUO0vUq0c/discussion">pro help</a> and <a href="https://groups.google.com/d/msg/dti-lightning/O6VSixtFeO4/8KI3g4zP3AwJ">optimization tips</a> guys!

## Basic usage:

```
#(##class(custom.rg.Scraper).scrape("baz", "www.foo.com", "cms/some/path/foo.php", 10))#
```

See [scraper.csp](https://github.com/registerguard/custom.rg.Scraper/blob/master/scraper/scraper.csp) for more examples.

## `custom_rg_Scraper` properties:

* __"name"__ _Name_ of scraping "fragment".
* __"interval"__ _Interval_ of scraping in minutes.
* __"first"__ _First_ time scraped.
* __"scraped"__ _Date/time_ of last scraping.
* __"counter"__ _Counts_ how many times scraping has been updated.
* __"scraping"__ _Contents_ of scraping.
* __"uri"__ _URI_ of scraping.

## `custom_rg_Scraper` methods:

* __"expired"__ Checks if scraping has _expired_.
* __"diff"__ _Time difference_ since last scraping to now in minutes.
* __"age"__ Time since very _first_ scraping.
* __"next"__ Time until _next_ scraping in minutes.
* __"elapsed"__ _Elapsed_ time, in minutes, since last update.

## `custom_rg_Scraper.scrape()` parameters:

* __"name"__ _(Required)_ Scraping fragment identifier.
* __"server"__ _(Required)_ The IP address or machine name of the web server that you wish to connect to.
* __"location"__ The location is the url to request, e.g. '/test.html'. This can contain parameters which are assumed to be already URL escaped.
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

## To-do list:

* ClassMethod "scrape": Validate "server" parmeter? Would probably need to account for IP addys.* Use TRY/CATCH? Not sure of best way to handle this.* What's faster/easier than [`$SYSTEM.SQL.DATEDIFF`](http://docs.intersystems.com/cache20091/csp/docbook/DocBook.UI.Page.cls?KEY=RSQL_datediff)?


## Changelog:

* v2.0.0: __2013/05/30__
	* **MAJOR FIX:** [Squashed truncation bug](https://github.com/registerguard/custom.rg.Scraper/issues/1)!
		* Removed `##class(%CSP.Page).EscapeHTML()` and `##class(%CSP.Page).UnescapeHTML()`.
	* **MAJOR FIX:** Stopped using `http.Location = location` in place of `http.Get(location)`.
		* The former would _not allow query strings_, whereas the latter does.
	* Added `while( ' http.HttpResponse.Data.AtEnd) { ... }` to make sure the response finalizes before writing it to the database.
	* Changed `stream.Read()` to `stream.Read($$$MaxLocalLength)`.
		* Using `$$$MaxLocalLength` macro to make that I can safely read all of the stream content that can fit into a string without getting a `<MAXSTRING>` error.
	* Changed `stream.SizeGet()` to `stream.Size`.
		* The former is a getter method for the `Size` property and is implicitly invoked when you access said property.
	* Updated/added repo boilerplate files.
	* Moved code to `scraper` sub-folder (keeps the primary separate from the boilerplate cruft).
	* Bumped version number.
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

---

#### LEGAL

Copyright &copy; 2013 [Micky Hulse](http://hulse.me)/[The Register-Guard](http://registerguard.com)

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this work except in compliance with the License. You may obtain a copy of the License in the LICENSE file, or at:

[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
