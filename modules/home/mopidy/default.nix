{pkgs, ...}: {
  programs.ncmpcpp = {
    enable = true;
    package = pkgs.ncmpcpp.override {
      visualizerSupport = true;
      clockSupport = true;
    };
    mpdMusicDir = "~/Music/";

    settings = {
      mpd_host = "127.0.0.1";
      mpd_port = 6600;
      mpd_connection_timeout = 20;
      visualizer_data_source = "localhost:5555";
      visualizer_fps = 60;
      visualizer_output_name = "feed";
      visualizer_in_stereo = "yes";
      visualizer_type = "spectrum";
      visualizer_look = "▄▍";
      visualizer_spectrum_smooth_look = "yes";
      song_status_format = "$b$7♫ $2%a $4⟫$3⟫ $8%t $4⟫$3⟫ $5%b ";
      header_visibility = "no";
      color1 = "white";
      color2 = "green";
    };
  };

  services.mopidy = {
    enable = true;

    extensionPackages = with pkgs; [
      mopidy-mpd
      mopidy-spotify
      mopidy-soundcloud
      mopidy-iris
    ];
  };
}
