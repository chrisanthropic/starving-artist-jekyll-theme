---
layout: post
title: "Mail Forwarding With Mailgun and CloudFlare"
date: 2014-12-03T20:35:05-08:00
sitemap:
  lastmod: 2014-12-03T20:35:05-08:00
  priority: 0.5
  changefreq: monthly
  exclude: 'no'
---

After moving my DNS from Namecheap to CloudFlare I lost the ability to use Namecheap as a mail forwarder. For anyone not sure what that is, essentially it allows you to receive email at anyname@your-domain.com and have it automatically forwarded somewhere else (like your personal Gmail account).

So, what I did is leverage a free account with [Mailgun](https://mailgun.com/) to setup the same thing.

## Mailgun Setup
* Create a Mailgun account
* Add your domain name (no www)
  `domain.com`
* Keep the page open and open a new tab to CloudFlare

## Cloudflare
* Choose your site and select `DNS Settings`
* Add the two `Text` records
* Add the `CNAME` record
  * Make sure the cloudflare cloud is gray and not orange/active
* Add the two `MX` records
  * **Name** `domain.com` (no www)
  * **Mail handled by** `mxa.mailgun.org` or `mxb.mailgun.org`

## Back at Mailgun
* Click `add`
  * Click `Check DNS Records Now`
* It'll tell you once it detects the updated DNS records

## Email Forwarding
* From Mailgun, choose `Routes`
* `Create Your First Route`
* **Priority** 10
* **Filter Expression** This is where you list the email address you want to forward to gmail
  `match_recipient("you@domain.com")`
* **Actions** This is the gmail address you want to receive your mail
  `forward("me@gmail.com")`
* **Description** Name it something so you remember what it's for

## Use Gmail to send mail from your domain
* Log in to Gmail and go to `settings`
* Go to `Accounts and Import`
* Go to `Send mail as` and select `add another email you own`
  * **name:** Anything you want
  * **email address:** name@domain.com (this should be the email you set up in the steps before)
  * Leave `treat as an alias` checked
  * Click `Next Step`
  * For the following info you'll need to login to mailgun and use the info under `Domain Information`
  * **SMTP Server** Use `SMTP Hostname` from Mailgun
  * **Username** Use `Default SMTP Login` from Mailgun
  * **Password** Use `Default Password` from Mailgun
  * Leave `Secured connection using TLS` selected
  * Click add account
* Once it's verified you should be able to compose emails and list your new email in the `from` line so nobody needs to know it's coming from your personal gmail account.  
