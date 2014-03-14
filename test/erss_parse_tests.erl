%%% @copyright (C) 2014, Nathaniel Waisbrot
%%% @doc
%%% 
%%% @end
%%% Created :  9 Mar 2014 by Nathaniel Waisbrot <code@waisbrot.net>
-module(erss_parse_tests).
-author('code@waisbrot.net').

-include_lib("eunit/include/eunit.hrl").
-include("erss.hrl").

-define(WELLFORMED_DIR, "../test/data/wellformed").
-define(BASIC_DIR, "../test/data/basic").

parse_test_() ->
    {"Parsing RSS", [make_test("Basic RSS examples", ?BASIC_DIR)
		    ,make_test("well-formed RSS examples", ?WELLFORMED_DIR)
		    ]}.

rss_2_test() ->
    {ok, Result} = erss_parse:parse_file([?BASIC_DIR, $/, "examples", $/, "sample-rss-2.xml"]),
    #{ "title" := Title, "item" := Items, type := Type, version := Version } = Result,
    ?assertEqual(<<"Liftoff News">>, Title),
    ?assertEqual(rss, Type),
    ?assertEqual(<<"2.0">>, Version),
    ?assert(lists:any(fun (#{"title" := ElTitle}) -> ElTitle =:= <<"The Engine That Does More">> end, Items)).

make_test(Description, Dir) ->
    {ok, Filenames} = file:list_dir_all(Dir),
    {Description, rss_suites(Dir, Filenames)}.

rss_suites(Root, [Dirname|Rest]) ->
    {generator, fun () -> 
			Dir = [Root, $/, Dirname],
			{ok, Filenames} = file:list_dir_all(Dir),
			[{Dirname, rss_examples(Dir, Filenames)} 
			 | rss_suites(Root, Rest)]
		end};
rss_suites(_Root, []) ->
    {generator, fun () -> [] end}.

rss_examples(Root, [Filename|Rest]) ->
    {generator, fun () -> [{Filename, rss_example(Root, Filename)} | rss_examples(Root, Rest)] end};
rss_examples(_Root, []) ->
    {generator, fun () -> [] end}.

rss_example(Root, Filename) ->
    ?_assertMatch({ok, _}, erss_parse:parse_file([Root, $/, Filename])).

