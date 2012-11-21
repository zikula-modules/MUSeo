{* Purpose of this template: Display metatags in text mailings *}
{foreach item='item' from=$items}
        {$item.titleOfEntity}
        {modurl modname='MUSeo' type='user' func='display' ot=$objectType id=$item.id fqurl=true}
-----
{foreachelse}
    {gt text='No metatags found.'}
{/foreach}
