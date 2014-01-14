MUSeo
=====

A small module for handle SEO better

SEO is important for websites.

Modules for Zikula have their own ways to create metatags like 'title', 'description' or 'keywords'.
Some Modules do not handle them at all.

The result is, that we get sites with the same title or description or keyword tag.

MUSeo will give a way to override or add metatags to the html code of any site of a website.

Version 1.1.0
=============

With MUSeo you are able to set specific metatags ( title, description, keywords, robots ) for every page of an module.

Configuration
----------------  

You have to enter the modules and the controllers you want to activate comma separated without whitespace.

Also you can enter a standard for the robots metatag.

There are default values set in the module vars.

MUSeo requires the following entries in your header template:
 
`<title>{pagegetvar name='title'}</title>`
`<meta name="description" content="{$metatags.description}" />`
`<meta name="keywords" content="{$metatags.keywords}" />`

At the moment MUSeo needs to set the metatag for robots once on the startpage (for example in the header.tpl or head.tpl).
For all other sites MUSeo is generating the metatag for robots automatically if set in the settings. 
Standard is: 

`<meta name="ROBOTS" content="index, follow" />`

Modules
---------------

After that you can create the modules and enter the relevant datas for each module.

Metatags
---------------

If you have created modules you can create metatags for each site of an module.
