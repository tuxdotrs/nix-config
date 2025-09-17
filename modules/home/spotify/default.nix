{
  programs.spotify-player = {
    enable = true;
    settings = {
      theme = "default";
      client_id = "c54c06bacd3642c68d981474dadd3a53";
      login_redirect_uri = "http://127.0.0.1:8989/login";
      device = {
        name = "spotify-player";
        device_type = "speaker";
        volume = 100;
        bitrate = 320;
        audio_cache = false;
        normalization = false;
        autoplay = false;
      };
    };
  };
}
