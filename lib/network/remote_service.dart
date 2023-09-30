import 'package:rated/network/tvShow.dart';
import 'package:http/http.dart' as http;

class ZerothRemoteService{
  Future<List<TvShow>?> getShows() async{
    var client = http.Client();
    var uri =  Uri.parse('https://api.tvmaze.com/shows');
    var response = await client.get(uri);
    if(response.statusCode==200){
      var json = response.body;
      return tvShowFromJson(json);
    }
  }
}

class FirstRemoteService{
  Future<List<TvShow>?> getShows() async{
    var client = http.Client();
    var uri =  Uri.parse('https://api.tvmaze.com/shows?page=1');
    var response = await client.get(uri);
    if(response.statusCode==200){
      var json = response.body;
      return tvShowFromJson(json);
    }
  }
}

class SecondRemoteService{
  Future<List<TvShow>?> getShows() async{
    var client = http.Client();
    var uri =  Uri.parse('https://api.tvmaze.com/shows?page=2');
    var response = await client.get(uri);
    if(response.statusCode==200){
      var json = response.body;
      return tvShowFromJson(json);
    }
  }
}

class ThirdRemoteService{
  Future<List<TvShow>?> getShows() async{
    var client = http.Client();
    var uri =  Uri.parse('https://api.tvmaze.com/shows?page=3');
    var response = await client.get(uri);
    if(response.statusCode==200){
      var json = response.body;
      return tvShowFromJson(json);
    }
  }
}

class EigthRemoteService{
  Future<List<TvShow>?> getShows() async{
    var client = http.Client();
    var uri =  Uri.parse('https://api.tvmaze.com/shows?page=8');
    var response = await client.get(uri);
    if(response.statusCode==200){
      var json = response.body;
      return tvShowFromJson(json);
    }
  }
}
