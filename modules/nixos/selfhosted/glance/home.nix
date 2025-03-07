{
  page = {
    name = "Dashboard - tux";
    width = "slim";
    hide-desktop-navigation = true;
    center-vertically = true;
    columns = [
      {
        size = "full";
        widgets = [
          {
            type = "search";
            autofocus = true;
          }
          {
            type = "markets";
            markets = [
              {
                symbol = "BTC-USD";
                name = "Bitcoin";
                chart-link = "https://www.tradingview.com/chart/?symbol=INDEX:BTCUSD";
              }
              {
                symbol = "ETH-USD";
                name = "Ethereum";
                chart-link = "https://www.tradingview.com/chart/?symbol=INDEX:ETHUSD";
              }
              {
                symbol = "SOL-USD";
                name = "Solana";
                chart-link = "https://www.tradingview.com/chart/?symbol=INDEX:SOLUSD";
              }
            ];
          }
          {
            type = "monitor";
            cache = "1m";
            title = "Services";
            sites = [
              {
                title = "Gitea";
                url = "https://git.tux.rs";
                icon = "si:gitea";
              }
              {
                title = "Vaultwarden";
                url = "https://bw.tux.rs";
                icon = "si:vaultwarden";
              }
              {
                title = "Ntfy";
                url = "https://ntfy.tux.rs";
                icon = "si:ntfy";
              }
              {
                title = "Grafana";
                url = "https://grafana.tux.rs";
                icon = "si:grafana";
              }
              {
                title = "SearXNG";
                url = "https://sx.tux.rs";
                icon = "si:searxng";
              }
              {
                title = "Wakapi";
                url = "https://wakapi.tux.rs";
                icon = "si:wakatime";
              }
            ];
          }
          {
            type = "reddit";
            subreddit = "selfhosted";
            style = "horizontal-cards";
          }
          {
            type = "reddit";
            subreddit = "homelab";
            style = "horizontal-cards";
          }
        ];
      }
    ];
  };
}
