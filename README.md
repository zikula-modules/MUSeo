# MUSeo

A small Zikula module for improved SEO handling.

SEO is important for websites.

Modules for Zikula have their own ways to create metatags like 'title', 'description' or 'keywords'.
Some modules do not handle them at all yet.
The result is that sites use the same title or description or keyword tag on all pages.

MUSeo provides a way to override or add metatags to the html code of any page of a website.

## Version 1.1.0

With MUSeo you are able to set specific metatags (title, description, keywords, robots) for arbitrary pages.

### Configuration

You have to enter desired modules and controllers (comma separated without whitespace) for which you want to activate enhanced SEO capabilities.

Also you can enter a default for the robots metatag.

MUSeo requires the following entries in your header template:

```
    <title>{pagegetvar name='title'}</title>
    <meta name="description" content="{$metatags.description}" />
    <meta name="keywords" content="{$metatags.keywords}" />
```

At the moment MUSeo needs to set the metatag for robots once on the start page (for example in the header.tpl or head.tpl file).
For all other pages MUSeo generates the robots metatag automatically if it has been configured in the settings.
The default value is as follows:

`<meta name="ROBOTS" content="index, follow" />`

### Modules

After the initial configuration you can create module references and enter the relevant data for them.

### Metatags

After you have created module references you can create metatags for each page of the corresponding modules.

## Version 2.0.0

MUSeo is currently being developed. It is going to offer more sophisticated SEO settings.

More information coming soon.

Some parts of MUSeo are based on https://yoast.com/wordpress/plugins/seo/ and https://github.com/Yoast/wordpress-seo/.
