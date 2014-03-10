%%% @copyright (C) 2014, Imprivata
%%% @doc
%%% 
%%% @end
%%% Created :  9 Mar 2014 by Nathaniel Waisbrot <nwaisbrot@imprivata.com>
-author('nwaisbrot@imprivata.com').

-record(rss, 
	{
	  title
	, link
	, description
	, language
	, copyright
	, managingEditor
	, webMaster
	, pubDate
	, lastBuildDate
	, category
	, generator
	, docs
	, cloud
	, ttl
	, image
	, rating
	, textInput
	, skipHours
	, skipDays
	, items = []
	}).
-record(item,
	{
	  title
	, link
	, description
	, author
	, category
	, comments % URL of a page for comments relating to the item.	
	, enclosure % Describes a media object that is attached to the item.	
	, guid % A string that uniquely identifies the item.	
	, pubDate % Indicates when the item was published.	
	, source % The RSS channel that the item came from
	}).

-record(image,
	{
	  title
	, url
	, link
	, width
	, height
	, description
	}).
