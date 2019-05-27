import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:music_app/src/blocs/global.dart';
import 'package:music_app/src/common/music_icons.dart';
import 'package:music_app/src/models/playerstate.dart';
import 'package:provider/provider.dart';

class SongTile extends StatelessWidget {
  final Song _song;
  String _artists;
  String _duration;
  SongTile({Key key, @required Song song})
      : _song = song,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);
    parseArtists();
    parseDuration();
    return StreamBuilder<MapEntry<PlayerState, Song>>(
        stream: _globalBloc.musicPlayerBloc.playerState$,
        builder: (BuildContext context,
            AsyncSnapshot<MapEntry<PlayerState, Song>> snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          final PlayerState _state = snapshot.data.key;
          final Song _currentSong = snapshot.data.value;
          final bool _isSelectedSong = _song == _currentSong;
          return Container(
            height: 90,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: _isSelectedSong
                  ? LinearGradient(
                      colors: [
                        Color(0xFFDDEAF2).withOpacity(0.7),
                        Colors.white,
                      ],
                    )
                  : LinearGradient(
                      colors: [
                        Colors.white,
                        Colors.white,
                      ],
                    ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: <Widget>[
                  Flexible(
                    flex: 2,
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.centerLeft,
                      child: _isSelectedSong && _state == PlayerState.playing
                          ? PauseIcon(
                              color: Color(0xFF6D84C1),
                            )
                          : PlayIcon(
                              color: Color(0xFFA1AFBC),
                            ),
                    ),
                  ),
                  Flexible(
                    flex: 8,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Container(
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              _song.title,
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF4D6B9C),
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Divider(
                              height: 10,
                              color: Colors.transparent,
                            ),
                            Text(
                              _artists,
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFFAAB7CB),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.centerRight,
                      child: Text(
                        _duration,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF94A6C5),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void parseDuration() {
    final double _temp = _song.duration / 1000;
    final int _minutes = (_temp / 60).floor();
    final int _seconds = (((_temp / 60) - _minutes) * 60).round();
    if (_seconds.toString().length != 1) {
      _duration = _minutes.toString() + ":" + _seconds.toString();
    } else {
      _duration = _minutes.toString() + ":0" + _seconds.toString();
    }
  }

  void parseArtists() {
    _artists = _song.artist.split(";").reduce((String a, String b) {
      return a + " & " + b;
    });
  }
}