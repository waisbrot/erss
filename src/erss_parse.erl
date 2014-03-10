%%% @copyright (C) 2014, Imprivata
%%% @doc
%%% Parse XML that represents RSS or Atom feeds and produce an Erlang
%%% record.
%%% Strings returned by this code are IO-lists (deep lists).
%%% @end
%%% Created :  9 Mar 2014 by Nathaniel Waisbrot <nwaisbrot@imprivata.com>
-module(erss_parse).
-author('nwaisbrot@imprivata.com').

-export([parse_file/1, parse_string/1]).
-include("erss.hrl").
-include_lib("xmerl/include/xmerl.hrl").

-spec parse_file(string()) -> {ok, #rss{}}.
parse_file(Filename) ->
    {ok, Binary} = file:read_file(Filename),
    parse_string(Binary).

-spec parse_string(string() | binary()) -> {ok, #rss{}}.
parse_string(XmlString) when is_binary(XmlString) ->
    parse_string(binary_to_list(XmlString));
parse_string(XmlString) when is_list(XmlString) ->
    %% Remove whitespace-only text elements
    Acc = fun(#xmlText{value = " ", pos = P}, Acc, S) ->
		  {Acc, P, S};
	     (X, Acc, S) ->
		  {[X|Acc], S}
	  end,
    {Element, []} = xmerl_scan:string(XmlString, [{space, normalize}, {acc_fun, Acc}]),
    case decode_rss(Element) of
	RssData = #rss{} ->
	    {ok, RssData}
    end.

decode_rss([Element]) ->
    decode_rss(Element);    
decode_rss(#xmlElement{name = rss, attributes = Attrs, content = Content}) ->
    [_Version] = lists:filtermap(fun (#xmlAttribute{name = version, value = Vers}) -> {true, Vers};
				    (_) -> false
				end,
				Attrs),
    decode_rss(Content);
decode_rss(#xmlElement{name = channel, content = Content}) ->
    decode_rss(Content, #rss{}).

-define(channel_element(Name), 
	decode_rss([#xmlElement{name = Name, content = Content} | Rest], State) ->
	       decode_rss(Rest, State#rss{Name = extract_text(Content)})).
decode_rss([], State) ->
    State;
decode_rss([#xmlElement{name = item, content = Content}|Rest], State) ->
    decode_rss(Rest, State#rss{items = [decode_item(Content, #item{}) | State#rss.items]});
?channel_element(title);
?channel_element(link);
?channel_element(description);
?channel_element(language);
?channel_element(copyright);
?channel_element(managingEditor);
?channel_element(webMaster);
?channel_element(pubDate);
?channel_element(lastBuildDate);
?channel_element(category);
?channel_element(generator);
?channel_element(docs);
?channel_element(cloud);
?channel_element(ttl);
decode_rss([#xmlElement{name = image, content = Content}|Rest], State) ->
    decode_rss(Rest, State#rss{image = decode_image(Content, #image{})});
?channel_element(image);
?channel_element(rating);
?channel_element(textInput);
?channel_element(skipHours);
?channel_element(skipDays).

-define(item_element(Name),
	decode_item([#xmlElement{name = Name, content = Content}| Rest], State) ->
	       decode_item(Rest, State#item{Name = extract_text(Content)})).
decode_item([], State) ->
    State;
?item_element(title);
?item_element(link);
?item_element(description);
?item_element(author);
?item_element(category);
?item_element(comments);
?item_element(enclosure);
?item_element(guid);
?item_element(pubDate);
?item_element(source).

extract_text(List) when is_list(List) ->
    extract_text(List, []).
extract_text([#xmlText{value = Text}|Rest], Acc) ->
    extract_text(Rest, [Text | Acc]);
extract_text([], Acc) ->
    Acc.

-define(image_element(Name),
	decode_image([#xmlElement{name = Name, content = Content}|Rest], State) ->
	       decode_image(Rest, State#image{Name = extract_text(Content)})).
?image_element(title);
?image_element(url);
?image_element(link);
?image_element(width);
?image_element(height);
?image_element(description);
decode_image([], State) ->
    State.
