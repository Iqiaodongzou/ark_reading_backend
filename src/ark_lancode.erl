%%%-------------------------------------------------------------------
%%% @author Jordan
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. Feb 2024 10:50 AM
%%%-------------------------------------------------------------------
-module(ark_lancode).
-import(extbif, [to_list/1,to_binary/1]).
-behavior(cowboy_handler).
-export([init/2,main/1]).

init(Req0, State) ->
  Req1 = cowboy_req:set_resp_header(<<"access-control-allow-origin">>, <<$*>>, Req0),
  Req2 = cowboy_req:set_resp_header(<<"access-control-allow-methods">>, <<"POST">>, Req1),
  Req3 = cowboy_req:set_resp_header(<<"access-control-allow-headers">>, <<"content-type">>, Req2),
  Req = cowboy_req:reply(200,
    #{<<"content-type">> => <<"application/json">>},
    main(Req3),
    Req3),
  {ok, Req, State}.

main(Req0) ->
  Codes = prepare_dbdata(),
  io:format("show me data =====> ~p~n",[Codes]),
  ResData = [{resultData,Codes},
    {resultCode,200}],
  RespBody = jsx:encode(ResData),
  RespBody.

prepare_dbdata() ->
  Query = <<"SELECT * from language_country">>,
  Dbdata = emysql:query(Query,[]).
