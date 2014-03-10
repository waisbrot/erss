%%% @copyright (C) 2014, Imprivata
%%% @doc
%%% 
%%% @end
%%% Created :  9 Mar 2014 by Nathaniel Waisbrot <nwaisbrot@imprivata.com>
-module(erss_parse).
-author('nwaisbrot@imprivata.com').

-export([parse_file/1]).
-include("erss.hrl").

-spec parse_file(string()) -> ok.
parse_file(Filename) ->
    {ok, Binary} = file:read_file(Filename),
    {Element, Rest} = xmerl_scan:string(Binary),
    io:format("Result = ~p ~p~n", [Element, Rest]),
    AccOut#rss2.title,
    ok.

handle_sax(startDocument, State) ->
    State;
handle_sax(endDocument, State) ->
    State;
handle_sax({startPrefixMapping, _Prefix, _URI}, State) ->
    State;
handle_sax({endPrefixMapping, _Prefix}, State) ->
    State;

handle_sax({startElement, _Uri, "rss", _Prefix, [#attribute{localName = "version", value = <<"2.0">>}|_RestAttrs]}, no_state) ->
    io:format("rss 2.0~n",[]),
    #rss2{tag = "rss"};
handle_sax({startElement, Uri, "rss", Prefix, [_HeadAttr|RestAttrs]}, no_state) ->
    handle_sax({startElement, Uri, "rss", Prefix, RestAttrs}, no_state);
handle_sax({startElement, _Uri, _LocalName, _Prefix, _Attributes}, no_state) ->
    no_state;
handle_sax(Start = {startElement, _, _, _, _}, State = #rss2{}) ->
    erss_rss:handle_sax(Start, State);

handle_sax({endElement, _Uri, _LocalName, _Prefix}, State) ->
    State;
handle_sax({characters, _Characters}, State) ->
    State;
handle_sax({ignorableWhitespace, _Characters}, State) ->
    State;
handle_sax({processingInstruction, _Target, _Data}, State) ->
    State.

