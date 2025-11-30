import { SiteConfig } from "@/types/siteConfig";

export const BASE_URL = process.env.NEXT_PUBLIC_SITE_URL || "https://hachimifigure.com";

const TWITTER_URL = ''
const DISCORD_URL = process.env.NEXT_PUBLIC_DISCORD_INVITE_URL
const EMAIL_URL = 'contact@hachimifigure.com'

export const siteConfig: SiteConfig = {
  name: "HachimiFigure",
  url: BASE_URL,
  authors: [
    {
      name: "HachimiFigure",
      url: "https://hachimifigure.com",
    }
  ],
  creator: '@HachimiFigure',
  socialLinks: {
    twitter: TWITTER_URL,
    discord: DISCORD_URL,
    email: EMAIL_URL,
  },
  themeColors: [
    { media: '(prefers-color-scheme: light)', color: '#faf5ff' },
    { media: '(prefers-color-scheme: dark)', color: '#0f0a1a' },
  ],
  defaultNextTheme: 'dark',
  icons: {
    icon: "/favicon.ico",
    shortcut: "/logo.png",
    apple: "/logo.png",
  },
}
