// latte / frappe / macchiato / mocha
const palette = mocha;

const default_config = {
  overrideStorage: true,
  temperature: {
    location: "Guilin",
    scale: "C",
  },
  clock: {
    format: "h:i",
    iconColor: palette.maroon,
  },
  disabled: [],
  fastlink: "https://howl-24.github.io/",
  openLastVisitedTab: true,
  tabs: [
    {
      name: "myself",
      background_url: "src/img/banners/cbg-15.gif",
      categories: [
        {
          name: "howl",
          links: [
            {
              name: "Howl-24",
              url: "https://github.com/Howl-24",
              icon: "brand-github",
              icon_color: palette.green,
            },
          ],
        },
        {
          name: "workspace",
          links: [
            {
              name: "mail",
              url: "https://outlook.live.com",
              icon: "mail",
              icon_color: palette.green,
            },
            {
              name: "drive",
              url: "https://onedrive.live.com",
              icon: "brand-onedrive",
              icon_color: palette.peach,
            },
          ],
        },
        {
          name: "selfhost",
          links: [
            {
              name: "homepage",
              url: "https://homepage.scaphium.xyz",
              icon: "home",
              icon_color: palette.green,
            },
            {
              name: "jellyfin",
              url: "http://pi.scaphium.xyz:8096/",
              icon: "player-play",
              icon_color: palette.peach,
            },
            {
              name: "qbittorrent",
              url: "https://qbittorrent.scaphium.xyz",
              icon: "download",
              icon_color: palette.red,
            },
            {
              name: "pihole",
              url: "http://pi.scaphium.xyz:8080/admin",
              icon: "network",
              icon_color: palette.blue,
            },
          ],
        },
      ],
    },
    {
      name: "dev",
      background_url: "src/img/banners/cbg-07.gif",
      categories: [
        {
          name: "development",
          links: [
            {
              name: "github",
              url: "https://github.com",
              icon: "brand-github",
              icon_color: palette.green,
            },
            {
              name: "stackoverflow",
              url: "https://stackoverflow.com",
              icon: "brand-stackoverflow",
              icon_color: palette.peach,
            },
            {
              name: "musicForProgramming();",
              url: "https://musicforprogramming.net",
              icon: "binary-tree",
              icon_color: palette.red,
            },
          ],
        },
        {
          name: "ai",
          links: [
            {
              name: "chatgpt",
              url: "https://chat.openai.com",
              icon: "brand-openai",
              icon_color: palette.green,
            },
            {
              name: "deepseek",
              url: "https://chat.deepseek.com",
              icon: "robot",
              icon_color: palette.peach,
            },
          ],
        },
        {
          name: "resources",
          links: [
            {
              name: "hackernews",
              url: "https://news.ycombinator.com",
              icon: "brand-redhat",
              icon_color: palette.green,
            },
            {
              name: "archwiki",
              url: "https://wiki.archlinux.org",
              icon: "search",
              icon_color: palette.peach,
            },
          ],
        },
      ],
    },
    {
      name: "chi ll",
      background_url: "src/img/banners/cbg-08.gif",
      categories: [
        {
          name: "video",
          links: [
            {
              name: "youtube",
              url: "https://www.youtube.com",
              icon: "brand-youtube",
              icon_color: palette.green,
            },
            {
              name: "bilibili",
              url: "https://www.bilibili.com",
              icon: "brand-bilibili",
              icon_color: palette.peach,
            },
            {
              name: "bangumi",
              url: "https://bgm.tv/",
              icon: "device-tv",
              icon_color: palette.red,
            },
          ],
        },
        {
          name: "social",
          links: [
            {
              name: "reddit",
              url: "https://www.reddit.com/r/unixporn",
              icon: "brand-reddit",
              icon_color: palette.green,
            },
            {
              name: "twitter",
              url: "https://www.twitter.com",
              icon: "brand-twitter",
              icon_color: palette.peach,
            },
            {
              name: "telegram",
              url: "https://web.telegram.org",
              icon: "brand-telegram",
              icon_color: palette.red,
            },

          ],
        },
        {
          name: "game",
          links: [
            {
              name: "steam",
              url: "https://store.steampowered.com",
              icon: "brand-steam",
              icon_color: palette.green,
            },
            {
              name: "steamdb",
              url: "https://steamdb.info",
              icon: "database",
              icon_color: palette.peach,
            },
            {
              name: "isthereanydeal",
              url: "https://isthereanydeal.com",
              icon: "shopping-cart-discount",
              icon_color: palette.red,
            },
          ],
        },
      ],
    },
  ],
};

const CONFIG = new Config(default_config, palette);

const root = document.querySelector(":root");
root.style.setProperty("--bg", palette.mantle);
root.style.setProperty("--accent", palette.green);
