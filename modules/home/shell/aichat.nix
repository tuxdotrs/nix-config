{...}: {
  programs = {
    aichat = {
      enable = true;
      settings = {
        model = "gemini:gemini-2.0-flash-lite";
        clients = [
          {
            type = "gemini";
          }
        ];
      };
    };
  };
}
