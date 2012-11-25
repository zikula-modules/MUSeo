{* Purpose of this template: Display modules in html mailings *}
{*
<ul>
{foreach item='item' from=$items}
    <li>
        <a href="{modurl modname='MUSeo' type='user' func='main' fqurl=true}
">{$item.name}
</a>
    </li>
{foreachelse}
    <li>{gt text='No modules found.'}</li>
{/foreach}
</ul>
*}

{include file='contenttype/itemlist_Module_display_description.tpl'}
