%%% @copyright (C) 2014, Imprivata
%%% @doc
%%% 
%%% @end
%%% Created :  9 Mar 2014 by Nathaniel Waisbrot <nwaisbrot@imprivata.com>
-module(erss_rss).
-author('nwaisbrot@imprivata.com').

-export([handle_sax/2]).
-include("erss.hrl").

-define(CHANNEL(Tag), 
	handle_sax({startElement, _Uri, Tag, _Prefix, _Attrs}, State = #rss2{tag = "channel"}) ->
	       State#rss2{tag = Tag}
       ;handle_sax({endElement, _Uri, Tag, _Prefix}, State = #rss2{tag = Tag}) ->
	       State#rss2{tag = "channel"}
       ;handle_sax({characters, Chars}, State = #rss2{tag = Tag}) ->
	       Key = list_to_atom(Tag),
	       State#rss2{Key = Chars}
	).
handle_sax({startElement, _Uri, "channel", _Prefix, _Attrs}, State = #rss2{tag = "rss"}) ->
    State#rss2{tag = "channel"};
?CHANNEL("title").

