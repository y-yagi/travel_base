module HeartRailsExpressApiHelper
  def set_station_mock
    stations_str = <<-DOC.strip_heredoc
      {"response":{"station":
        [{"x":134.997666,"next":"黒田庄","prev":"比延",
          "distance":"310m","y":35.002054,"line":"JR加古川線","postal":"6770039",
          "name":"日本へそ公園","prefecture":"兵庫県"},
         {"x":134.99574,"next":"日本へそ公園","prev":"新西脇",
          "distance":"1310m","y":34.988777,"line":"JR加古川線","postal":"6770033"
          ,"name":"比延","prefecture":"兵庫県"}
        ]
      }}
    DOC
    stub_request(:any, /.*express.heartrails.com.*/).
      to_return(status: 200, body: stations_str, headers: {})
  end
end
