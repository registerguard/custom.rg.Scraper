/// <p><b>Scrapes given URI and stores scraping fragment in database.</b></p>
/// <p>Developed by Micky Hulse for <a href="http://www.registerguard.com">The Register-Guard</a>.</p>
/// <p>Please visit <a href="https://github.com/mhulse/custom.rg.Scraper">GitHub</a> for more information and/or to get the latest version of this code.</p>
Class custom.rg.Scraper Extends %Persistent
{

/// <p><b>Name</b> of scraping "fragment".</p>
Property name As %String(MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// <p><b>Interval</b> of scraping in minutes.</p>
Property interval As %Integer(MAXVAL = 525600, MINVAL = 1) [ InitialExpression = 60, SqlColumnNumber = 3 ];

/// <p><b>First</b> time scraped.</p>
Property first As %TimeStamp [ InitialExpression = {$zdatetime($horolog, 3)}, SqlColumnNumber = 4 ];

/// <p><b>Date/time</b> of last scraping.</p>
Property scraped As %TimeStamp [ InitialExpression = {$zdatetime($horolog, 3)}, SqlColumnNumber = 5 ];

/// <p><b>Contents</b> of scraping.</p>
Property scraping As %Stream.GlobalCharacter [ SqlColumnNumber = 6 ];

/// <p><b>URI</b> of scraping.</p>
Property uri As %String(MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 7 ];

Index IDKEY On name [ IdKey ];

/// <p><b>Parameters:</b></p>
/// <ul>
/// <li><b>name:</b> <i>(Required)</i> Scraping fragment identifier.</li>
/// <li><b>server:</b> <i>(Required)</i> The IP address or machine name of the web server that you wish to connect to.<b>*</b></li>
/// <li><b>location:</b> Name of item to retrieve from the web server.<b>*</b></li>
/// <li><b>interval:</b> Time, in minutes, of scraping interval. <b>Default:</b> 60 minutes.</li>
/// <li><b>force:</b> Force scraping fragment update? <b>Default:</b> False (0).</li>
/// <li><b>userAgent:</b> The User-Agent request-header field contains information about the user agent originating the request.<b>*</b></li>
/// <li><b>followRedirect:</b> If true then automatically follow redirection requests from the web server. <b>Default:</b> False (0).<b>*</b></li>
/// <li><b>https:</b> If not using a proxy server and this is true then it issues a request for an https page rather than the normal http page. <b>Default:</b> False (0).<b>*</b></li>
/// <li><b>authorization:</b> Sets/get the 'Authorization:' header field in the Http request.<b>*</b></li>
/// <li><b>contentEncoding:</b> Sets/gets the 'Content-Encoding:' entity header field in the HTTP request.<b>*</b></li>
/// <li><b>contentType:</b> Sets/gets the 'Content-Type:' entity header field in the HTTP request. <b>Default:</b> "text/html".<b>*</b></li>
/// <li><b>contentCharset:</b> If the ContentType starts with 'text/' then this is the charset to encode the contents with. <b>Default:</b> UTF-8.<b>*</b></li>
/// <li><b>port:</b> The TCP/IP port number to connect to. <b>Default:</b> 80.<b>*</b></li>
/// <li><b>pragma:</b> The Pragma general-header field is used to include implementation- specific directives that may apply to any recipient along the request/response chain.<b>*</b></li>
/// </ul>
/// <p><b>*</b> See <class>%Net.HttpRequest</class> for more info.</p>
ClassMethod scrape(
	name As %String = "",
	server As %String = "",
	location As %String = "",
	interval As %Integer = 60,
	force As %Boolean = 0,
	userAgent As %String = "",
	followRedirect As %Boolean = 0,
	https As %Boolean = 0,
	authorization As %String = "",
	contentEncoding As %String = "",
	contentType As %String = "text/html",
	contentCharset As %String = "UTF-8",
	port As %Integer = 80,
	pragma As %String = "") As %String
{
	; Return string:
	set return = ""
	
	; Name/server required:
	if ($length(name) && $length(server)) {
		
		; Return object:
		set return = ##class(%Stream.GlobalCharacter).%New()
		
		; Open the Scraper object:
		set scraper = ..%OpenId(name)
		
		; IF it's not an object OR an expired object OR force is true:
		if ('$isobject(scraper) || ($isobject(scraper) && scraper.expired()) || force) {
			
			; %Net.HttpRequest stuff:
			set http = ##class(%Net.HttpRequest).%New()
			set http.Server = server
			set:($length(location)) http.Location = location // Note the location does not contain a leading '/' character as this is implicit.
			set:($length(userAgent)) http.UserAgent = userAgent
			//set:($length(params)) http.Params = params // Appears to be useless: http://tinyurl.com/4gpyvx7
			set:(followRedirect) http.FollowRedirect = followRedirect
			set:(https) http.Https = https
			set:($length(authorization)) http.Authorization = authorization
			set:($length(contentEncoding)) http.ContentEncoding = contentEncoding
			set http.ContentType = contentType
			set http.ContentCharset = contentCharset
			set http.Port = port
			set:($length(pragma)) http.Pragma = pragma
			//set:($Data()) http.XXXX = xxxxxxx
			
			; Get the request:
			do http.Get()
			
			; Was the request was fulfilled?
			if (http.HttpResponse.StatusCode = 200) {
				
				; Populate character stream:
				do return.Write(##class(%CSP.Page).EscapeHTML(http.HttpResponse.Data.Read())) // Escape overkill?
				
				; Request URI:
				set uri = $case(http.Https, 1:"https", :"http") _ "://" _ http.Server _ $case(http.Port, 80:"", :":" _ http.Port) _ $zstrip(location, "<", "/") // Should I EscapeURL too?
				
				; Updating an existing entry?
				if ($isobject(scraper)) {
					
					; Yes:
					set scraper.interval = interval
					set scraper.scraped = $zdatetime($horolog, 3)
					set scraper.uri = uri
					set scraper.scraping = return
					
				} else {
					
					; No:
					set scraper = ..%New()
					set scraper.name = name
					set scraper.interval = interval
					set scraper.uri = uri
					set scraper.scraping = return
					
				}
				
				; Save:
				do scraper.%Save()
				
			} else {
				
				; Until I can think of something better:
				do return.Write("<!-- Status code: " _ http.HttpResponse.StatusCode _ ", Reason: " _ http.HttpResponse.ReasonPhrase _ " -->")
				; Maybe return last scraping stored in DB?
				
			}
			
		} else {
			
			; Return existing entry:
			set return = scraper.scraping	
			
		}
		
		; Unescape the HTML:	
		set return = ##class(%CSP.Page).UnescapeHTML(return.Read()) // More overkill?
		
	}
	
	; Return scraping:
	quit return
}

/// <p>
/// Checks if scraping has expired.
/// <br>
/// Boolean return value.
/// </p>
Method expired() As %Integer
{
	set return = 0
	set:(##this.diff() >= ##this.interval) return = 1
	quit return
}

/// <p>Time difference since last scraping to now in minutes.</p>
Method diff() As %Integer
{
	; I am a little concerned about the speed here...
	; Would using two $horolog values be faster?
	quit $SYSTEM.SQL.DATEDIFF("mi", ##this.scraped, $horolog)
}

/// <p>Time until next scraping in minutes.</p>
Method next() As %Integer
{
	set return = ##this.interval - ##this.diff()
	set:(return <= 0) return = 0 // We don't want negative numbers.
	quit return
}

}
