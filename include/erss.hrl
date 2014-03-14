%%% @copyright (C) 2014, Nathaniel Waisbrot
%%% @doc
%%% 
%%% @end
%%% Created :  9 Mar 2014 by Nathaniel Waisbrot <code@waisbrot.net>
-author('code@waisbrot.net').

-record(item,
	{
	  title		:: iodata()
	, link		:: iodata()
	, description	:: iodata()
	, author	:: iodata()
	, category	:: iodata()
	, comments	:: iodata() % URL of a page for comments relating to the item.
	, enclosure	:: iodata() % Describes a media object that is attached to the item.
	, guid		:: iodata() % A string that uniquely identifies the item.
	, pubdate	:: iodata() % Indicates when the item was published.
	, source	:: iodata() % The RSS channel that the item came from
	}).

-record(image,
	{
	  title		:: iodata()
	, url		:: iodata()
	, link		:: iodata()
	, width		:: iodata()
	, height	:: iodata()
	, description	:: iodata()
	}).

-record(rss,
	{
	  title		:: iodata()
	, link		:: iodata()
	, description	:: iodata()
	, language	:: iodata()
	, copyright	:: iodata()
	, managingeditor:: iodata()
	, webmaster	:: iodata()
	, pubdate	:: iodata()
	, lastbuilddate	:: iodata()
	, category	:: iodata()
	, generator	:: iodata()
	, docs		:: iodata()
	, cloud		:: iodata()
	, ttl		:: iodata()
	, image		:: #image{}
	, rating	:: iodata()
	, textinput	:: iodata()
	, skiphours	:: iodata()
	, skipdays	:: iodata()
	, items = []	:: [#item{},...]
	}).
