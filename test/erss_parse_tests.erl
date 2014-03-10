%%% @copyright (C) 2014, Imprivata
%%% @doc
%%% 
%%% @end
%%% Created :  9 Mar 2014 by Nathaniel Waisbrot <nwaisbrot@imprivata.com>
-module(erss_parse_tests).
-author('nwaisbrot@imprivata.com').

-include_lib("eunit/include/eunit.hrl").
-include("erss.hrl").

-define(WELLFORMED_DIR, "../test/data/wellformed").
-define(BASIC_DIR, "../test/data/basic").

parse_test_() ->
    {"Parsing RSS", [make_test("Basic RSS examples", ?BASIC_DIR)]}.

rss_2_test() ->
    {ok, Result} = erss_parse:parse_file([?BASIC_DIR, $/, "examples", $/, "sample-rss-2.xml"]),
    ?assertEqual(["Liftoff News"], Result#rss.title),
    ?assert(lists:any(fun (El) -> El#item.title =:= ["The Engine That Does More"] end, Result#rss.items)).

wellformed_test_x() ->
    make_test("well-formed RSS examples", ?WELLFORMED_DIR).
	
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

