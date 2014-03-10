%%% @copyright (C) 2014, Imprivata
%%% @doc
%%% 
%%% @end
%%% Created :  9 Mar 2014 by Nathaniel Waisbrot <nwaisbrot@imprivata.com>
-author('nwaisbrot@imprivata.com').

-record(rss2, 
	{
	  tag
	, title
	}).

-record(attribute, {localName, prefix = [], uri = [], value}).
