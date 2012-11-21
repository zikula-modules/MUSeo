{* Purpose of this template: Display metatags in html mailings *}
{*
<ul>
{foreach item='item' from=$items}
    <li>
        <a href="{modurl modname='MUSeo' type='user' func='main' fqurl=true}
">{$item.titleOfEntity}
</a>
    </li>
{foreachelse}
    <li>{gt text='No metatags found.'}</li>
{/foreach}
</ul>
*}

{include file='contenttype/itemlist_Metatag_display_description.tpl'}
